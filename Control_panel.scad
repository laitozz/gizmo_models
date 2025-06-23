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

// Encoder dimensions
encoder_radius = 8 / 2;
encoder_num_x = 5;
encoder_num_y = 2;
encoder_padding = 40;

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

module encoder_holes(n_x, n_y) {
    space_y = plate_y - encoder_padding*2;
    space_x = plate_x - encoder_padding*2;
    for (i = [0 : n_x-1]) {
        for (j = [1 : n_y]) {
            y_off = j * (space_y / (n_y)) - space_y / 2;
            echo(y_off);
            x_off = i * (space_x / (n_x-1)) - space_x / 2;
            xy_pin(x_off, y_off, encoder_radius);
        }
    }
}

pin_x = (plate_length - 2*corner_radius)/2;
pin_y = (plate_width - 2*corner_radius)/2;
hole_y = pin_y - pin_hole_spacing;
// Draw the plate
difference() {
    union() {
        // The base plate
        rounded_plate(plate_length, plate_width, plate_thickness, corner_radius);
        
        // The pins
		for (i = [0 : 1 : len(dirs)-2])
        {
            xy_pin(dirs[i] * pin_x, dirs[i+1] * pin_y, pin_radius);
        }
        for (dir = [1, -1])
        {
            xy_pin(0, dir * pin_y, pin_radius);
        }
    }

    // The holes
	for (i = [0 : 1 : len(dirs)-2])
	{
        xy_pin(dirs[i] * pin_x, dirs[i+1] * hole_y, pin_radius);
	}        
    for (dir = [1, -1])
    {
        xy_pin(0, dir * hole_y, pin_radius);
    }
    // Cutouts for rotary encoders
    encoder_holes(encoder_num_x, encoder_num_y);
    
}