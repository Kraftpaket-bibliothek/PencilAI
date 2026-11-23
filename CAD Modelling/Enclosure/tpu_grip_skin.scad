// =========================================================================
// PencilAI - Translucent Matte TPU Protective Grip Skin
// File: CAD Modelling/Enclosure/tpu_grip_skin.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_grip_ribs    = true;   // Tactile micro-rib ridges over finger pinch zone
show_strain_relief = true;  // Lateral flex relief notches for tight barrel wrapping
x_ray_mode        = false;  // Make skin high-transparency to inspect underlying components
skin_opacity      = x_ray_mode ? 0.25 : 0.55;

module tpu_skin(
    x = 0,
    y = 0,
    z = THICK_BASE,
    length = STRIP_LEN,
    width = STRIP_WID,
    thickness = THICK_TPU_SKIN
) {
    c_skin = [C_TPU_SKIN[0], C_TPU_SKIN[1], C_TPU_SKIN[2], skin_opacity];

    translate([x, y, z]) {
        // 1. Main Matte TPU Protective Film
        color(c_skin) {
            difference() {
                // Base rounded encapsulation cover
                rounded_box(length, width, thickness, STRIP_CORNER_R);

                // Strain relief notches along the bottom edge to allow smooth conical conformity
                if (show_strain_relief) {
                    for (nx = [10.0, 22.0, 36.0, 48.0]) {
                        translate([nx, -0.1, -0.01])
                            cylinder(d = 0.8, h = thickness + 0.02, $fn = 16);
                    }
                }
            }
        }

        // 2. Tactile Ergonomic Micro-Ribs (Finger Traction Zone)
        // Positioned directly over the FSR finger grip zone (x = 3.0 to 19.0)
        if (show_grip_ribs) {
            color(C_TPU_OPAQUE) {
                for (rx = [3.5 : 1.8 : 19.5]) {
                    translate([rx, 3.8, thickness]) {
                        // Ergonomic rounded raised ridge
                        rotate([-90, 0, 0])
                            cylinder(r = 0.25, h = 12.4, $fn = 20);
                    }
                }

                // Tactile Nib Direction Indicator Arrow
                translate([1.8, 10.0, thickness]) {
                    linear_extrude(height = 0.15) {
                        polygon(points = [
                            [0, 0], [1.8, -1.2], [1.8, -0.4], [3.2, -0.4],
                            [3.2, 0.4], [1.8, 0.4], [1.8, 1.2]
                        ]);
                    }
                }
            }
        }
    }
}

// Standalone Render
tpu_skin(x = 0, y = 0, z = 0);
