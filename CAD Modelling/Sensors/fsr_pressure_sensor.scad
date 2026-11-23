// =========================================================================
// PencilAI - Interdigitated Carbon FSR Pressure Sensor
// File: CAD Modelling/Sensors/fsr_pressure_sensor.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_busbars      = true;   // Gold outer collector busbars & lead traces
show_carbon_grid  = true;   // Interlocking screen-printed carbon-ink fingers
show_spacer_dots  = true;   // Dielectric micro-spacer dots for threshold control

module fsr_sensor(
    x = 0,
    y = 0,
    z = THICK_BASE,
    length = FSR_LEN,
    width = FSR_WID,
    fingers = FSR_FINGERS
) {
    translate([x, y, z]) {
        // 1. Dual ENIG Gold Busbars & Sense Feeds
        if (show_busbars) {
            color(C_GOLD) {
                // Bottom Busbar
                cube([length, FSR_BUS_WID, THICK_COPPER + THICK_GOLD]);

                // Top Busbar
                translate([0, width - FSR_BUS_WID, 0])
                    cube([length, FSR_BUS_WID, THICK_COPPER + THICK_GOLD]);

                // Connecting feed leads running towards SoC
                translate([length, FSR_BUS_WID / 2 - 0.15, 0])
                    cube([3.0, 0.30, THICK_COPPER]);
                translate([length, width - FSR_BUS_WID / 2 - 0.15, 0])
                    cube([3.0, 0.30, THICK_COPPER]);
            }
        }

        // 2. Interlocking Screen-Printed Carbon-Ink Fingers (30 um)
        if (show_carbon_grid) {
            color(C_CARBON) {
                pitch = length / fingers;
                finger_wid = pitch * 0.52;
                overlap_span = width - 2 * FSR_BUS_WID - 0.8;

                for (i = [0 : fingers - 1]) {
                    fx = i * pitch + 0.15;
                    if (i % 2 == 0) {
                        // Finger extending upward from bottom busbar
                        translate([fx, FSR_BUS_WID, 0])
                            cube([finger_wid, overlap_span, THICK_CARBON]);
                    } else {
                        // Finger extending downward from top busbar
                        translate([fx, width - FSR_BUS_WID - overlap_span, 0])
                            cube([finger_wid, overlap_span, THICK_CARBON]);
                    }
                }
            }
        }

        // 3. Dielectric Micro-Spacer Dots
        // Keeps fingers separated during zero touch so the sensor only triggers on deliberate finger grip
        if (show_spacer_dots) {
            color(C_DIELECTRIC) {
                pitch_x = length / 4;
                pitch_y = width / 3;
                for (ix = [1 : 3]) {
                    for (iy = [1 : 2]) {
                        translate([ix * pitch_x, iy * pitch_y, THICK_CARBON])
                            cylinder(d = 0.55, h = THICK_SPACER, $fn = 20);
                    }
                }
            }
        }
    }
}

// Standalone Render
fsr_sensor(x = 0, y = 0, z = 0);
