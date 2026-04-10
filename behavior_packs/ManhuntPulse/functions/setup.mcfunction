# setup.mcfunction
# Run once to initialize the Manhunt Pulse Tracker.
# Usage: /function setup
#
# This must be run before the manhunt begins so that the
# required scoreboard objectives exist for the tick system.

# Create the pulse timer objective (dummy = no automatic tracking)
scoreboard objectives add timer dummy "Pulse Timer"

# Create the distance objective (reserved for approximate distance display;
# can be written to via scoreboard operations in future expansions)
scoreboard objectives add distance dummy "Distance"

# Reset the shared timer so the pulse cycle starts cleanly
scoreboard players set ManhuntTimer timer 0

# Broadcast setup confirmation and role instructions to all players
tellraw @a {"rawtext":[{"text":"§a§l[MANHUNT]§r §fPulse Tracker initialized! Assign roles:"}]}
tellraw @a {"rawtext":[{"text":"§e  /tag @p add speedrunner §7- marks the speedrunner"}]}
tellraw @a {"rawtext":[{"text":"§e  /tag @p add hunter     §7- marks a hunter"}]}
tellraw @a {"rawtext":[{"text":"§b  Pulse fires every 3 seconds once roles are assigned."}]}
