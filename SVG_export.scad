use <Control_panel.scad>
use <Display_panel.scad>

part = 1;
 
// Display panel base
if (part == 1) {
    projection(cut=true) {
        translate([0, 0, -5]) display();
    }
}
// Display panel knobs
if (part == 2) {
    projection(cut=true) {
        translate([0, 0, -10]) display();
    }
}

// Control panel base
if (part == 3) {
	!projection(cut=true) {
		control();
	}
}

// Control panel knobs
if (part == 4) {
	projection(cut=true) {
		translate([0, 0, -10]) control();
	}
}
