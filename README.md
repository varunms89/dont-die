# 😈 Die Again: Troll Game Ever

A hilarious, fast-paced 2D troll puzzle platformer inspired by **Level Devil** and **Die Again: Troll Game Ever**. 

The goal looks deceivingly simple: **reach the door**. But every step is a trap. The floor crumbles under your feet, the door runs away, spikes jump when you jump, ceilings crush you, gravity inverts, and the game constantly finds new ways to troll you.

---

## 🕹️ Available Editions

### 1. 🎮 Godot 4 (GDScript) — Specialized Gaming Language
Located in [`godot_project/`](file:///Users/varunms/.gemini/antigravity/scratch/dont-die/godot_project):
- Full **Godot 4** project with dedicated GDScript scripts and scenes (`.tscn`).
- Open `godot_project/project.godot` directly in the Godot 4 editor.
- See [`godot_project/README.md`](file:///Users/varunms/.gemini/antigravity/scratch/dont-die/godot_project/README.md) for instructions.

### 2. 🐍 Python (Pygame-CE)
Located in [`python_game/`](file:///Users/varunms/.gemini/antigravity/scratch/dont-die/python_game):
- Run immediately with Python: `pip install -r python_game/requirements.txt && python3 python_game/main.py`.
- Standalone desktop edition with full audio, physics, and troll mechanics.
- See [`python_game/README.md`](file:///Users/varunms/.gemini/antigravity/scratch/dont-die/python_game/README.md) for details.

### 3. 🌐 Web & Mobile (TypeScript + Vite + Capacitor)
- **Local Dev:** `npm run dev` (runs at http://localhost:5173/)
- Android Capacitor project in `android/`.

---

## ✨ Features

- **15 Handcrafted Troll Levels:**
  1. *Level 1: Just a normal walk* — Deceptively peaceful until the floor drops 2 steps before the door!
  2. *Level 2: Don't look down* — A bridge that collapses domino-style behind you.
  3. *Level 3: Copycats* — Spikes that jump whenever you jump!
  4. *Level 4: Where are you going?* — A shy door that dashes away when you approach.
  5. *Level 5: Watch your head* — A low ceiling of spikes that crushes down if you jump.
  6. *Level 6: Too good to be true* — A fake decoy door that laughs and relocates across the room.
  7. *Level 7: Gravity has left the chat* — Gravity suddenly inverts, sending you walking on the ceiling.
  8. *Level 8: Brain lag* — Inverted controls zone (Left is Right, Right is Left!).
  9. *Level 9: Seeing is not believing* — Visible fake blocks that drop you into spikes, and invisible solid steps.
  10. *Level 10: To infinity and beyond* — A door that rockets into the stratosphere and parachutes down elsewhere.
  11. *Level 11: Ice, ice, baby* — Slippery zero-friction ice runway with sudden popup spikes.
  12. *Level 12: Watch above* — Falling ceiling stalactites triggered as you run underneath.
  13. *Level 13: High voltage trampoline* — Bouncy pads propelling you towards ceiling hazards.
  14. *Level 14: Lights out* — Darkness mode with a dynamic player flashlight.
  15. *Level 15: The Final Gauntlet* — The ultimate marathon combining multiple troll tricks, ending in confetti celebration!

- **Snappy Physics & Responsive Controls:**
  - Coyote time (0.10s) and jump buffering (0.12s) for responsive platforming.
  - Variable jump height (release jump early for short micro-hops).
  - Expressive player character with dynamic blinking eyes, shocked `O_O` expressions when traps trigger, and squash-and-stretch animations.
  - Instant snappy respawns (0.28s) so you can die and retry immediately.

- **Procedural Web Audio Engine:**
  - Zero external sound files — 100% synthesized in real time via Web Audio API.
  - Retro jump chirp, comical splat/pop death noise, trap warning whistle, level clear arpeggio, and an upbeat 8-bit chiptune background groove.
  - Quick mute toggle (`M` or audio button).

- **Mobile & Touch Friendly:**
  - Responsive virtual arcade D-Pad (`◀`, `▶`) and tactile `JUMP` button.
  - Multi-touch enabled (run and jump simultaneously).
  - Toggle touch overlay with the `📱` button anytime.

- **🛠️ Built-in Custom Level Editor:**
  - Build your own troll levels right in the browser!
  - Place solid, crumble, fake, invisible, bouncy, and ice blocks.
  - Place floor and ceiling spikes, player spawn, and doors.
  - One-click instant **Playtest** mode.
  - Export and copy level JSON directly to clipboard.

---

## 🕹️ Controls

| Action | Desktop Keyboard | Mobile / Touch |
| :--- | :--- | :--- |
| **Move Left** | `A` or `← Left Arrow` | Left D-Pad button |
| **Move Right** | `D` or `→ Right Arrow` | Right D-Pad button |
| **Jump / Short Hop** | `W` / `Space` / `↑ Arrow` | `JUMP` Button |
| **Quick Restart** | `R` | `↻ Restart` button |
| **Level Menu** | Click `☰ Levels` | Tap `☰ Levels` |
| **Level Editor** | Click `🛠️ Editor` | Tap `🛠️ Editor` |

---

## 🚀 Development & Scripts

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build production bundle
npm run build

# Preview production build
npm run preview
```
