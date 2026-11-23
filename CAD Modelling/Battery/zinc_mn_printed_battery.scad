// =========================================================================
// PencilAI - Ultra-Thin Printed Zinc-Manganese (Zn-Mn) Flexible Battery
// File: CAD Modelling/Battery/zinc_mn_printed_battery.scad
// =========================================================================

include <../Common/params.scad>

// --- View Controls (when rendered directly) ---
show_pouch_seal   = true;   // Crimped hermetic perimeter flange
show_terminals    = true;   // Nickel / conductive carbon collector tabs
show_label        = true;   // Blue dielectric insulator film & polarity marks

module printed_battery(
    x = 0,
    y = 0,
    z = THICK_BASE,
    length = BAT_LEN,
    width = BAT_WID,
    height = BAT_H
) {
    translate([x, y, z]) {
        // 1. Crimped Perimeter Pouch Seal Flange (0.12 mm thick border)
        if (show_pouch_seal) {
            color(C_BATTERY_SEAL) {
                difference() {
                    rounded_box(length, width, 0.12, 1.2);
                    translate([BAT_SEAL_MARGIN, BAT_SEAL_MARGIN, -0.01])
                        rounded_box(length - 2 * BAT_SEAL_MARGIN, width - 2 * BAT_SEAL_MARGIN, 0.14, 0.8);
                }
            }
        }

        // 2. Main Electrolyte & Active Electrode Foil Pouch Body
        color(C_BATTERY_FOIL) {
            translate([BAT_SEAL_MARGIN, BAT_SEAL_MARGIN, 0])
                rounded_box(length - 2 * BAT_SEAL_MARGIN, width - 2 * BAT_SEAL_MARGIN, height - 0.02, 0.8);
        }

        // 3. Positive & Negative Terminal Collector Tabs
        if (show_terminals) {
            // Anode (+) Tab (Gold-plated / nickel contact)
            color(C_GOLD)
                translate([-BAT_TAB_LEN + 0.2, 3.2, 0.05])
                    cube([BAT_TAB_LEN, BAT_TAB_WID, 0.04]);

            // Cathode (-) Tab
            color(C_SOLDER)
                translate([-BAT_TAB_LEN + 0.2, 7.8, 0.05])
                    cube([BAT_TAB_LEN, BAT_TAB_WID, 0.04]);
        }

        // 4. Blue Dielectric Insulator Accent & Laser Polarity Markings
        if (show_label) {
            // Insulator cover film
            color(C_BAT_ACCENT)
                translate([BAT_SEAL_MARGIN + 1.2, BAT_SEAL_MARGIN + 1.2, height - 0.02])
                    rounded_box(length - 2 * BAT_SEAL_MARGIN - 2.4, width - 2 * BAT_SEAL_MARGIN - 2.4, 0.02, 0.6);

            // Polarity Marks (+ and -) printed in crisp white/silver
            color([0.95, 0.95, 0.98, 1.0]) {
                // "+" Mark near Anode Tab
                translate([BAT_SEAL_MARGIN + 2.0, 3.6, height + 0.001]) {
                    cube([1.4, 0.35, 0.005]);
                    translate([0.52, -0.52, 0]) cube([0.35, 1.4, 0.005]);
                }

                // "-" Mark near Cathode Tab
                translate([BAT_SEAL_MARGIN + 2.0, 8.2, height + 0.001])
                    cube([1.4, 0.35, 0.005]);

                // "PencilAI Zn-Mn 1.5V" silk branding stripe
                translate([BAT_SEAL_MARGIN + 5.0, 5.2, height + 0.001])
                    cube([6.5, 1.8, 0.004]);
            }
        }
    }
}

// Standalone Render
printed_battery(x = 0, y = 0, z = 0);
