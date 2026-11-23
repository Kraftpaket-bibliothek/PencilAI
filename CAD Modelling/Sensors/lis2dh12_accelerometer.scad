// =========================================================================
// PencilAI - ST LIS2DH12 3-Axis Accelerometer (WLCSP-12)
// File: CAD Modelling/Sensors/lis2dh12_accelerometer.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_pcb_pads    = true;   // Gold landing pads beneath the chip
show_solder_bumps = true;  // SAC305 micro solder balls (0.22mm dia)
show_internal_die = true;  // Silicon die with chamfer & laser marking

module lis2dh12_chip(x = 0, y = 0, z = THICK_BASE) {
    translate([x, y, z]) {
        // 1. ENIG Gold PCB Landing Pads (12-pad grid: 3 rows x 4 columns)
        if (show_pcb_pads) {
            color(C_GOLD) {
                for (col = [0 : 3]) {
                    for (row = [0 : 2]) {
                        px = 0.20 + col * ACCEL_BALL_PITCH;
                        py = 0.40 + row * ACCEL_BALL_PITCH;
                        translate([px - 0.12, py - 0.12, 0])
                            cube([0.24, 0.24, THICK_GOLD]);
                    }
                }
            }
        }

        // 2. Micro Solder Bumps (SAC305 Lead-Free Spheres, 12 balls)
        if (show_solder_bumps) {
            for (col = [0 : 3]) {
                for (row = [0 : 2]) {
                    bx = 0.20 + col * ACCEL_BALL_PITCH;
                    by = 0.40 + row * ACCEL_BALL_PITCH;
                    translate([bx, by, 0.05])
                        solder_ball(ACCEL_BALL_DIA);
                }
            }
        }

        // 3. Silicon Die Body (WLCSP Package)
        translate([0, 0, 0.08]) {
            color(C_SILICON) {
                difference() {
                    // Main die body (1.60 x 1.60 x 0.32 mm above standoff)
                    cube([ACCEL_LEN, ACCEL_WID, ACCEL_H - 0.08]);

                    // Beveled top chamfer (characteristic of dicing cut)
                    translate([-0.01, -0.01, ACCEL_H - 0.12])
                        rotate([45, 0, 0])
                            cube([ACCEL_LEN + 0.02, 0.05, 0.05]);
                }
            }

            // 4. Pin 1 Laser Orientation Dot
            color([0.78, 0.78, 0.80, 1.0])
                translate([0.30, 0.30, ACCEL_H - 0.08 + 0.001])
                    cylinder(d = 0.22, h = 0.008, $fn = 24);

            // 5. Laser-Etched Marking: "2DH"
            color([0.65, 0.65, 0.68, 0.9])
                translate([0.55, 0.75, ACCEL_H - 0.08 + 0.001]) {
                    // Stylized micro chip markings
                    cube([0.65, 0.15, 0.005]);
                    translate([0, -0.30, 0]) cube([0.65, 0.15, 0.005]);
                }
        }
    }
}

// Standalone Render
lis2dh12_chip(x = 0, y = 0, z = 0);
