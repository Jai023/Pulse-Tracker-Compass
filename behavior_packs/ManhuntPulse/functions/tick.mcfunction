# tick.mcfunction
# Registered in functions/tick.json so Minecraft runs this every game tick
# (20 times per second).
#
# Prerequisites: /function setup must have been run once to create the
# "timer" and "distance" scoreboard objectives.
#
# Logic:
#   1. Only advance the timer when at least one speedrunner AND one hunter
#      are present – avoids unnecessary work and stops the timer between rounds.
#   2. Every 60 ticks (3 seconds) trigger pulse.mcfunction and reset the timer.

# Increment the shared pulse timer by 1 each tick (only when both roles exist)
execute if entity @a[tag=speedrunner] if entity @a[tag=hunter] run scoreboard players add ManhuntTimer timer 1

# Fire the pulse every 60 ticks and reset the counter
execute if entity @a[tag=speedrunner] if entity @a[tag=hunter] if score ManhuntTimer timer matches 60.. run function pulse
execute if entity @a[tag=speedrunner] if entity @a[tag=hunter] if score ManhuntTimer timer matches 60.. run scoreboard players set ManhuntTimer timer 0
