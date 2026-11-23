// =========================================================================
// PencilAI - Common Parameters, Colors & Utility Library
// File: CAD Modelling/Common/params.scad
// =========================================================================

// --- Resolution Settings ---
$fn = 64;

// --- Physical Strip Dimensions (mm) ---
STRIP_LEN        = 54.0;   // Length of flexible tape (wraps ~1.9x on 9mm barrel)
STRIP_WID        = 20.0;   // Width of tape along the pen axis (grip zone height)
STRIP_CORNER_R   = 2.0;    // Rounded corner radius to prevent peeling

// --- Layer Heights & Z-Stackup (mm) ---
THICK_ADHESIVE   = 0.055;  // Skin-safe medical acrylic adhesive
THICK_KAPTON     = 0.025;  // Flexible Polyimide film substrate (25 um)
THICK_BASE       = THICK_ADHESIVE + THICK_KAPTON; // 0.080 mm base

THICK_COPPER     = 0.020;  // Etched copper traces (1/2 oz / 18-20 um)
THICK_GOLD       = 0.005;  // ENIG surface finish plating
THICK_CARBON     = 0.030;  // Screen-printed carbon resistive ink (30 um)
THICK_SPACER     = 0.015;  // Dielectric spacer dot height

THICK_TPU_SKIN   = 0.450;  // Translucent matte TPU outer protective grip film
THICK_TOTAL_MAX  = 0.530;  // Target total profile thickness: 0.53 mm

// --- Component Dimensions (mm) ---
// ST LIS2DH12 Ultra-low-power 3-axis accelerometer (WLCSP-12)
ACCEL_LEN        = 1.60;
ACCEL_WID        = 1.60;
ACCEL_H          = 0.40;   // Ultra-thin WLCSP package
ACCEL_BALL_PITCH = 0.40;   // 3x4 solder ball matrix
ACCEL_BALL_DIA   = 0.22;

// BLE Beacon SoC (InPlay IN100 / Nordic nRF52810 WLCSP)
BLE_LEN          = 2.20;
BLE_WID          = 2.20;
BLE_H            = 0.35;   // 0.35 mm profile
BLE_BALL_PITCH   = 0.45;   // 4x4 solder ball matrix
BLE_BALL_DIA     = 0.24;

// Ultra-Thin Printed Zinc-Manganese (Zn-Mn) Flexible Battery
BAT_LEN          = 16.5;   // Main pouch length
BAT_WID          = 12.6;   // Main pouch width
BAT_H            = 0.45;   // Printed paper battery thickness (0.45 mm)
BAT_SEAL_MARGIN  = 1.0;    // Perimeter foil crimp seal width
BAT_TAB_LEN      = 2.4;    // Terminal connector tab length
BAT_TAB_WID      = 1.2;    // Terminal tab width

// Interdigitated Carbon FSR Pinch Zone
FSR_LEN          = 17.5;
FSR_WID          = 13.6;
FSR_FINGERS      = 16;
FSR_BUS_WID      = 0.60;

// Serpentine 2.4 GHz Antenna
ANT_LOOPS        = 6;
ANT_STEP         = 1.40;
ANT_AMP          = 2.40;
ANT_TRACE_WID    = 0.35;

// Reference Pen
PEN_DIAMETER_DEFAULT = 9.0; // Standard ballpoint barrel (mm)

// --- Color Palette (RGBA) ---
C_KAPTON         = [0.85, 0.48, 0.08, 0.88]; // Translucent Amber Polyimide
C_ADHESIVE       = [0.95, 0.95, 0.92, 0.50]; // Clear skin-safe acrylic adhesive
C_RELEASE_LINER  = [0.98, 0.98, 0.96, 0.95]; // White silicone-coated pull tab
C_TPU_SKIN       = [0.18, 0.19, 0.22, 0.55]; // Translucent Charcoal Matte TPU
C_TPU_OPAQUE     = [0.14, 0.15, 0.17, 1.00]; // Grip ridges / tactile accents
C_COPPER         = [0.85, 0.45, 0.22, 1.00]; // Raw Etched Copper
C_GOLD           = [0.92, 0.74, 0.20, 1.00]; // ENIG Gold Plating
C_CARBON         = [0.12, 0.12, 0.13, 0.98]; // Screen-Printed Carbon Ink
C_DIELECTRIC     = [0.20, 0.65, 0.40, 0.75]; // Green/Teal Dielectric Spacer
C_SILICON        = [0.09, 0.10, 0.12, 1.00]; // WLCSP Mirror Silicon Die
C_SOLDER         = [0.76, 0.78, 0.82, 1.00]; // SAC305 Lead-Free Solder
C_CERAMIC        = [0.70, 0.58, 0.46, 1.00]; // 0201 MLCC Brown Ceramic
C_BATTERY_FOIL   = [0.80, 0.82, 0.85, 1.00]; // Hermetic Aluminum/Poly Pouch
C_BATTERY_SEAL   = [0.65, 0.67, 0.70, 1.00]; // Crimped Pouch Flange
C_BAT_ACCENT     = [0.15, 0.45, 0.75, 1.00]; // Insulator Layer / Branding
C_PEN_BARREL     = [0.93, 0.94, 0.96, 0.90]; // Smooth Polycarbonate Barrel
C_PEN_CHROME     = [0.84, 0.86, 0.89, 1.00]; // Mirror Chrome Trim
C_PEN_BRASS      = [0.86, 0.70, 0.28, 1.00]; // Machined Brass Tip Collar
C_PEN_BALL       = [0.35, 0.36, 0.38, 1.00]; // Tungsten Carbide Ball
C_PEN_INK        = [0.05, 0.10, 0.35, 1.00]; // Blue Ink Column inside refill

// --- Reusable Geometric Modules ---

// 2D Rounded Rectangle (Centered or Corner Origin)
module rounded_rect_2d(length, width, radius, center = false) {
    tx = center ? -length / 2 : 0;
    ty = center ? -width / 2 : 0;
    translate([tx, ty])
        offset(r = radius)
            offset(delta = -radius)
                square([length, width]);
}

// 3D Rounded Extruded Plate
module rounded_box(length, width, height, radius, center = false) {
    linear_extrude(height = height)
        rounded_rect_2d(length, width, radius, center = center);
}

// Spherical Solder Ball
module solder_ball(diameter) {
    color(C_SOLDER)
        sphere(d = diameter, $fn = 32);
}

// SMD 0201 / 01005 Passive Component (Capacitor / Inductor / Resistor)
module smd_passive_0201(len = 0.60, wid = 0.30, height = 0.30, body_color = C_CERAMIC) {
    term_len = 0.15;
    // Central Ceramic/Ferrite Body
    color(body_color)
        translate([term_len, 0, 0])
            cube([len - 2 * term_len, wid, height]);
    // Silver End Terminations
    color(C_SOLDER) {
        cube([term_len, wid, height]);
        translate([len - term_len, 0, 0])
            cube([term_len, wid, height]);
    }
}

// Circular Fiducial Alignment Marker (for high-precision flex assembly)
module fiducial_marker(diameter = 1.0, copper_h = THICK_COPPER) {
    color(C_GOLD)
        cylinder(d = diameter, h = copper_h, $fn = 32);
    color(C_KAPTON)
        difference() {
            cylinder(d = diameter * 2.2, h = copper_h + 0.001, $fn = 32);
            cylinder(d = diameter * 1.4, h = copper_h + 0.002, $fn = 32);
        }
}
