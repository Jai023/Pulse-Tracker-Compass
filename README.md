# Manhunt Pulse Tracker

A **Minecraft Bedrock Edition (MCPE) Behavior Pack** addon that brings a Dream-style Manhunt experience to your world. Hunters receive periodic pulse updates — directional arrow indicators and distance-based sound feedback — pointing them toward the speedrunner.

---

## Features

| Feature | Details |
|---|---|
| **Role system** | Tag-based — no custom commands required |
| **Pulse tracking** | Fires every 3 seconds (60 ticks) |
| **Direction indicator** | ⬆ NORTH · ⬇ SOUTH · ➡ EAST · ⬅ WEST shown on each hunter's actionbar |
| **Proximity alert** | Title pop-up when speedrunner is within 20 blocks |
| **Distance-based sound** | Five tiers from deep bass (far) to high-pitched pling (very close) |
| **Optimised** | Commands only execute when both roles are present |

---

## Folder Structure

```
behavior_packs/ManhuntPulse/
├── manifest.json
└── functions/
    ├── tick.json          ← registers tick.mcfunction to run every game tick
    ├── setup.mcfunction   ← creates scoreboards; run once before the hunt
    ├── tick.mcfunction    ← increments timer; fires pulse every 60 ticks
    ├── pulse.mcfunction   ← direction detection, actionbar updates, sound call
    └── sound.mcfunction   ← distance-based playsound for each hunter
```

---

## Installation

1. Copy the `behavior_packs/ManhuntPulse/` folder into the `behavior_packs/` directory of your Minecraft world (or package the folder as a `.mcaddon` zip).
2. Activate the pack in your world's **Behavior Packs** settings.
3. Enable **cheats** (required for `/function` and `/tag` commands).

---

## Setup & Usage

### 1 — Initialise scoreboards (run once per world)
```
/function setup
```
This creates the `timer` and `distance` scoreboard objectives and resets the pulse timer.

### 2 — Assign roles
```
/tag @p add speedrunner   ← tag the speedrunner
/tag @p add hunter        ← tag each hunter (repeat for each hunter)
```
Remove a tag at any time with `/tag @p remove <tagname>`.

### 3 — Start the hunt
The pulse fires automatically every 3 seconds as soon as at least one player has the `speedrunner` tag **and** at least one player has the `hunter` tag. No additional command is needed.

---

## How It Works

### Tick system (`tick.mcfunction` + `tick.json`)
`tick.json` registers `tick.mcfunction` to run every game tick (20×/s).  
The function increments a shared scoreboard counter (`ManhuntTimer`) only while both roles are active. When the counter reaches 60 it calls `pulse.mcfunction` and resets.

### Pulse system (`pulse.mcfunction`)
Runs at each 3-second interval and for every hunter:
- Sends an actionbar notification.
- Checks which direction the speedrunner lies relative to the hunter using bounding-box position comparisons and updates the actionbar with the matching arrow.
- Fires a title pop-up if the speedrunner is within 20 blocks.
- Calls `sound.mcfunction` to play distance-aware audio.

### Sound system (`sound.mcfunction`)
Uses the `r` and `rm` entity-selector arguments to determine which distance tier applies, then plays `note.pling` or `note.bass` at the appropriate pitch:

| Distance | Sound | Pitch |
|---|---|---|
| ≤ 10 blocks | `note.pling` | 2.0 (very high) |
| 11 – 30 blocks | `note.pling` | 1.5 |
| 31 – 60 blocks | `note.pling` | 1.2 |
| 61 – 100 blocks | `note.pling` | 0.9 |
| > 100 blocks | `note.bass` | 0.8 (deep) |

### Direction system
Each hunter's direction check runs `execute at @s` so the bounding box is centred on that hunter. East and West checks are evaluated last so they take priority for diagonal positions. Enable **Show Coordinates** in world settings for exact coordinate readout alongside the directional arrows.

---

## Compatibility

- Minecraft Bedrock Edition **1.20.0** and above
- Works on mobile (MCPE), console, and Windows 10/11 editions
- No Scripting API required — pure `.mcfunction` commands only

---

## Packaging as `.mcaddon`

Zip the `ManhuntPulse/` folder and rename the archive with a `.mcaddon` extension:

```bash
cd behavior_packs
zip -r ManhuntPulse.mcaddon ManhuntPulse/
```

Double-tap / open the `.mcaddon` file on your device to import it automatically.
