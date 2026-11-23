// =========================================================================
// PencilAI - Ultra-Low Power BLE Beacon SoC & Passives (WLCSP-16)
// File: CAD Modelling/Electronics/ble_beacon_soc.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_soc_pads     = true;   // Gold landing pads beneath SoC
show_soc_bumps    = true;   // 4x4 matrix of solder bumps
show_passives     = true;   // 0201 decoupling caps & RF match components
show_markings     = true;   // Laser etched chip branding & pin-1 dot

module ble_beacon_soc(x = 0, y = 0, z = THICK_BASE) {
    translate([x, y, z]) {
        // 1. ENIG Gold PCB Landing Pads (4x4 matrix = 16 pads)
        if (show_soc_pads) {
            color(C_GOLD) {
                for (col = [0 : 3]) {
                    for (row = [0 : 3]) {
                        px = 0.42 + col * BLE_BALL_PITCH;
                        py = 0.42 + row * BLE_BALL_PITCH;
                        translate([px - 0.12, py - 0.12, 0])
                            cube([0.24, 0.24, THICK_GOLD]);
                    }
                }
            }
        }

        // 2. Micro Solder Bumps (SAC305 Spheres, 16 balls)
        if (show_soc_bumps) {
            for (col = [0 : 3]) {
                for (row = [0 : 3]) {
                    bx = 0.42 + col * BLE_BALL_PITCH;
                    by = 0.42 + row * BLE_BALL_PITCH;
                    translate([bx, by, 0.05])
                        solder_ball(BLE_BALL_DIA);
                }
            }
        }

        // 3. Silicon Die Body (WLCSP Package: 2.20 x 2.20 x 0.28 mm above stand-off)
        translate([0, 0, 0.07]) {
            color(C_SILICON) {
                difference() {
                    cube([BLE_LEN, BLE_WID, BLE_H - 0.07]);
                    // Micro corner chamfer
                    translate([-0.01, -0.01, BLE_H - 0.10])
                        rotate([45, 0, 0])
                            cube([BLE_LEN + 0.02, 0.04, 0.04]);
                }
            }

            if (show_markings) {
                // Pin 1 Laser Dot
                color([0.80, 0.80, 0.82, 1.0])
                    translate([0.35, 0.35, BLE_H - 0.07 + 0.001])
                        cylinder(d = 0.24, h = 0.008, $fn = 24);

                // Laser Etched Marking Text lines ("IN100 / BLE")
                color([0.65, 0.65, 0.68, 0.9]) {
                    translate([0.45, 1.25, BLE_H - 0.07 + 0.001])
                        cube([1.30, 0.18, 0.005]);
                    translate([0.45, 0.80, BLE_H - 0.07 + 0.001])
                        cube([0.90, 0.18, 0.005]);
                }
            }
        }

        // 4. Peripheral Passives (0201 Decoupling & Tuning Components)
        if (show_passives) {
            // C1: VDD Decoupling Capacitor (0201)
            translate([-0.90, 0.30, 0])
                smd_passive_0201(0.60, 0.30, 0.30, C_CERAMIC);

            // C2: Bulk Filter Capacitor (0201)
            translate([-0.90, 1.20, 0])
                smd_passive_0201(0.60, 0.30, 0.30, C_CERAMIC);

            // L1: RF Output Tuning Inductor (0201 Ferrite/Ceramic)
            translate([1.00, BLE_WID + 0.40, 0])
                rotate([0, 0, 90])
                    smd_passive_0201(0.60, 0.30, 0.30, [0.25, 0.25, 0.28, 1.0]);
        }
    }
}

// Standalone Render
ble_beacon_soc(x = 0, y = 0, z = 0);
