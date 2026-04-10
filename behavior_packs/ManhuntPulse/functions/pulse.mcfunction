# pulse.mcfunction
# Triggered by tick.mcfunction every 60 ticks (3 seconds).
#
# Responsibilities:
#   1. Show an actionbar notification to every hunter.
#   2. Determine the cardinal direction of the speedrunner relative to each
#      hunter and update the actionbar with a directional arrow.
#   3. Show a title alert when the speedrunner is very close.
#   4. Call sound.mcfunction for each hunter so distance-based audio plays.
#
# Direction logic uses Minecraft's coordinate system:
#   North = decreasing Z   South = increasing Z
#   East  = increasing X   West  = decreasing X
#
# Bounding-box checks (x, z, dx, dz) are relative to each hunter's position
# via "execute at @s". For diagonal positions East/West takes priority over
# North/South because those checks run last (last actionbar write wins).
# Example: if the speedrunner is to the northeast, both the NORTH and EAST
# checks pass, but EAST is written last so hunters see "➡ EAST".
#
# Note: Bedrock Edition does not provide a native way to read exact player
# coordinates into command text. Enable "showcoordinates true" via gamerule
# or the world settings to display coordinates in the HUD alongside this
# directional tracking system.

# ── Initial pulse notification ────────────────────────────────────────────────
titleraw @a[tag=hunter] actionbar {"rawtext":[{"text":"§e§l[MANHUNT] §r§bPulse Active — Tracking Speedrunner..."}]}

# ── Direction detection (one check per hunter) ────────────────────────────────

# NORTH — speedrunner Z is lower than hunter Z (negative Z direction)
# Box: full X range, Z from (hunterZ - 10 000) up to (hunterZ - 1)
execute as @a[tag=hunter] at @s if entity @a[tag=speedrunner,x=~-10000,z=~-10000,dx=20000,dz=9999] run titleraw @s actionbar {"rawtext":[{"text":"§e§l[MANHUNT] §r§fTarget: §a⬆ NORTH"}]}

# SOUTH — speedrunner Z is higher than hunter Z (positive Z direction)
# Box: full X range, Z from (hunterZ + 1) up to (hunterZ + 10 000)
execute as @a[tag=hunter] at @s if entity @a[tag=speedrunner,x=~-10000,z=~1,dx=20000,dz=9999] run titleraw @s actionbar {"rawtext":[{"text":"§e§l[MANHUNT] §r§fTarget: §a⬇ SOUTH"}]}

# EAST — speedrunner X is higher than hunter X (positive X direction)
# Box: X from (hunterX + 1) to (hunterX + 10 000), full Z range
execute as @a[tag=hunter] at @s if entity @a[tag=speedrunner,x=~1,z=~-10000,dx=9999,dz=20000] run titleraw @s actionbar {"rawtext":[{"text":"§e§l[MANHUNT] §r§fTarget: §a➡ EAST"}]}

# WEST — speedrunner X is lower than hunter X (negative X direction)
# Box: X from (hunterX - 10 000) to (hunterX - 1), full Z range
execute as @a[tag=hunter] at @s if entity @a[tag=speedrunner,x=~-10000,z=~-10000,dx=9999,dz=20000] run titleraw @s actionbar {"rawtext":[{"text":"§e§l[MANHUNT] §r§fTarget: §a⬅ WEST"}]}

# ── Proximity alert (title pop-up when very close) ────────────────────────────
# r=20 selects the speedrunner only if they are within 20 blocks of the hunter
execute as @a[tag=hunter] at @s if entity @a[tag=speedrunner,r=20] run titleraw @s title {"rawtext":[{"text":"§c§l⚠ VERY CLOSE! ⚠"}]}

# ── Distance-based sound feedback ─────────────────────────────────────────────
# Delegate to sound.mcfunction, inheriting the hunter's execution context
execute as @a[tag=hunter] at @s run function sound
