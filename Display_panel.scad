// Plate dimensions
plate_length = 700;
plate_width = 420;
plate_thickness = 10;
corner_radius = 20;
plate_x = plate_length - 2*corner_radius;
plate_y = plate_width - 2*corner_radius;

// Pin and hole dimensions
pin_radius = 6 / 2;
pin_height = 10;
hole_radius = 6 / 2;
pin_hole_spacing = 15;
num_pins_x = 4;
num_pins_y = 3;

// Led slit dimensions
slit_width = 10;
slit_depth = 3; // 3
slit_length = 600;
slit_padding = 60;
nums_slits = 5;

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
    for (i = [1 : n_y-2]) {
        y = i * plate_y / (n_y-1) - plate_y / 2;
        xy_pin( x_offset, y, pin_radius);
        xy_pin(-x_offset, y, pin_radius);
    }

}

module light_slits(n) {
    space = plate_y - 2*slit_padding;
    for (i = [0 : n-1]) {
        y_off = i * (space / (n-1)) - space / 2;
        z_off = plate_thickness/2;
        translate([0, y_off, z_off]) cube(
            [slit_length, slit_width, slit_depth*2], 
            center=true
        );
    }
}


module display() {
    difference() {
        union() {
            // The base plate
            rounded_plate(plate_length, plate_width, plate_thickness, corner_radius);
            // The pins
            edge_pins(num_pins_x, num_pins_y, pin_radius, false);
        }
        edge_pins(num_pins_x, num_pins_y, pin_radius, true);
        light_slits(5);
    }
}

// Draw the plate
display();