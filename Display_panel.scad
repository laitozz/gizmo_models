// Plate dimensions
plate_length = 400;
plate_width = 240;
plate_thickness = 10;
corner_radius = 20;
plate_x = plate_length - 2*corner_radius;
plate_y = plate_width - 2*corner_radius;

// Pin and hole dimensions
pin_radius = 6 / 2;
pin_height = 10;
hole_radius = 6 / 2;
pin_hole_spacing = 15;

dirs = [
    1,
	-1,
	-1,
	1,
    1,
];

// Rounded plate module
module rounded_plate(length, width, height, radius) {
	minkowski() {
		cube([length - 2*radius, width - 2*radius, height/2], center=true);
		cylinder(h=height/2, r=radius, $fn=64, center=true);
	}
}

// Module for the pins and the holes
module xy_pin(x, y, r) {
    z = -plate_thickness / 2;
    translate([x, y, z]) cylinder(
        h=pin_height + plate_thickness,
        r=r,
        $fn=64
    );
}

module edge_pins(n_x, n_y, r, cutout) {
    cut_offset = cutout ? pin_hole_spacing : 0;
    x_offset = plate_x/2 - cut_offset;
    y_offset = plate_y/2 - cut_offset;
    for (i = [0 : n_x-1]) {
        x = i * plate_x / (n_x-1) - plate_x / 2;
        xy_pin(x,  y_offset, pin_radius);
        xy_pin(x, -y_offset, pin_radius);
    }
    for (i = [0 : n_y-1]) {
        y = i * plate_y / (n_y-1) - plate_y / 2;
        xy_pin( x_offset, y, pin_radius);
        xy_pin(-x_offset, y, pin_radius);
    }

}

// Draw the plate
difference() {
    union() {
        // The base plate
        rounded_plate(plate_length, plate_width, plate_thickness, corner_radius);
        // The pins
        edge_pins(4, 3, pin_radius, false);
    }
    edge_pins(4, 3, hole_radius, true);
}
