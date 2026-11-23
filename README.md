# pencilAI ✏️⚡

**Turn any ordinary pen or pencil into a smart, AI-connected writing instrument using ultra-thin disposable grip tape and lightweight classical machine learning.**

`pencilAI` combines a **0.53 mm wrap-around flexible sensor strip** with a **zero-LLM, ultra-fast local recognition pipeline** (Linear Discriminant Analysis + a 26-entry / 26-exit Neural Network). As you write on normal paper, your strokes are converted into clean text inside a live `README.md` file—ready for any AI assistant to read, summarize, or explain on the spot.

<img width="302" height="396" alt="Screenshot 2026-11-23 at 9 40 14 PM" src="https://github.com/user-attachments/assets/d6373ad3-f786-4ea7-98d5-e629e051c6ca" />

(Hardware is being developed)


---

## ✨ Key Highlights

* **Peel, Wrap, Write, Toss:** An ultra-thin (`0.53 mm`), self-contained disposable grip tape that adheres to any standard pen or pencil barrel (`7–11 mm` diameter).
* **True Nib-Level Fidelity:** Mounted directly at the finger grip rather than the top of the pen, eliminating pendulum distortion and capturing crisp letter corners.
* **Zero-LLM Character Recognition:** Runs 100% locally in microseconds using **Linear Discriminant Analysis (LDA)** paired with a **26-in / 26-out Neural Network**—no heavy transformers or cloud latency required for handwriting decoding.
* **Automatic Wrap-Angle Calibration:** Draw a single `"L"` stroke after wrapping a fresh strip to automatically align the 3D accelerometer axes to your hand orientation.
* **Live `README.md` AI Handoff:** Decoded text streams directly into `README.md`, triggering your preferred local or cloud AI watcher to explain, answer, or expand upon your handwritten notes.

---

## 🛠️ Hardware Architecture (`0.53 mm` Disposable Flex Strip)

Designed as a low-cost, single-use flexible strip (`54 mm × 20 mm`) laminated in soft-touch matte TPU grip film:

| Component | Specification | Purpose |
| :--- | :--- | :--- |
| **Substrate** | `25 µm` Polyimide (Kapton) + skin-safe adhesive | Wraps smoothly (`~1.9` turns) around any standard pen barrel |
| **Motion Sensor** | **ST LIS2DH12** (WLCSP, `0.40 mm` height) | Captures 3-axis nib acceleration at `100 Hz` |
| **Pressure Trigger** | Interdigitated printed carbon-ink FSR (`30 µm`) | Wakes the strip on touch and segments pen-down / pen-up strokes |
| **BLE Beacon SoC** | **InPlay IN100 / nRF52810** (WLCSP, `0.35 mm`) | Broadcasts connectionless `100 Hz` BLE advertising packets |
| **Antenna** | Etched copper 2.4 GHz meander trace (`20 µm`) | Positioned along the upper grip margin clear of finger contact |
| **Power Source** | Printed flexible Zinc-Mn paper battery (`0.45 mm`) | Safe for disposal; provides 15–30 hours of active writing |

---

## 🧠 Recognition & AI Pipeline

Instead of running resource-heavy language models to guess characters, `pencilAI` uses a deterministic, low-latency statistical pipeline:

```text
[Disposable Grip Tape]
       │  (100 Hz BLE Advertising: ax, ay, az, grip_pressure)
       ▼
["L"-Stroke Axis Calibration] ──► Aligns arbitrary tape wrap angle
       │
       ▼
[Stroke Segmentation & Resampling] ──► Slices letters via FSR pressure & normalizes to 50 steps
       │
       ▼
[Linear Discriminant Analysis (LDA)] ──► Compresses 150 raw motion features into 25 class-separating components
       │
       ▼
[26 × 26 Neural Network] ──► 25 LDA features + 1 pressure/duration feature ──► Softmax probabilities (A–Z)
       │
       ▼
[Live README.md Output] ──► File watcher triggers AI assistant to explain your notes
```

### Why LDA + 26×26 Neural Net?
1. **Dimensionality Reduction:** Flattening 3-axis acceleration across 50 normalized time steps yields `150` features. LDA projects them onto `25` (`C - 1`) maximally discriminative axes.
2. **26th Engineered Feature:** Appending normalized grip pressure / stroke duration gives the 26-input neural network physical context to separate similar shapes (e.g., `C` vs. `O`, `U` vs. `V`).
3. **Personal Calibration:** Training on ~30–50 handwritten samples per letter (`~1,000` strokes total) tunes the model specifically to your natural grip and stroke cadence.

---

## 📁 Repository Structure

```text
pencilAI/
├── hardware/
│   └── smart_grip_tape.scad    # Parametric 3D OpenSCAD model (flat & wrapped views)
├── firmware/
│   └── beacon_streamer/        # Ultra-low-power 100 Hz BLE accelerometer + FSR broadcaster
├── software/
│   ├── calibrate.py            # "L"-stroke 3D rotation matrix alignment
│   ├── model.py                # scikit-learn LDA + 26-to-26 Neural Network classifier
│   └── watcher.py              # Live README.md writer & AI explainer trigger
└── README.md
```

---

## 🚀 Quick Start

### 1. Inspect the 3D Hardware Model
Open `hardware/smart_grip_tape.scad` in **OpenSCAD** (`2021.01` or newer):
* Toggle `wrapped = true` to inspect the `1.9x` spiral wrap on a `9.0 mm` pen barrel.
* Toggle `show_top_cover = false` for an x-ray view of the interdigitated carbon FSR, copper meander antenna, and WLCSP chips.

### 2. Calibrate a Fresh Strip
1. Peel and wrap a `pencilAI` strip around your pen's grip zone.
2. Launch the receiver app on your laptop (`python software/watcher.py`).
3. Write a single **`L`** (vertical downstroke followed by a horizontal right stroke) on paper to lock in the wrap orientation.

### 3. Write & Get AI Explanations
Start writing in block letters. Decoded text appears automatically in your target `README.md`, where your configured AI assistant reads the updated file and explains concepts, solves problems, or summarizes your notes in real time.

---

## 📄 License
MIT License — free to build, modify, and experiment with.

