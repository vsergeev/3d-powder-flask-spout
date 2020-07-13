/********************************************************
 * Parametric Powder Flask Spout - vsergeev
 * https://github.com/vsergeev/3d-powder-flask-spout
 * CC-BY-4.0
 *
 * Release Notes
 *  * v1.0 - 07/13/2020
 *      * Initial release.
 ********************************************************/

/* [Basic] */

// in gr
volume_gr = 25;

/* [Hidden] */

$fn = $preview ? 0 : 50;
fragments = $preview ? 5 : 100;

/* Condensed from https://github.com/vsergeev/3d-simple-iso-thread */
module simple_iso_thread(diameter, pitch, height, chamfer_top=0, chamfer_bottom=0, fragments=100) {
    h = pitch / (2 * tan(30));

    /* Clearances from ideal for major and minor radiuses */
    c_maj = -(h / 8);
    c_min = -(h / 8);

    /* Major and minor radiuses */
    r_maj = diameter / 2 + c_maj;
    r_min = diameter / 2 - (5 * h / 8) + c_min;

    /* Major and minor widths, with scaling for additional clearance */
    w_maj = 2 * tan(30) * (h / 8 - c_maj) * 0.50; /* adjusted from 0.75 */
    w_min = 2 * tan(30) * (h / 4 + c_min);

    /* Total degrees to turn thread */
    degrees = (height / pitch) * 360;

    intersection() {
        difference() {
            /* Threads with additional 360 degrees above and below */
            for (d = [-360:360 / fragments:degrees + 360]) {
                translate([0, 0, d * (pitch / 360)]) rotate(d) rotate_extrude(angle = 360 / fragments) polygon([
                    [0, pitch / 2], [r_min, pitch / 2], [r_min, pitch / 2 - w_min / 2], [r_maj, w_maj / 2],
                    [r_maj, -w_maj / 2], [r_min, -(pitch / 2 - w_min / 2)], [r_min, -pitch / 2], [0, -pitch / 2]
                ]);
            }
            /* Bottom chamfer profile */
            if (chamfer_bottom > 0) {
                rotate_extrude() polygon([
                    [r_maj - 1.5 * chamfer_bottom, -chamfer_bottom / 2],
                    [r_maj + chamfer_bottom / 2, -chamfer_bottom / 2],
                    [r_maj + chamfer_bottom / 2, 1.5 * chamfer_bottom]
                ]);
            }
            /* Top chamfer profile */
            if (chamfer_top > 0) {
                rotate_extrude() polygon([
                    [r_maj - 1.5 * chamfer_top, height + chamfer_top / 2],
                    [r_maj + chamfer_top / 2, height + chamfer_top / 2],
                    [r_maj + chamfer_top / 2, height - 1.5 * chamfer_top]
                ]);
            }
        }
        /* Bounding cylinder (intersected) */
        cylinder(h = height, r = r_maj * 2);
    }
}

module powder_flask_spout(volume_gr) {
    assert(volume_gr >= 5, "Volume below minimum of 5 grains.");

    base_height = 6;
    bore_diameter = 6.5;
    bore_thickness = 2;

    total_volume = (volume_gr / 15) * 1000;
    base_volume = PI * pow(bore_diameter / 2, 2) * base_height;
    cone_volume = total_volume - base_volume;
    cone_height = cone_volume / (PI * pow(bore_diameter / 2, 2));

    echo(str("Total Volume: ", volume_gr, " gr = ", volume_gr / 15, " cc = ", total_volume, " mm^3"));
    echo(str("Base Volume: ", base_volume, " mm^3"));
    echo(str("Cone Volume: ", cone_volume, " mm^3"));
    echo(str("Cone Height: ", cone_height, " mm"));

    difference() {
        /* Body */
        union() {
            /* Cone */
            translate([0, 0, base_height])
                cylinder(h=cone_height, d1=11, d2=bore_diameter + bore_thickness);
            /* Base */
            translate([0, 0, base_height - 1.25])
                cylinder(h=1.25, d=11);
            /* Transition from threads to base */
            translate([0, 0, base_height - 2.50])
                cylinder(h=1.25, d1=8.5, d2=11);
            /* Threads */
            simple_iso_thread(10, 1, 4, chamfer_top=0.5, chamfer_bottom=0.5, fragments=fragments);
        }
        /* Bore */
        translate([0, 0, -1])
            cylinder(h=base_height + cone_height + 2, d=bore_diameter);
    }
}

powder_flask_spout(volume_gr);
