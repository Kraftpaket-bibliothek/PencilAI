// =========================================================================
// PencilAI - Reference Ballpoint Pen & Internal Cartridge
// File: CAD Modelling/Pen/reference_pen.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
pen_diameter_val  = PEN_DIAMETER_DEFAULT; // 9.0 mm standard
show_internal_refill = true;               // Internal ink reservoir cartridge
show_pocket_clip     = true;               // Metal shirt pocket clip
cutaway_pen          = false;              // Half-section cutaway view

module reference_ballpoint_pen(
    d = pen_diameter_val,
    tape_w = STRIP_WID,
    cutaway = cutaway_pen
) {
    r = d / 2;

    difference() {
        union() {
            // 1. Lower Grip Barrel (Directly underneath the smart tape)
            color(C_PEN_BARREL)
                translate([0, 0, -6.0])
                    cylinder(r = r, h = tape_w + 35.0, $fn = 96);

            // 2. Chrome Nose Cone (Conical taper from barrel down to writing tip collar)
            color(C_PEN_CHROME) {
                // Main tapered cone
                translate([0, 0, -18.0])
                    cylinder(r1 = 1.25, r2 = r, h = 12.0, $fn = 96);

                // Chrome decorative accent ring above the grip zone
                translate([0, 0, tape_w + 2.0])
                    cylinder(r = r + 0.15, h = 1.6, $fn = 96);

                // Upper barrel rear end plug
                translate([0, 0, tape_w + 70.0])
                    cylinder(r1 = r, r2 = r - 0.4, h = 8.0, $fn = 96);
            }

            // 3. Machined Brass Nib Collar & Tungsten Carbide Ball
            // Brass collar
            color(C_PEN_BRASS)
                translate([0, 0, -22.0])
                    cylinder(r1 = 0.50, r2 = 1.25, h = 4.0, $fn = 48);

            // 0.7mm Ballpoint Nib
            color(C_PEN_BALL)
                translate([0, 0, -22.35])
                    sphere(d = 0.70, $fn = 32);

            // 4. Upper Barrel Body (Extending up to pen cap / clicker)
            color(C_PEN_BARREL)
                translate([0, 0, tape_w + 3.6])
                    cylinder(r = r, h = 66.4, $fn = 96);

            // 5. Metal Pocket Clip
            if (show_pocket_clip) {
                color(C_PEN_CHROME) {
                    // Retention collar
                    translate([0, 0, tape_w + 62.0])
                        difference() {
                            cylinder(r = r + 0.4, h = 3.5, $fn = 96);
                            translate([0, 0, -0.1])
                                cylinder(r = r - 0.05, h = 3.7, $fn = 96);
                        }
                    // Spring clip arm
                    translate([r + 0.35, -1.2, tape_w + 22.0])
                        cube([0.8, 2.4, 42.0]);
                    // Angled clip end tab
                    translate([r + 0.35, -1.2, tape_w + 20.0])
                        rotate([0, 25, 0])
                            cube([0.8, 2.4, 3.5]);
                }
            }

            // 6. Internal Ink Refill Cartridge
            if (show_internal_refill) {
                // Clear Polypropylene Tube
                color([0.95, 0.95, 0.98, 0.45])
                    translate([0, 0, -17.0])
                        difference() {
                            cylinder(r = 1.5, h = tape_w + 75.0, $fn = 48);
                            translate([0, 0, -0.1])
                                cylinder(r = 1.1, h = tape_w + 75.2, $fn = 48);
                        }

                // Internal Blue Ink Column
                color(C_PEN_INK)
                    translate([0, 0, -16.5])
                        cylinder(r = 1.05, h = tape_w + 60.0, $fn = 48);
            }
        }

        // Optional Cutaway Section
        if (cutaway) {
            translate([0, -r * 2.5, -30])
                cube([r * 3, r * 5, tape_w + 120]);
        }
    }
}

// Standalone Render
reference_ballpoint_pen();
