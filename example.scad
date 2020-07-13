use <powder_flask_spout.scad>

powder_flask_spout(15);
translate([-7.5, -20, 0]) text("15 gr", size=5);

translate([20, 0, 0]) powder_flask_spout(20);
translate([12.5, -20, 0]) text("20 gr", size=5);

translate([40, 0, 0]) powder_flask_spout(25);
translate([32.5, -20, 0]) text("25 gr", size=5);

translate([60, 0, 0]) powder_flask_spout(30);
translate([52.5, -20, 0]) text("30 gr", size=5);

translate([80, 0, 0]) powder_flask_spout(35);
translate([72.5, -20, 0]) text("35 gr", size=5);
