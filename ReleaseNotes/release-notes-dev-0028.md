Welcome to **dev build 28** of Long War of the Chosen!

This build largely contains balance changes.

**Important** After installing the new build, Remove the local version of Community promotion screen, and download back the workshop version. We no longer need a local build for it.

# Balance

## General

 * Disabled the Captured Soldier Covert action risk completely
 * Covert Action ambush chance now works on a Pseudo-random basis - the initial chance is now much lower (down to 5-10 from 15-20) but it increases every time ambush does *not* happen, and resets back to initial chance once it finally does.
 * Slowed down reinforcements on invasions and recruit retaliations
 * Reworked Chain Lightning: Chain Lightning now uses Volt targeting, with the arc chaining to
    targets within 6-tile range, up to 4 times. The cooldown has been
    reduced to 4 and the aim malus removed since the overall effect is
    weaker than before.
 * When A region is liberated, all job prohibitions due to failed mini-retals are immediately cleared
 * Restored Guardian Angel resistance order
 * The Ability point cost multiplier for buying multiple perks per rank is now much lower, but death from above and snapshot are now completely mutually exclusive abilities.

## Reaper

 * Vektor rifle now grants +10 aim
 * Shadow now grants flat 3 mobility from 20%
 * Banish cooldown to 3 from 4
 * Death dealer bonus crit to 20 from 15
 * Switched ghost grenade and rapid deployment
 * New ability: Cheap shot - Once per turn, Gain a movement action after shooting a unit damaged this turn with standard shot of your primary weapon. Cannot trigger on the same turn as Knife Encounters.
 * Reaper now gets squadsight on squaddie
 * Squadsight is now replaced by cheap shot
 * Removed the hack bonus from infiltration

The reaper marksman and grenadier reaper builds were underperforming compared to the knife one, this should hopefully make them more viable choices.

## Chosen

 * Mind Scorch is now Armor-piercing Electrical Damage 
 * Mind Scorch is castable on units immune to fire again
 * Mind Scorch Damage rescaled from 1/2/3/4 to 1/2/4/7
 * Danger Zone increases Mind Scorch radius by 2 from 1, and has much higher chance to be selected

 The intention behind the changes is to make warlock not completely countered by wearing hazmat vests and mind shields.
 For clarification, elecrtical is just a damage type, it does not deal any bonus damage to robotic units by itself. 

 * Chosen now Teleport like avatars when they are unable to move when they should.

This fixes the issue of people boxing in the chosen, and them getting completely immobilized by poison cloud
They can only do that on a prime reaction, and when they have no other available options.


 * Knowledge gained from kidnapping is now 4, down from 10
 * Passive knowledge gain per supply drop is now 9, down from 12
 * Hunt down the chosen part III covert action now requires 3 master sergeants, and the duration of the covert action is increased by 8 days

 Chosen avenger, on average, should happen much later, and people should no longer have any problems killing them before they can launch the avenger assault.

 * Chosen Research sabotage reduced to 12 days from 21
 * Chosen Weapon sabotage now steals from 8 to 10 weapon upgrades and requires at least 8 upgrades to activate
 * Chosen Elerium core sabotage now steals from 5 to 10 elerium cores and requires at least 5 elerium cores to activate
 * Chosen Datapad sabotage now steals from 5 to 10 datapads and requires at least 5 datapads to activate
 * Chosen fear of the chosen sabotage now affects 10 random soldiers from 6
 * Chosen Infirmary sabotage to 10 days from 14

 * Warlock can no longer cast WGC on unactivated enemies 

 # QOL
 * Disabled "Enable Introduction?" alert at the campaign start so people can stop being confused by it
 * Updated the Simplified Chinese localization, thanks to cdq55555
 * Updated the French localization, thanks to Savancosinus
 * Updated the Russian localization thanks to FlashVanMaster
 * Improved the clarity of various other ability descriptions
 * Added button on geoscape to access resistance management screen
 * Added loadout button for adviser in outpost management
 * Made Alien Facilities controller compatible
 * Added Haven/Resistance management Navhelp to geoscape when using the controller

 # Bug Fixes

 * Fixed the bug where rend the mark effect was permament
 * Fixed terrorize localization incorrectly saying that chance to panic is based on templar's psi offense (it's based on will)
 * Potentially fixed a bug with warlock's greatest champion not getting removed on unit death sometimes
 * Fixed the bug where alien loot covert action was not getting improved properly
 * Fixed unintended behavior where you could start in the 2 region links
 * Finally Fixed the issue with purifier flamethrower not having the sweep animation
 * Fixed a pretty big oversight where chosen could not kidnap when burning (whoops)
 * Fixed another oversight where rend could work while burning
 * Fixed a bug where chosen selected uncontacted regions for retribution
 * Removed Indomitable and Terrorize from Templar Ghost
 * Fixed Blood trail working on explosives and DOT
