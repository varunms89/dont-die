# 🐍 Die Again: Troll Game Ever — Python Edition

A standalone desktop version of **Die Again: Troll Game Ever** built with **Python 3** and **Pygame-CE**.

---

## 🚀 Quick Start

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
   *(or `pip install pygame-ce`)*

2. Run the game:
   ```bash
   python3 main.py
   ```

---

## 🕹️ Controls

| Key | Action |
| :--- | :--- |
| `A` / `←` | Move Left |
| `D` / `→` | Move Right |
| `Space` / `W` / `↑` | Jump (Short tap = short hop, hold = high jump) |
| `R` | Quick Restart level |
| `H` | Show / Hide Troll Clue |
| `L` | Open Level Select Menu (jump to any level 1–128+) |
| `M` | Toggle Mute Sound |

---

## ✨ Features Included

- All 256 handcrafted and procedural trial levels loaded from `data/levels.json`
- Real-time 8-bit sound effects (jump, death, troll chime, trap fall, win)
- Full troll mechanics: collapsing floors, falling ceilings, jumping spikes, shy fleeing doors, gravity flips, inverted controls, decoy doors
- Expressive player character with dynamic blinking and shocked `O_O` expressions
- Coyote time and jump buffering for responsive platforming
