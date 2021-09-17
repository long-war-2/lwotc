Welcome to **dev build 28.2** of Long War of the Chosen!

This build largely contains balance changes.

Headline changes:

 * The Chosen Avenger assault should now happen later so players have an actual chance to defeat the relevant Chosen beforehand
 * Covert actions no longer have a Soldier Captured risk
 * Chain Lightning actually chains now and has no aim penalty, but it can't hit as many enemies as before
 * The Community Promotion Screen is no longer part of the LWOTC package: you will have to subscribe to it on Steam Workshop

To install dev build 28.2, just delete your existing LongWarOfTheChosen, X2WOTCCommunityHighlander, etc. folders from the *Mods* directory and unpack the following zip there:

||  **[Download the full release from Nexus Mods](https://www.nexusmods.com/xcom2/mods/757?tab=files)** ||

**Upgrading from dev build 27** The above link also contains an update package you can use to upgrade dev build 27.x or 28 to dev build 28.2, instead of deleting the old version. If you use this, you will need to **delete the X2CommunityPromotionScreen folder from the *Mods* directory** and subscribe to Community Promotion Screen on the Steam Workshop.

# Changelog dev build 28.2

 * Yellow-alert reflex actions, civilians running and other related issues are now fixed
 * Chosen no longer have weaknesses except for the adversary ones (Reaper, Templar, Skirmisher)
 * The adversary weaknesses are now slightly stronger (from +20% damage to +25%)
 * One For All no longer removes burning
 * One For All now uses the Shield Wall visualisation
 * Rebels now get Stock Strike and Get Up
 * New tutorial boxes have been added for the Chosen to help players adjust to the changes

# Changelog dev build 28.1

 * Faction soldier AP costs for class abilities are now correct
 * Burning no longer disables all the abilities in the universe
 * Cheap Shot no longer procs against undamaged units
 * Cheap Shot no longer works with Serial (brings it into line with similar action-refunding abilities, like Hit and Run)

# Changelog dev build 28

## General

 * Disabled the Captured Soldier covert action risk completely (it was too much of a disincentive considering the soldier ranks at stake and the Intel cost required to remove the risk)
 * Covert Action ambush chance now works on a pseudo-random basis - the initial chance is now much lower (down to 5-10 from 15-20) but it increases every time ambush does *not* happen, and resets back to initial chance once it finally does.
 * Slowed down reinforcements on invasions and recruit retaliations
 * Reworked Chain Lightning: Chain Lightning now uses Volt targeting, with the arc chaining to
    targets within 6-tile range, up to 4 times. The cooldown has been
    reduced to 4 and the aim malus removed since the overall effect is
    weaker than before.
 * When a region is liberated, all job prohibitions due to failed mini retals are immediately cleared
 * Restored Guardian Angel resistance order (prevents ambushes on covert actions)
 * The ability point cost multiplier for buying multiple perks per rank is now much lower, but death from above and snapshot are now completely mutually exclusive abilities.

## Reaper

 * Vektor rifle now grants +10 aim
 * Shadow now grants flat +3 Mobility instead of a 20% increase
 * Banish cooldown to 3 from 4
 * Death Dealer bonus crit chance is now +25, up from +15
 * Switched Ghost Grenade and Rapid Deployment on the tree
 * New ability: Cheap Shot - once per turn, gain a movement action after shooting a unit damaged this turn with standard shot of your primary weapon. Cannot trigger on the same turn as Knife Encounters.
 * Reaper now gets Squadsight at Squaddie
 * Squadsight is now replaced by Cheap Shot at SSGT
 * Removed the hack bonus from Infiltration (the ability tied to Shadow that prevents ADVENT towers from breaking concealment on the unit)

The Reaper marksman and grenadier Reaper builds were underperforming compared to the knife one. This should hopefully make them more viable choices.

## Chosen

 * Mind Scorch is now armor-piercing Electrical damage 
 * Mind Scorch is castable on units immune to fire again
 * Mind Scorch damage rescaled from 1/2/3/4 to 1/2/4/7
 * Danger Zone increases Mind Scorch radius by 2 from 1, and has much higher chance to be selected

 The intention behind the changes is to make Warlock not completely countered by wearing hazmat vests and mind shields. For clarification, Electrical is just a damage type, it does not deal any bonus damage to robotic units by itself. 

 * Chosen now teleport like avatars when they are unable to move when they should.

This fixes the issue of people boxing in the chosen, and them getting completely immobilized by poison cloud
They can only use teleport as a prime reaction and only when they have no other available options.


 * Knowledge gained from kidnapping is now 4, down from 10
 * Passive knowledge gain per supply drop is now 9, down from 12
 * Hunt down the chosen part III covert action now requires 3 master sergeants, and the duration of the covert action is increased by 8 days

 Chosen Avenger Assault should happen much later on average and people should no longer have any problems killing the Chosen before they can launch their assault.
 
 * Chosen assassin no longer has banzai and is able to purge any debuffs but maim
 * New Ability: Unstoppable - Mobility cannot go below 7.
 * Assassin gains Unstoppable

 * Lightning Reflexes and Shadowstep strengths on warlock and hunter are now replaced with Moving Target

 * Chosen Research sabotage reduced to 12 days from 21
 * Chosen Weapon sabotage now steals from 8 to 10 weapon upgrades and requires at least 8 upgrades to activate
 * Chosen Elerium core sabotage now steals from 5 to 10 elerium cores and requires at least 5 elerium cores to activate
 * Chosen Datapad sabotage now steals from 5 to 10 datapads and requires at least 5 datapads to activate
 * Chosen fear of the chosen sabotage now affects 10 random soldiers from 6
 * Chosen Infirmary sabotage to 10 days from 14

 * Warlock can no longer cast Warlock's Greatest Champion on unactivated enemies 

## Quality of life

 * Disabled "Enable Introduction?" alert at the campaign start so people can't accidentally enable Lost and Abandoned, bricking their campaigns
 * Updated the Simplified and Traditional Chinese localization, thanks to cdq55555
 * Updated the French localization thanks to Savancosinus
 * Updated the Russian localization thanks to FlashVanMaster
 * Improved the clarity of various other ability descriptions
 * Courtesy of Rai (a contributor):
   - Added button on geoscape to access resistance management screen
   - Added loadout button for adviser in outpost management
 * The launch dialog for alien-facility missions now has controller hotlinks
 * Added Haven/Resistance management nav help to geoscape when using the controller

 ## Bug Fixes

 * Fixed the bug where Rend the Mark effect was permament
 * Fixed Terrorize localization incorrectly saying that chance to panic is based on Templar's psi offense (it's based on will)
 * Potentially fixed a bug with Warlock's Greatest Champion not getting removed on unit death sometimes
 * Fixed the bug where alien loot covert action was not getting improved properly
 * Fixed unintended behavior where you could start in the 2 region links
 * Finally Fixed the issue with purifier flamethrower not having the sweep animation
 * Fixed a pretty big oversight where chosen could not kidnap when burning (whoops)
 * Fixed another oversight where rend could work while burning
 * Fixed a bug where chosen selected uncontacted regions for retribution
 * Removed Indomitable and Terrorize from Templar Ghost
 * Fixed Blood trail working on explosives and DOT
