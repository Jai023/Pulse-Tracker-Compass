# sound.mcfunction
# Called by pulse.mcfunction via:
#   execute as @a[tag=hunter] at @s run function sound
#
# Execution context when called:
#   @s  = the hunter receiving the sound
#   ~~~ = the hunter's current position
#
# The "r" selector argument checks the speedrunner's distance from the hunter's
# position (the current execution origin). Closer distance → higher pitch and
# faster perceived frequency; farther → lower pitch and bass tone.
#
# Distance tiers:
#   ≤ 10 blocks  → Very close  (high-pitched pling, pitch 2.0)
#   11–30 blocks → Close       (mid-high pling, pitch 1.5)
#   31–60 blocks → Medium      (mid pling, pitch 1.2)
#   61–100 blocks→ Far         (low pling, pitch 0.9)
#   > 100 blocks → Very far    (bass thump, pitch 0.8)
#
# Only one tier fires per call because each subsequent check uses "rm" (minimum
# range) so ranges are mutually exclusive.

# Very close (≤ 10 blocks) — rapid high-pitched ping
execute if entity @a[tag=speedrunner,r=10] run playsound note.pling @s ~~~ 1 2.0 1

# Close (11 – 30 blocks) — fast mid-high ping
execute if entity @a[tag=speedrunner,rm=10,r=30] run playsound note.pling @s ~~~ 1 1.5 1

# Medium (31 – 60 blocks) — moderate ping
execute if entity @a[tag=speedrunner,rm=30,r=60] run playsound note.pling @s ~~~ 1 1.2 1

# Far (61 – 100 blocks) — low-pitched ping
execute if entity @a[tag=speedrunner,rm=60,r=100] run playsound note.pling @s ~~~ 1 0.9 1

# Very far (> 100 blocks) — deep bass thump indicating a distant target
execute if entity @a[tag=speedrunner,rm=100] run playsound note.bass @s ~~~ 1 0.8 1
