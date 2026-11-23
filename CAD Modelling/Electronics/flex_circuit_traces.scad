// =========================================================================
// PencilAI - Flexible Circuit Routing & Interconnect Traces
// File: CAD Modelling/Electronics/flex_circuit_traces.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_bus_traces   = true;   // Accelerometer I2C/SPI lines & Interrupts
show_power_rails  = true;   // VDD & GND ground return plane
show_test_points  = true;   // SWD / Factory programming test pads
show_fsr_sense    = true;   // FSR analog sense lines

module flex_traces(x = 0, y = 0, z = THICK_BASE) {
    translate([x, y, z]) {
        color(C_GOLD) {
            // 1. Accelerometer -> BLE SoC Bus (SCL, SDA, INT1)
            if (show_bus_traces) {
                // Line 1: SCL
                translate([5.8, 1.6, 0]) cube([16.8, 0.20, THICK_GOLD]);
                translate([22.6, 1.6, 0]) cube([0.20, 3.4, THICK_GOLD]);

                // Line 2: SDA
                translate([5.8, 2.0, 0]) cube([16.4, 0.20, THICK_GOLD]);
                translate([22.2, 2.0, 0]) cube([0.20, 3.0, THICK_GOLD]);

                // Line 3: INT1 (Motion Wake-Up Trigger)
                translate([5.8, 2.4, 0]) cube([16.0, 0.20, THICK_GOLD]);
                translate([21.8, 2.4, 0]) cube([0.20, 2.6, THICK_GOLD]);
            }

            // 2. FSR -> BLE SoC Sense Line
            if (show_fsr_sense) {
                translate([20.0, 6.2, 0]) cube([2.8, 0.25, THICK_GOLD]);
                translate([20.0, 16.2, 0]) cube([1.2, 0.25, THICK_GOLD]);
                translate([21.2, 8.5, 0]) cube([0.25, 7.9, THICK_GOLD]);
            }

            // 3. BLE SoC -> 2.4 GHz Antenna RF Microstrip Feed
            translate([24.1, 7.2, 0]) cube([0.35, 9.3, THICK_GOLD]);

            // 4. Battery -> BLE SoC Power Rails (VDD & GND)
            if (show_power_rails) {
                // Positive Rail (VDD 1.5V - 3.0V)
                translate([25.2, 5.5, 0]) cube([2.8, 0.40, THICK_GOLD]);
                // Ground Return Rail (GND)
                translate([25.2, 6.5, 0]) cube([2.8, 0.45, THICK_GOLD]);

                // Ground plane copper patch under RF section
                translate([21.0, 14.5, 0])
                    rounded_box(1.5, 4.0, THICK_COPPER, 0.2);
            }

            // 5. Factory SWD Programming & Calibration Test Points (1.0mm dia pads)
            if (show_test_points) {
                translate([25.5, 10.0, 0]) cylinder(d = 0.8, h = THICK_GOLD, $fn = 24);
                translate([25.5, 11.5, 0]) cylinder(d = 0.8, h = THICK_GOLD, $fn = 24);
                translate([25.5, 13.0, 0]) cylinder(d = 0.8, h = THICK_GOLD, $fn = 24);
                translate([25.5, 14.5, 0]) cylinder(d = 0.8, h = THICK_GOLD, $fn = 24);
            }
        }
    }
}

// Standalone Render
flex_traces(x = 0, y = 0, z = 0);
