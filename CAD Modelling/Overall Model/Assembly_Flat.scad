// =========================================================================
// PencilAI - Master Flat Inspection & Exploded Multilayer Assembly
// File: CAD Modelling/Overall Model/Assembly_Flat.scad
// =========================================================================

include <../Common/params.scad>
use <../Substrate/polyimide_substrate.scad>
use <../Sensors/lis2dh12_accelerometer.scad>
use <../Sensors/fsr_pressure_sensor.scad>
use <../Electronics/ble_beacon_soc.scad>
use <../Electronics/meander_antenna.scad>
use <../Electronics/flex_circuit_traces.scad>
use <../Battery/zinc_mn_printed_battery.scad>
use <../Enclosure/tpu_grip_skin.scad>

// --- View & Inspection Controls ---
exploded        = false;  // Set true for 3D exploded multilayer view
explosion_gap   = 1.50;   // Vertical separation distance between layers (mm)

// --- Layer Visibility Toggles ---
show_liner      = true;   // Release paper liner & pull tab
show_substrate  = true;   // Kapton polyimide & adhesive film
show_traces     = true;   // Gold/copper interconnects & test pads
show_fsr        = true;   // Interdigitated carbon pressure sensor
show_accel      = true;   // LIS2DH12 3-axis accelerometer
show_soc        = true;   // BLE Beacon SoC & passive network
show_antenna    = true;   // 2.4 GHz copper meander antenna
show_battery    = true;   // Printed flexible Zn-Mn battery
show_top_skin   = true;   // Translucent matte TPU outer grip film
x_ray_skin      = false;  // High transparency on outer grip skin

module flat_tape_assembly(is_exploded = exploded, gap = explosion_gap) {
    dz = is_exploded ? gap : 0;

    // -------------------------------------------------------------------------
    // Layer 0: Release Liner Backing & Easy-Peel Pull Tab (z = -0.06)
    // -------------------------------------------------------------------------
    if (show_liner) {
        translate([0, 0, -dz * 1.5])
            substrate_layer(show_liner = true, show_tab = true);
    }

    // -------------------------------------------------------------------------
    // Layer 1: Polyimide (Kapton) Base Substrate & Skin-Safe Adhesive
    // -------------------------------------------------------------------------
    if (show_substrate) {
        translate([0, 0, 0])
            substrate_layer(show_liner = false, show_tab = false);
    }

    // -------------------------------------------------------------------------
    // Layer 2: Copper Routing Traces & ENIG Gold Interconnects
    // -------------------------------------------------------------------------
    if (show_traces) {
        translate([0, 0, dz * 1.0])
            flex_traces(x = 0, y = 0, z = THICK_BASE);
    }

    // -------------------------------------------------------------------------
    // Layer 3: Interdigitated Screen-Printed Carbon-Ink FSR (Pinch Zone)
    // -------------------------------------------------------------------------
    if (show_fsr) {
        translate([0, 0, dz * 1.5])
            fsr_sensor(x = 2.5, y = 3.2, z = THICK_BASE, length = FSR_LEN, width = FSR_WID);
    }

    // -------------------------------------------------------------------------
    // Layer 4: ST LIS2DH12 3-Axis Accelerometer (Nib-Edge Grip Zone)
    // -------------------------------------------------------------------------
    if (show_accel) {
        translate([0, 0, dz * 2.0])
            lis2dh12_chip(x = 4.2, y = 1.2, z = THICK_BASE);
    }

    // -------------------------------------------------------------------------
    // Layer 5: BLE Beacon SoC (InPlay IN100 / nRF52) & 0201 Passives
    // -------------------------------------------------------------------------
    if (show_soc) {
        translate([0, 0, dz * 2.0])
            ble_beacon_soc(x = 23.0, y = 5.0, z = THICK_BASE);
    }

    // -------------------------------------------------------------------------
    // Layer 6: 2.4 GHz Copper Meander Antenna (Upper Grip Margin)
    // -------------------------------------------------------------------------
    if (show_antenna) {
        translate([0, 0, dz * 1.0])
            meander_antenna(x = 22.0, y = 16.2, z = THICK_BASE);
    }

    // -------------------------------------------------------------------------
    // Layer 7: Ultra-Thin Printed Zinc-Manganese Flexible Battery
    // -------------------------------------------------------------------------
    if (show_battery) {
        translate([0, 0, dz * 2.5])
            printed_battery(x = 28.0, y = 2.8, z = THICK_BASE);
    }

    // -------------------------------------------------------------------------
    // Layer 8: Translucent Matte Charcoal TPU Grip Skin + Tactile Ribs
    // -------------------------------------------------------------------------
    if (show_top_skin) {
        translate([0, 0, dz * 3.5])
            tpu_skin(
                x = 0,
                y = 0,
                z = THICK_BASE,
                length = STRIP_LEN,
                width = STRIP_WID,
                thickness = THICK_TPU_SKIN
            );
    }
}

// Render Master Flat Assembly
flat_tape_assembly(is_exploded = exploded, gap = explosion_gap);
