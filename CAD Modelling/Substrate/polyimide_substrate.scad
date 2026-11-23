// =========================================================================
// PencilAI - Polyimide Substrate & Adhesive Base Layer
// File: CAD Modelling/Substrate/polyimide_substrate.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_release_liner = true;  // Show peelable paper backing with pull tab
show_fiducials     = true;  // Optical pick-and-place fiducial targets
show_peel_tab      = true;  // Extended pull-tab for easy application

module substrate_layer(show_liner = show_release_liner, show_tab = show_peel_tab) {
    // 1. Release Liner (Peel-off protective paper/PET with pull tab)
    if (show_liner) {
        color(C_RELEASE_LINER) {
            // Liner sits beneath the adhesive layer
            translate([0, 0, -0.060]) {
                linear_extrude(height = 0.050) {
                    rounded_rect_2d(STRIP_LEN, STRIP_WID, STRIP_CORNER_R);
                    // Extended easy-peel tab on the short edge
                    if (show_tab) {
                        translate([STRIP_LEN - 0.5, 4.0])
                            polygon(points = [
                                [0, 0], [6.0, 1.5], [6.0, 10.5], [0, 12.0]
                            ]);
                    }
                }
            }
        }
        // "PEEL HERE" chevron indicator mark on the tab
        if (show_tab) {
            color([0.2, 0.2, 0.2, 0.8])
                translate([STRIP_LEN + 2.2, 9.0, -0.009])
                    cube([0.5, 3.5, 0.005]);
        }
    }

    // 2. Skin-Safe Pressure-Sensitive Adhesive (PSA) Layer (55 um)
    color(C_ADHESIVE)
        translate([0, 0, -THICK_ADHESIVE])
            rounded_box(STRIP_LEN, STRIP_WID, THICK_ADHESIVE, STRIP_CORNER_R);

    // 3. Flexible Polyimide (Kapton) Base Substrate (25 um)
    color(C_KAPTON)
        difference() {
            rounded_box(STRIP_LEN, STRIP_WID, THICK_KAPTON, STRIP_CORNER_R);

            // Alignment notches along upper edge for tooling jig
            translate([12.0, STRIP_WID - 0.4, -0.001])
                cube([1.2, 0.5, THICK_KAPTON + 0.002]);
            translate([38.0, STRIP_WID - 0.4, -0.001])
                cube([1.2, 0.5, THICK_KAPTON + 0.002]);
        }

    // 4. Optical Alignment Fiducials & Calibration Guide Printing
    if (show_fiducials) {
        // Corner fiducials for PCB assembly
        translate([2.2, 2.2, THICK_KAPTON])
            fiducial_marker(0.7);
        translate([STRIP_LEN - 2.2, 2.2, THICK_KAPTON])
            fiducial_marker(0.7);
        translate([STRIP_LEN - 2.2, STRIP_WID - 2.2, THICK_KAPTON])
            fiducial_marker(0.7);

        // Printed "L"-Calibration Icon silk guide near the start of the tape
        color([0.9, 0.9, 0.9, 0.9])
            translate([1.2, STRIP_WID - 4.5, THICK_KAPTON]) {
                // Vertical stroke of "L"
                cube([0.3, 3.0, 0.005]);
                // Horizontal stroke of "L"
                cube([2.2, 0.3, 0.005]);
            }
    }
}

// Standalone Render
substrate_layer();
