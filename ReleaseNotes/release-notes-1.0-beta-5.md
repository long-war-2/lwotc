Welcome to a new version of Long War of the Chosen!

Beta 5 will hopefully be the last of the betas and will for the most part be the same as the 1.0 release version.. sees a lot of changes to LWOTC in several key areas: Chosen, Lost, hero/faction soldiers, psi operatives and more. This is intended to be the last beta before we hit version 1.0 proper.

**IMPORTANT** You should start a new campaign if upgrading from any version prior to dev build 28!

Here are some of the headline changes you may be interested in:

* Reapers are noticeably stronger than before, particularly in the early game
* The Chosen Avenger Assault should be more manageable
* Covert Actions no longer have a chance of capture
* Players should no longer be able to accidentally enable Lost and Abandoned (enabling it tends to break the campaign at some point)

||  **[Download the full beta 5 release from here](https://www.nexusmods.com/xcom2/mods/757?tab=files)** ||

That Nexus page also has a patch zip file that you can use to upgrade an existing LWOTC installation if it's version beta 4.1, dev build 27.x or dev build 28.x. The upgrade zip file should be unpacked into the *XCom2-WarOfTheChosen/XComGame/Mods* directory, overwriting the existing LWOTC and Community Highlander files.

More details on all the balance changes and bug fixes can be found below.

Read the [installation instructions](https://github.com/long-war-2/lwotc/wiki/Installing-Long-War-of-the-Chosen) for information on how to perform the upgrade.

Please feel free to join us on our [Discord server](https://discord.gg/9fUCvcR), or submit feedback via issues in GitHub.

# Changelog

What follows are all the changes to LWOTC since the beta 4.1 release.

## Mods

 * [Community Promotion Screen (CPS)](https://steamcommunity.com/sharedfiles/filedetails/?id=2550561145) is now a required mod

## Controller Support

 * Mission screens on the Geoscape now have button hot links for controller users (e.g. B to cancel, A to launch mission/infiltration)
 * The launch dialog for alien-facility missions now has controller hotlinks
 * Added Haven/Resistance management nav help to geoscape when using the controller
 * Controller users should be able to traverse the options screen now

## Chosen

We have tried to tackle the issue of the Chosen Avenger Defense mission appearing too early for some players by slowing down how quickly they gain knowledge. See the Strategy subsection for more details.

### Warlock

 * Warlock will no longer teleport units that are unable to attack, for example if they've just been summoned or arrived as reinforcements
 * Warlock can no longer cast Warlock's Greatest Champion on unactivated enemies
 * Mind Scorch is now armor-piercing Electrical damage (this does not grant bonus damage to robotic units)
 * Mind Scorch is again castable on units immune to fire
 * Mind Scorch damage rescaled from 1/2/3/4 to 1/2/4/7
 * Danger Zone increases Mind Scorch radius by 2 from 1, and has much higher chance to be selected
 * Lightning Reflexes and Shadowstep strengths replaced with Moving Target

 ### Assassin

 * Assassin's Impact Compensation is now 20% damage reduction per stack, up to a maximum of 3 stacks
 * Infighter replaces Brawler on the Assassin, and Infighter is no longer disabled by burning
 * Chosen now teleport like Avatars when they are unable to move (for example if they're boxed in by the player or immobilized by poison clouds)
 * No longer has Banzai, but can purge any debuffs except Maim via Combat Readiness
 * Assassin gains a new ability, Unstoppable: Mobility cannot go below 7

### Hunter

 * Lightning Reflexes and Shadowstep strengths replaced with Moving Target

### General

 * Chosen no longer have weaknesses except for ones against an adversary (Reaper, Templar, Skirmisher)
 * The bonus damage from adversary weaknesses is now 25%, up from 20%
 * Chosen will no longer show up on the main story missions (otherwise known as Golden Path missions)
 * Knowledge gained from kidnapping is now 4, down from 20
 * Passive knowledge gain per supply drop is now 9, up from 8
 * Chosen Avenger Assault has 6 fewer enemies
 * The "mobile" turrets on Chosen Avenger Assault are now optional, as there is a chance that environment destruction can break those objectives
 * Hunt the Chosen (part 3) covert action now requires 3 master sergeants and the duration of the covert action has been increased by 8 days
 * Chosen Research sabotage reduced to 12 days from 21
 * Chosen Weapon sabotage now steals from 8 to 10 weapon upgrades and requires at least 8 upgrades to activate
 * Chosen Elerium core sabotage now steals from 5 to 10 elerium cores and requires at least 5 elerium cores to activate
 * Chosen Datapad sabotage now steals from 5 to 10 datapads and requires at least 5 datapads to activate
 * Chosen fear of the chosen sabotage now affects 10 random soldiers from 6
 * Chosen Infirmary sabotage to 10 days from 14
 * XCOM's Darklance no longer has Complex Reload
 * XCOM's Katana gains +10 to aim and the Blood Thirst duration is now 5 turns, up from 4

## Classes and abilities

### Reaper

 * Vektor rifle now grants +10 aim
 * Changed Shadow in several ways:
  - Grants a flat +3 Mobility instead of a 20% increase
  - Can now be activated while flanked
  - Detection radius reduction is now 90%, down from 100%
  - Bonuses no longer passively apply when the Reaper starts a mission in concealment (the Reaper *has* to activate Shadow to get them)
 * Reapers get Infiltration by default, which means they can't be detected by towers while in concealment or Shadow; there is no associated bonus to Hack from Infiltration any more
 * Reaper now gets Squadsight at Squaddie
 * Tracking replaces Tradecraft at Squaddie
 * The range of Tracking is now 14 tiles, down from 18
 * New ability: Cheap Shot
  - Once per turn, gain a movement action after shooting a unit damaged this turn with a standard shot of your primary weapon
  - Cannot trigger on the same turn as Knife Encounters
  - Does not work with Serial
  - Works with multi-shot abilities like Banish and Chain Shot
 * Squadsight is now replaced by Cheap Shot at SSGT
 * Death Dealer bonus crit chance is now +25, up from +15
 * Switched Ghost Grenade and Rapid Deployment on the tree
 * Banish cooldown to 3 from 4
 * Total Combat replaces Shadow Grenadier (the latter was too easy to cheese with)
 * Blood Trail (+2 damage and -40 Dodge against units wounded that turn) replaces Tracking
 * Knife Encounters range is now 5 tiles, up from 4
 * Homing Mine ability no longer grants Claymore charges as well
 * Reworked Paramedic:
  - Unlocks an ability to perform a dash move to use a medikit on an ally
  - Grants a free medikit charge
  - Healing abilities restore 2 additional hit points

### Skirmisher

 * Ripjack Slash ability replaces Battlemaster at Squaddie
 * Chain Shot replaces Deadeye
 * Battlefield Awareness (Untouchable with a 4-turn cooldown) replaces Untouchable
 * Manual Override reduces cooldown of abilities by 3 turns instead of effectively resetting them; cooldown of Manual Override itself is now 4 turns, down from 5
 * Reflex additionally reduces crit chances against the Skirmisher by 15 (like Resilience)
 * Combat Presence cooldown is now 5 turns, up from 3
 * Total Combat has several changes:
  - Grants the bonus grenade slot (previously Battlemaster did this)
  - Grants +3 bonus range to grenades, up from 2
  - Grants +1 Mobility and +10 Aim
 * Justice and Wrath bonus Aim is now +15, up from +10
 * Full Throttle bonus to Mobility is now 2, down from 3
 * Interrupt cooldown is now 2 turns, down from 3

### Templar

 * Channel (enemies can drop focus) replaces Concentration
 * Void Conduit damage per tick is now 3, down from 5
 * Templars no longer get passive ablative from their shields
 * Bonus ablative from One For All is now 4/7/11, up from 4/7/10
 * One For All no longer removes burning
 * One For All now uses the Shield Wall visualisation
 * Aftershock bonus aim reduced to +10, down from +15
 * Invert can no longer target Chosen
 * Reworked Crusader's Rage:
  - Gain a 25% damage boost for every 25% HP missing, up to 50%
  - Reduce wound recovery times for this soldier by 4 HP
 * Amplify now applies to the following 3 attacks (up from 2), but has a 3-turn cooldown (up from 2)
 * Fixed the incorrect localization where Arc Wave was said to deal 4/6/8 damage instead of 4/7/10

### Miscellaneous

 * Shooting Sharp bonus aim against units in cover is now +15, up from +10
 * Reworked Chain Lightning:
  - Chain Lightning now uses Volt targeting from vanilla WOTC (not the version used by LWOTC's Volt), with the arc chaining to targets within a 6-tile range of each unit hit
  - It can chain up to 4 times
  - Its cooldown has been reduced to 4 turns
  - It no longer has an aim malus

## Balance

### Strategy

 * Supply Extraction missions require retrieval of at least 4 crates to be a success (previously they were too easy to abuse for free mission XP)
 * Early Intel Raid missions have 1 or 2 fewer enemies than before
 * There are two new covert actions you can run:
   - Obtain a resistance MEC
   - Recruit resistance rebels
 * Disabled the Captured Soldier covert action risk completely (it was too much of a disincentive considering the soldier ranks at stake and the Intel cost required to remove the risk)
 * Covert Action ambush chance now works on a pseudo-random basis - the initial chance is now much lower (down to 5-10% from 15-20%) but it increases every time a covert action completes without being ambushed, resetting back to the initial chance once an ambush does finally proc
 * Restored the Guardian Angel resistance order (prevents ambushes on covert actions)
 * Alien Loot covert action now awards some alloys and elerium, with the quantity depending on how far into the campaign you are
 * Removed the Left Behind dark event (the one that added capture risk to all covert actions)
 * Removed the Counterintelligence Sweep dark event (the one that reduces rebel intel generation by half)
 * Rescued soldiers are now healed for a significant portion of their health to compensate for time spent captured
 * Class abilities purchased with AP when another class ability at the same rank has already been picked once again incur a cost multiplier, though a smaller one than it used to be - the aim being to discourage all AP being funnelled into the A team
 * Snap Shot and Death From Above are mutually exclusive now, because it's a brokenly strong combo that's very cheap
 * When a region is liberated, all job prohibitions due to failed mini retals are immediately cleared

### Tactical

 * Slowed down reinforcements on invasions and recruit retaliations to make these missions a little less oppressive
 * Sectopods should now use their Lightning Field ability on XCOM
 * Shieldbearers will now prioritise good shots over shielding just themselves (but shielding allies still takes precedence over all)
 * Rebels now get Stock Strike and Get Up
 * SPARKs can now trigger and benefit from Focus Fire

## Quality of life

 * Second wave options will now persist between campaigns (so now you only have to disable the tutorial once!)
 * Disabled "Enable Introduction?" alert at the campaign start so people can't accidentally enable Lost and Abandoned, bricking their campaigns
 * Added button on geoscape to access resistance management screen (contributed by Rai)
 * Added loadout button for adviser in outpost management (contributed by Rai)
 * Flashbang resistance is now visible as a passive effect on enemies that have it (Muton Centurions, Elites, Sectoid Commanders, etc.)

## Bug fixes

### Strategy

 * You should no longer encounter blank soldier rewards or buggy rescued soldiers
 * You should no longer encounter Chosen at a higher level than intended for the current force level
 * Faceless rebels can no longer be recruited in a haven if the proportion of Faceless in that haven is greater than 32%
 * Chosen can no longer select uncontacted regions for the Retribution activity

### Tactical

 * The hangs that players experience with dashing-melee attacks like Fleche should be much rarer now, although not gone completely
 * Disabling the pod leader will no longer prevent the rest of the pod from scampering (this fixes a more general issue with pods not scampering if the pod leader skips their move for any reason)
 * Multi-shot abilities will no longer cause lots of lag on missions with many enemies
 * Reinforcement units spawned from the Avenger on the Avenger Defense mission should now always be controllable
 * The Dark VIP should now be correctly extracted if carried by the last soldier to evac
 * Avenger and Flush will now shred targets if the shooter has the Shredder ability
 * Impersonal Edge will no longer trigger on other units' kills
 * The Sniper Defense AI behaviour should now work, making it harder for Sharpshooters to get flanking shots on enemy units that have no sight on XCOM
 * EMP grenades now disorient robotic units as intended 
 * Rend the Mark's effect is no longer permament
 * Terrorize localization no longer incorrectly says that chance to panic is based on Templar's psi offense (it's based on will)
 * Warlock's Greatest Champion should now be properly removed from the Warlock on the death of the affected unit
 * The Purifier's flamethrower should now be using the sweep animation
 * Rend no longer works while the Templar is burning
 * Chosen can kidnap while burning
 * Removed Indomitable and Terrorize from Templar Ghost
 * Blood Trail no longer works on explosives and damage over time (DoTs like bleeding and poison)
 * Zone of Control now works and has a green ring around units with that ability
 * Arc Wave no longer grants focus on killing disoriented units
 * Arc Wave's description now shows the correct values for its damage
 * Combat Rush now triggers on kills with area-of-effect abilities
 * Abilities that apply to "unarmored" units now also work on units that have had all their armor shredded off
 * When Lightning Reflexes triggers, it no longer reduces the effect on *all units on the map* that have Lightning Reflexes
 * Lightning Reflexes will now properly have reduced effect after being procced by abilities like Hunter Protocol and the Lost Grappler's reaction attack
 * Hyper Reactive Pupils no longer procs when any unit misses, not just the one with the HRP PCS
 * Missions can no longer have two or more officers on them (this could happen before if the second officer was not part of the original squad, for example as a haven adviser or Avenger Defense reinforcement)
 * Field Commanders (max-rank officers) now get their +1 bonus to Command range
 * Officer abilities that apply buffs to units in range now apply to haven advisers
 * Units using weapons other than a sniper rifle can now overwatch after using Double Tap
 * Locked On now persists across turns and no longer disappears when the shooter performs a non-offensive action (this is back to the Long War 2 behavior); it now only works for the primary weapon
 * Jammer charges are no longer restored on reloading a save file

## Modding

 * Mods can patch multi-shot abilities that are implemented like Rapid Fire/Chain Shot by adding them to the `MULTI_SHOT_ABILITIES` config array in *XComLW_Overhaul.ini*, fixing a performance issue that causes big pauses on large missions

# Credits and Acknowledgements

A big thanks to the following:

 * Rai for the button on the Geoscape to open the resistance management screen and the button to open the haven adviser's loadout
 * Amnesieri for a bunch of fixes and improvements
 * The Community Highlander team, as we rely heavily on its bug fixes and modding features
 * The people that have provided translations for LWOTC:
   - Russian: FlashVanMaster
   - French: Savancosinus
   - Simplified and Traditional Chinese: cdq55555
 * The folks on XCOM 2 Modders Discord, who have been incredibly helpful at all stages of this project
 * All the folks that have been testing the development builds and providing feedback and issue reports

We hope you enjoy the mod, and good luck commanders!
