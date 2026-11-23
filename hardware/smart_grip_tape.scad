// =========================================================================
// PencilAI - Parametric 3D Smart Grip Tape (README Primary Entrypoint)
// File: hardware/smart_grip_tape.scad
// =========================================================================

include <../CAD Modelling/Common/params.scad>
use <../CAD Modelling/Overall Model/Assembly_Flat.scad>
use <../CAD Modelling/Overall Model/Assembly_Wrapped.scad>

// --- Render Controls (As documented in README Quick Start) ---
wrapped        = true;   // true = wrapped on pen barrel, false = flat inspection view
show_top_cover = true;   // true = matte grip skin, false = naked flex PCB inspection
pen_diameter   = 9.0;    // Standard pen barrel diameter (mm)
exploded       = false;  // true = 3D exploded multilayer view (in flat mode)

if (wrapped) {
    wrapped_tape_assembly(d_pen = pen_diameter);
} else {
    flat_tape_assembly(is_exploded = exploded);
}
