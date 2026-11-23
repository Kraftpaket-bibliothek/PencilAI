// =========================================================================
// PencilAI - 2.4 GHz Printed Copper Meander Antenna
// File: CAD Modelling/Electronics/meander_antenna.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_keepout_zone = true;   // Translucent boundary showing RF ground clearance keepout
show_ground_stub  = true;   // Ground connection stub for inverted-F matching
show_feedline     = true;   // 50-ohm microstrip feedline to BLE SoC

module meander_antenna(
    x = 0,
    y = 0,
    z = THICK_BASE,
    loops = ANT_LOOPS,
    step = ANT_STEP,
    amp = ANT_AMP,
    trace_w = ANT_TRACE_WID
) {
    translate([x, y, z]) {
        // 1. RF Ground Clearance Keepout Zone (Translucent Guide)
        if (show_keepout_zone) {
            color([0.2, 0.7, 0.9, 0.18])
                translate([-0.8, -0.6, -0.001])
                    rounded_box(loops * step + 1.6, amp + 1.2, 0.005, 0.5);
        }

        // 2. Copper Serpentine Resonator Traces
        color(C_COPPER) {
            for (i = [0 : loops - 1]) {
                // Vertical rising segment
                translate([i * step, 0, 0])
                    cube([trace_w, amp, THICK_COPPER]);

                // Top connecting horizontal segment
                translate([i * step, amp - trace_w, 0])
                    cube([step / 2 + trace_w, trace_w, THICK_COPPER]);

                // Vertical falling segment
                translate([i * step + step / 2, 0, 0])
                    cube([trace_w, amp, THICK_COPPER]);

                // Bottom connecting horizontal segment
                if (i < loops - 1) {
                    translate([i * step + step / 2, 0, 0])
                        cube([step / 2 + trace_w, trace_w, THICK_COPPER]);
                }
            }

            // Open-circuit capacitive end tip
            translate([(loops - 1) * step + step / 2, 0, 0])
                cube([trace_w * 2.2, trace_w, THICK_COPPER]);

            // 3. 50-Ohm Microstrip Feedline connecting to RF matching network
            if (show_feedline) {
                translate([0, 0, 0])
                    cube([trace_w, 0.6, THICK_COPPER]);
            }

            // 4. Ground Shunt Matching Stub
            if (show_ground_stub) {
                translate([-0.6, 0, 0])
                    cube([0.6, trace_w, THICK_COPPER]);
                translate([-0.6, -0.8, 0])
                    cube([trace_w, 0.8, THICK_COPPER]);
            }
        }
    }
}

// Standalone Render
meander_antenna(x = 0, y = 0, z = 0);
