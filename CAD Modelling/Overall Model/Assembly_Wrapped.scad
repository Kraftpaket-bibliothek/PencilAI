// =========================================================================
// PencilAI - Master Wrapped Smart Grip Tape on Reference Pen
// File: CAD Modelling/Overall Model/Assembly_Wrapped.scad
// =========================================================================

include <../Common/params.scad>
use <../Pen/reference_pen.scad>
use <Assembly_Flat.scad>

// --- View & Simulation Controls ---
pen_diameter        = PEN_DIAMETER_DEFAULT; // 9.0 mm standard (7.0 - 11.0 mm compatible)
show_pen            = true;                  // Render reference ballpoint pen
show_internal_refill = true;                 // Render internal ink refill inside the pen
cutaway_view        = false;                 // 180-degree longitudinal section cutaway
steps               = 180;                   // Number of angular slices for smooth wrapping

// Strip inspection flags
show_top_skin       = true;                  // Show outer TPU matte grip skin
show_battery        = true;                  // Show printed Zn-Mn battery
show_soc            = true;                  // Show BLE SoC & passives
show_accel          = true;                  // Show LIS2DH12 accelerometer
show_fsr            = true;                  // Show carbon FSR sensor
show_antenna        = true;                  // Show 2.4 GHz meander antenna

module wrapped_tape_assembly(
    d_pen = pen_diameter,
    slice_count = steps
) {
    r_pen = d_pen / 2;

    // 1. Reference Ballpoint Pen Barrel & Writing Tip
    if (show_pen) {
        reference_ballpoint_pen(
            d = d_pen,
            tape_w = STRIP_WID,
            cutaway = cutaway_view
        );
    }

    // 2. High-Fidelity Spiral Conformal Wrap of Smart Tape
    dx = STRIP_LEN / slice_count;

    difference() {
        for (i = [0 : slice_count - 1]) {
            x_pos  = i * dx;
            // Radial displacement formula accounts for cumulative thickness per revolution (~1.9x wrap)
            r_curr = r_pen + (x_pos / (2 * PI * r_pen)) * 0.58;
            angle  = (x_pos / (2 * PI * r_pen)) * 360;

            rotate([0, 0, angle])
                translate([r_curr, 0, 0])
                    rotate([90, 0, 90]) // Aligns 20mm tape width along pen Z-axis
                        intersection() {
                            translate([-x_pos, 0, 0])
                                flat_tape_assembly(is_exploded = false);

                            // Bounding slice box for angular projection
                            translate([-0.01, -0.5, -0.2])
                                cube([dx + 0.04, STRIP_WID + 1.0, 1.2]);
                        }
        }

        // Section cutaway if enabled
        if (cutaway_view) {
            translate([0, -r_pen * 3, -10])
                cube([r_pen * 4, r_pen * 6, STRIP_WID + 20]);
        }
    }
}

// Render Master Wrapped Assembly
wrapped_tape_assembly();
