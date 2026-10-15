# 😈 Die Again: Troll Game Ever — Godot 4 (GDScript) Edition

This is the full **Godot 4.x** port of **Die Again: Troll Game Ever**, written in **GDScript** (the specialized gaming language designed specifically for the Godot engine).

---

## 🎮 How to Open & Run in Godot

1. Download and install **Godot 4** (version 4.2+ or 4.3+) from [godotengine.org](https://godotengine.org/) or via Homebrew:
   ```bash
   brew install --cask godot
   ```

2. Open Godot Engine and click **"Import"**.
3. Browse to and select:
   ```
   dont-die/godot_project/project.godot
   ```
4. Click **"Import & Edit"**.
5. Press **F5** (or the Play button at top-right) to run the game!

---

## 🕹️ Controls

| Action | Keyboard | Touch / Mobile |
| :--- | :--- | :--- |
| **Move Left** | `A` or `← Left Arrow` | On-screen Left Button |
| **Move Right** | `D` or `→ Right Arrow` | On-screen Right Button |
| **Jump / Short Hop** | `Space`, `W`, or `↑ Up Arrow` | On-screen Jump Button |
| **Quick Restart** | `R` | Top bar `Restart` button |
| **Troll Clue / Hint** | `H` or Click `💡 Clue` | Tap `💡 Clue` |
| **Level Select** | Click `☰ Levels` | Tap `☰ Levels` (Levels 1–256) |
| **Audio Toggle** | Click `🔊` | Tap `🔊` |

---

## 📁 Project Architecture

- `project.godot`: Project settings, viewport (800x450 canvas stretch), input actions, autoloads.
- `scripts/`:
  - `player.gd`: CharacterBody2D player with Coyote time (0.10s), jump buffer (0.12s), variable jump cut, inverted gravity, inverted controls, shocked face `O_O`, and squash-and-stretch.
  - `block.gd`: LevelBlock AnimatableBody2D handling solid, crumble, fake (pass-through), invisible, bouncy trampoline, and ice blocks.
  - `spike.gd`: Directional spikes with inset fair collisions, jumping spikes, and hidden popup spikes.
  - `door.gd`: Exit door with pulsing portal animation, fleeing door, rocket door, and fake decoy reveals.
  - `troll_manager.gd`: Evaluates all 15 level triggers (collapsing bridges, shy fleeing doors, copycat spikes, gravity flips, ceiling crushes, reversed controls) and procedural trial triggers.
  - `main.gd`: Game loop, level loading, camera shake, and death/respawn handling.
  - `audio_manager.gd`: Autoload sound manager playing retro 8-bit sound effects.
  - `hud.gd`: Level titles, death counter, hint banner, level select grid, and touch buttons.
- `scenes/`: Ready-to-use `.tscn` scene files for Main, Player, Block, Spike, Door, HUD, and FloatingText.
- `data/levels.json`: All 256 handcrafted and procedural trial levels.
- `audio/`: Retro 8-bit WAV audio files (jump, death, troll, trap, door, win).
- `assets/`: High-resolution logo and icons.
