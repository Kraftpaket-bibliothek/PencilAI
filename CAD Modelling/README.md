# PencilAI CAD Engineering & OpenSCAD Models 📐

This directory contains the complete parametric 3D CAD models for **PencilAI**—an ultra-thin (`0.53 mm`) disposable smart grip tape designed to transform standard pens and pencils into digital writing instruments.

---

## 🗂️ Component Directory & File Structure

```text
CAD Modelling/
├── Common/
│   └── params.scad                  # Global parameters, layer heights, RGBA colors, reusable primitives
├── Substrate/
│   └── polyimide_substrate.scad     # 25 µm Kapton film, acrylic adhesive, release liner & peel tab
├── Sensors/
│   ├── lis2dh12_accelerometer.scad  # ST LIS2DH12 3-axis accelerometer (WLCSP-12, solder ball array)
│   └── fsr_pressure_sensor.scad     # Interdigitated carbon-ink FSR, gold busbars & dielectric spacer dots
├── Electronics/
│   ├── ble_beacon_soc.scad          # InPlay IN100 / nRF52810 WLCSP-16 SoC & 0201 passives
│   ├── meander_antenna.scad         # 2.4 GHz etched copper serpentine antenna & ground keepout
│   └── flex_circuit_traces.scad     # ENIG gold & copper routing: I2C bus, power rails, test points
├── Battery/
│   └── zinc_mn_printed_battery.scad # 0.45 mm printed flexible Zinc-Mn paper battery with foil pouch
├── Enclosure/
│   └── tpu_grip_skin.scad           # Translucent matte Charcoal TPU skin & tactile finger ribs
├── Pen/
│   └── reference_pen.scad           # Parametric 9.0 mm ballpoint pen, brass nib & ink cartridge
└── Overall Model/
    ├── Assembly_Flat.scad           # Master flat assembly with 3D multilayer exploded view toggle
    ├── Assembly_Wrapped.scad        # Master conformal spiral wrap around 3D pen barrel
    └── Iteration-1.scad             # Monolithic baseline model
```

---

## 🔬 Layer Stackup & Physical Dimensions

| Layer | Material / Spec | Nominal Thickness | Purpose |
| :--- | :--- | :--- | :--- |
| **Release Liner** | Silicone-coated paper with peel pull tab | `0.050 mm` | Protective backing before tape application |
| **Adhesive** | Medical-grade skin-safe acrylic PSA | `0.055 mm` | Adheres firmly to 7–11 mm pen barrels |
| **Substrate** | Flexible Polyimide (Kapton) | `0.025 mm` (`25 µm`) | High-temperature flex circuit base film |
| **Traces / Finish**| Etched copper + ENIG gold flash | `0.020 mm` (`20 µm`) | Low-resistance interconnects & antenna |
| **FSR Sensor** | Screen-printed carbon resistive ink | `0.030 mm` (`30 µm`) | Segments pen-down / pen-up grip dynamics |
| **IC Components** | WLCSP wafer-level chip scale packages | `0.35–0.40 mm` | Accelerometer & BLE Beacon SoC |
| **Power Source** | Printed Zinc-Manganese (Zn-Mn) cell | `0.450 mm` | Eco-friendly disposable power (15–30 hrs) |
| **Grip Encapsulation**| Matte Charcoal TPU film + ribs | `0.450 mm` | Outer tactile grip, environmental seal |
| **Total Assembly** | Full laminated profile | **`0.530 mm`** | Ultra-thin profile feels like normal grip tape |

---

## 🚀 How to Render & Inspect in OpenSCAD

Each `.scad` file in this directory can be rendered independently in **OpenSCAD (2021.01+)**:

### 1. Inspect Individual Components
Open any file in `Sensors/`, `Electronics/`, `Substrate/`, `Battery/`, `Enclosure/`, or `Pen/`. Each file contains standalone render blocks and toggles (e.g., solder balls, passives, laser markings, internal ink cartridge).

### 2. Flat & Multilayer Exploded View
Open `CAD Modelling/Overall Model/Assembly_Flat.scad`:
* **Inspection View**: Set `exploded = false;` to see the unrolled tape with all components mounted.
* **Exploded View**: Set `exploded = true;` and adjust `explosion_gap = 1.5;` to see each layer vertically separated in 3D space.

### 3. Conformal Wrapped Assembly
Open `CAD Modelling/Overall Model/Assembly_Wrapped.scad` or `hardware/smart_grip_tape.scad`:
* Set `wrapped = true;` to view the 1.9× spiral wrap on the 9.0 mm pen barrel.
* Set `cutaway_view = true;` to see a cross-section of the pen barrel, ink cartridge, and wrapped layers.
