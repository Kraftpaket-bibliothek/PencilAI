// =========================================================================
// Ultra-Thin Disposable Smart Grip Tape (0.53mm) - Complete Fixed Model
// =========================================================================

$fn = 96;

// --- Render Controls ---
wrapped        = true;   // true = wrapped on pen, false = flat inspection view
show_top_cover = true;   // true = translucent matte grip skin, false = naked flex PCB
pen_diameter   = 9.0;    // Standard pen barrel diameter (mm)

// --- Strip Dimensions (mm) ---
strip_len  = 54.0;
strip_wid  = 20.0;
corner_r   = 2.0;
base_thick = 0.08;       // Polyimide + medical-grade acrylic adhesive

// --- Color Palette (RGBA) ---
c_kapton   = [0.85, 0.48, 0.08, 0.88]; // Translucent Amber Polyimide
c_tpu_skin = [0.16, 0.17, 0.19, 0.45]; // Translucent Matte Charcoal Grip Film
c_copper   = [0.85, 0.45, 0.22, 1.00]; // Etched Copper
c_gold     = [0.92, 0.74, 0.20, 1.00]; // ENIG Gold Pads & Traces
c_carbon   = [0.12, 0.12, 0.13, 0.95]; // Screen-Printed Carbon Ink
c_silicon  = [0.08, 0.09, 0.11, 1.00]; // WLCSP Silicon Die
c_battery  = [0.78, 0.80, 0.83, 1.00]; // Printed Zinc-Mn Pouch Foil
c_bat_lbl  = [0.18, 0.45, 0.68, 1.00]; // Battery Insulator Accent

// --- Helper: Rounded 2D/3D Plate ---
module rounded_plate(l, w, h, r) {
    linear_extrude(height = h)
        offset(r = r)
            offset(delta = -r)
                square([l, w]);
}

// --- Helper: Interdigitated Carbon FSR Sensor ---
module fsr_interdigitated(x0, y0, l, w, h) {
    translate([x0, y0, base_thick]) {
        // Outer Gold Busbars
        color(c_gold) {
            cube([l, 0.6, h]);
            translate([0, w - 0.6, 0]) cube([l, 0.6, h]);
        }
        // Interlocking Carbon Fingers
        color(c_carbon) {
            fingers = 14;
            pitch = l / fingers;
            for (i = [0 : fingers - 1]) {
                translate([i * pitch + 0.25, (i % 2 == 0) ? 0.6 : 1.8, 0])
                    cube([pitch * 0.55, w - 2.4, h]);
            }
        }
    }
}

// --- Helper: Serpentine 2.4GHz Meander Antenna ---
module meander_antenna(x0, y0, h) {
    color(c_copper)
    translate([x0, y0, base_thick]) {
        loops = 6;
        step = 1.4;
        amp = 2.2;
        w_tr = 0.35;
        for (i = [0 : loops - 1]) {
            translate([i * step, 0, 0]) cube([w_tr, amp, h]);
            translate([i * step, amp - w_tr, 0]) cube([step / 2 + w_tr, w_tr, h]);
            translate([i * step + step / 2, 0, 0]) cube([w_tr, amp, h]);
            if (i < loops - 1)
                translate([i * step + step / 2, 0, 0]) cube([step / 2 + w_tr, w_tr, h]);
        }
    }
}

// --- Helper: Detailed WLCSP Chip with Solder Balls & Pin-1 Dot ---
module wlcsp_chip(x0, y0, l, w, h) {
    translate([x0, y0, base_thick]) {
        // Gold ENIG Landing Pad
        color(c_gold)
            translate([-0.15, -0.15, 0])
                cube([l + 0.3, w + 0.3, 0.02]);
        // Micro Solder Bump Layer
        color([0.75, 0.77, 0.80, 1.0])
            translate([0.1, 0.1, 0.02])
                cube([l - 0.2, w - 0.2, 0.06]);
        // Dark Silicon Die Body
        color(c_silicon)
            translate([0, 0, 0.08])
                cube([l, w, h - 0.08]);
        // Laser-Etched Pin-1 Orientation Dot
        color([0.7, 0.7, 0.7, 1.0])
            translate([0.35, 0.35, h + 0.002])
                cylinder(d = 0.22, h = 0.01);
    }
}

// --- Complete Flat Smart Tape Assembly ---
module flat_tape() {
    // 1. Base Polyimide Flex Film with Rounded Corners
    color(c_kapton)
        rounded_plate(strip_len, strip_wid, base_thick, corner_r);

    // 2. Interdigitated Carbon Pressure Pad (Finger Pinch Zone)
    fsr_interdigitated(2.5, 3.2, 17.5, 13.6, 0.03);

    // 3. LIS2DH12 3-Axis Accelerometer (Near Nib Edge)
    wlcsp_chip(4.2, 1.2, 1.6, 1.6, 0.40);

    // 4. BLE Beacon SoC (InPlay IN100 / nRF52 WLCSP)
    wlcsp_chip(23.0, 5.0, 2.2, 2.2, 0.35);

    // 5. Meandered Copper 2.4 GHz Antenna (Top Margin Keepout)
    meander_antenna(22.0, 16.5, 0.025);

    // 6. Gold Routing Traces (Connecting Accelerometer, FSR & Battery to BLE)
    color(c_gold)
    translate([0, 0, base_thick]) {
        // Accelerometer -> BLE SoC bus
        translate([5.8, 1.9, 0]) cube([17.2, 0.25, 0.02]);
        translate([22.8, 1.9, 0]) cube([0.25, 3.2, 0.02]);
        // FSR -> BLE SoC sense line
        translate([20.0, 6.2, 0]) cube([3.0, 0.25, 0.02]);
        // BLE SoC -> Antenna feed line
        translate([24.0, 7.2, 0]) cube([0.30, 9.3, 0.02]);
        // Battery -> BLE SoC power rails
        translate([25.2, 5.6, 0]) cube([2.8, 0.35, 0.02]);
        translate([25.2, 6.4, 0]) cube([2.8, 0.35, 0.02]);
    }

    // 7. Ultra-Thin Flexible Printed Battery (0.45mm)
    translate([28.0, 2.8, base_thick]) {
        // Silver Pouch Cell Body
        color(c_battery)
            rounded_plate(16.5, 12.6, 0.43, 1.0);
        // Blue Dielectric Insulator Stripe & Polarity Mark
        color(c_bat_lbl)
            translate([1.5, 1.5, 0.43])
                rounded_plate(13.5, 9.6, 0.02, 0.6);
    }

    // 8. Translucent Matte TPU Top Grip Film + Micro-Texture Ribs
    if (show_top_cover) {
        color(c_tpu_skin)
        translate([0, 0, base_thick])
            rounded_plate(strip_len, strip_wid, 0.47, corner_r);

        // Subtle Tactile Grip Ridges over Finger Pinch Zone
        color([0.12, 0.13, 0.15, 0.65])
        for (rx = [3.5 : 2.2 : 19.0]) {
            translate([rx, 4.0, base_thick + 0.47])
                cube([0.6, 12.0, 0.04]);
        }
    }
}

// --- Detailed Reference Ballpoint Pen ---
module detailed_pen(d, tape_w) {
    r = d / 2;
    // Lower Barrel (Grip Area)
    color([0.92, 0.93, 0.95, 0.85])
        translate([0, 0, -6])
            cylinder(r = r, h = tape_w + 45);

    // Chrome Nose Cone
    color([0.82, 0.84, 0.87, 1.0])
        translate([0, 0, -18])
            cylinder(r1 = 1.1, r2 = r, h = 12);

    // Brass / Tungsten Ballpoint Tip
    color([0.85, 0.68, 0.25, 1.0])
        translate([0, 0, -21.5])
            cylinder(r1 = 0.35, r2 = 1.1, h = 3.5);

    // Chrome Accent Ring above Grip
    color([0.82, 0.84, 0.87, 1.0])
        translate([0, 0, tape_w + 3])
            cylinder(r = r + 0.12, h = 1.5);
}

// --- Fixed Spiral Wrap Engine (Hugs Pen Barrel Vertically) ---
module wrapped_tape() {
    r_pen = pen_diameter / 2;
    detailed_pen(pen_diameter, strip_wid);

    steps = 180;
    dx = strip_len / steps;

    for (i = [0 : steps - 1]) {
        x_pos  = i * dx;
        // Gradual spiral radius increase so the ~1.9x wrap overlaps cleanly
        r_curr = r_pen + (x_pos / (2 * PI * r_pen)) * 0.58;
        angle  = (x_pos / (2 * PI * r_pen)) * 360;

        rotate([0, 0, angle])
            translate([r_curr, 0, 0])
                rotate([90, 0, 90]) // Stands strip width vertically along pen Z-axis
                    intersection() {
                        translate([-x_pos, 0, 0])
                            flat_tape();
                        translate([-0.01, -0.5, -0.1])
                            cube([dx + 0.03, strip_wid + 1.0, 1.0]);
                    }
    }
}

// --- Render Scene ---
if (wrapped) {
    wrapped_tape();
} else {
    flat_tape();
}
