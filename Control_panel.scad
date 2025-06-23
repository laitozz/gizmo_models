// Plate dimensions
plate_length = 400;
plate_width = 240;
plate_thickness = 10;
corner_radius = 20;

// Pin and hole dimensions
pin_radius = 6 / 2;
pin_height = 10;
hole_radius = 6 / 2;
pin_hole_spacing = 15;

dims = [
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


dir_x = (plate_length - 2*corner_radius)/2;
dir_y = (plate_width - 2*corner_radius)/2;
hole_y = dir_y - pin_hole_spacing;
// Draw the plate
difference() {
    union() {
        // The base plate
        rounded_plate(plate_length, plate_width, plate_thickness, corner_radius);
        
        // The pins
		for (i = [0 : 1 : len(dims)-2])
        {
            xy_pin(dims[i] * dir_x, dims[i+1] * dir_y, pin_radius);
        }
        for (dim = [1, -1])
        {
            xy_pin(0, dim * dir_y, pin_radius);
        }
    }

    // The holes
	for (i = [0 : 1 : len(dims)-2])
	{
        xy_pin(dims[i] * dir_x, dims[i+1] * hole_y, pin_radius);
	}        
    for (dim = [1, -1])
    {
        xy_pin(0, dim * hole_y, pin_radius);
    }
}
