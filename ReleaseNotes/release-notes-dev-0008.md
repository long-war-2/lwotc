Welcome to **dev build 8** of Long War of the Chosen!

This is an experimental build in which many changes are being tested out. Many
affect the very early game, so we recommend trying it out on a new campaign. It's
unlikely that all changes will make it into a normal release of the mod, so if
there's anything you particularly don't like, just say! Anything that doesn't work
well will be dropped.

Here are some of the headline changes you may be interested in:

* Reapers, Skirmishers, and Templars have all been reworked to some degree
* You can use `RespecSelectedSoldier` and `RespectAllSoldiers` to update your
 faction soldiers to the new ability trees
* Chosen have been reworked extensively on both tactical and strategy layers
* Missions can now have Sit Reps
* The Sabotage Transmitter mission has been added to the Guerrilla Op pool
* Soldiers will start with lower Will and a narrower range of Wills

**[Download the release from here](https://www.dropbox.com/s/lj9iui1q1om0jf1/LongWarOfTheChosen-1.0-beta-2.zip?dl=0)**

# Changelog

Here are the changes since beta 2:

## Class and ability changes

### Reapers

* Distraction now disorients enemies caught in the Claymore explosion rather
  than putting the Reaper into Shadow. Replaces Walk Fire at LCPL rank.

* Lone Wolf replaces Precision Shot at LCPL.

* Tracking is a new ability that allows Reapers to detect units within
  slightly more than visual range, even if they are out of line of
  sight. Replaces Target Definition at CPL.

* Sting swaps with Silent Killer and Dead Eye replaces Distraction at SGT.

* Highlands replaces Covert at SSGT, with Covert moving to TSGT.

* Covert replaces Death Dealer, Homing Mine replaces Highlands, and
  Precision Shot replaces Lone Wolf at TSGT.

* Disabling Shot is a new ability that stuns most units in the game
  for 2 actions, or for 4 actions if it crits, but it can't to crit
  damage. Replaces Dead Eye at GSGT.

* Hit and Run replaces Homing Mine at GSGT.

* Shadow Rising (one extra Shadow charge) and Serial replace Ghost
  Grenade and Implacable at MSGT. Ghost Grenade is now an XCOM
  ability.

* Reapers now get a normal selection of XCOM abilities like other
  soldier classes.

### Skirmishers

* Reflex can proc once per turn now, but not more than once.

* Justice and Wrath now have a 4-turn cooldown (down from 5).

* Judgement has a greater base chance to cause panic and the higher
  the Skirmisher's Will, the greater the addtional chance for it to proc.

* Full Throttle's mobility buff is now 3 (up from 2) and lasts for 2
  turns (including the turn it activates).

* Whiplash behaves more like Justice and Wrath now, with scaling
  damage, a 1-action-point cost, and a bonus to aim. It still does
  bonus damage to robotic enemies.

* Battlelord now has a 5-turn cooldown in place of charges. It can also
  proc an unlimited number of times on the turn it's active.

* Reckoning is back as a MSGT ability (it provides Fleche and Slash abilities
  that use the Ripjack).

* Manual Override is now targetable and resets all the target's cooldowns.
  Cannot currently be used on self.

### Templars

* Templars no longer have a guaranteed hit on Rend. This means your
  Templars can now graze.

* You can now equip Templars with caster gauntlets (CV, MG and BM)
  instead of the original shard gauntlets.

* The caster gauntlets give the Templar 1 focus at the start of the
  mission and provide Deep Focus and Supreme Focus on MG and BM versions
  respectively. Templars can no longer learn Deep Focus and Supreme
  Focus from their ability trees.

* The shard gauntlets add a Fleche damage bonus and have a higher aim
  bonus than the caster gauntlets.

* Overcharge has been reworked to simply provide bonus aim and defense
  based on the current focus level.

* Templars now have access to a LCPL Meditation ability that can grant 2
  focus at the cost of ending the turn.

* Volt uses area suppression targeting, so the number of units you can
  hit no longer depends on the Templar's focus level.

* There is a new SGT Danger Zone ability that increases the radius of Volt
  by one tile.

* Focus does not provide bonus mobility any more, and it only increases
  dodge by +3 for each point of focus, and damage by +1 at focus levels
  of 1 and 3 (focus levels of 2 and 4 do not add any extra damage
  beyond 1 and 3).

* Pillar can be used in place of a Momentum action. It can still be
  used as a normal action as well.

* Stun Strike now stuns instead of disorienting enemies.

* Templars now have access to a Solace ability for clearing mental
  conditions on their allies. It's a targetable ability rather than an
  aura.

* Templars now get a normal selection of XCOM abilities like other
  soldier classes.

### Miscellaneous

* XCOM soldiers start with lower Will than before, with a much lower range
  of Will values. Will values are now closer to what they were in original
  Long War 2.

* Faction soldier stat progression, particularly HP, has been toned down a
  bit, so they won't be quite so tanky at MSGT.

* Fleche bonus damage is capped at +5, so moving more than 20 tiles with a
  Shinobi Fleche does not provide any extra damage beyond that.

* Full Override's first ability is now Greater Shutdown, which simply shuts
  a robotic enemy down for 3 turns.
  
* Full Override's Master Enemy now has a special variant for Sectopods with
  a much-reduced success chance, which means you have to be quite lucky to
  pull off this mission-winning tactic.

* MECs mastered via Full Override will now become Resistance MECs even if you
  evac them from a mission.

* Bombardier (+2 to grenade range) now works for Reaper Claymores as well.

* Close and Personal is now a tier 2 XCOM ability for Shinobis rather than tier 1.

## Tactical combat changes

* All soldiers now have two new abilities:
  * Stock strike - Strikes a mind-controlled soldier with the butt of your
    weapon, stunning the target for 1 turn. Costs 1 action and ends turn.
  * Get Up - Removes the unconcious effect from a soldier. Costs 2 actions
    and ends turn.

### Chosen

* All Chosen gain Prime Reactions, which are special reaction actions with
  the following restrictions:
  * Prime Reactions can only activate on XCOM's turn.
  * A Prime Reaction only triggers on the Chosen taking damage.
  * The Chosen can't extract, kidnap or summon during these reactions.
  * Warlock can no longer raise a Spectral Army on a reaction.
* All Chosen have lost their innate defense.
* Rescaled their health to match the rest of the changes (using
  Rookie/Veteran/Commander/Legend syntax):
  * M1 Health: 17/20/35/40 -> , Armor: 0/0/2/3 -> 0/0/0/0
  * M2 Health: 23/35/50/55 -> , Armor: 0/0/3/4 -> 0/0/1/2
  * M3 Health: 30/35/50/60 -> , Armor: 0/0/4/5 -> 1/2/3/4
  * M4 Health: 35/40/90/95 -> , Armor: 2/2/5/6 -> 3/4/5/6
* Chosen are immune to the frost effect.
* Rescaled chosen weapon damage to match LW2 values.
* Chosen primary weapon attacks now have a -66% damage mod and daze.
* Chosen secondary weapon attacks now have a -66% damage mod and Heavy Daze.
* Chosen can no longer be critically hit.
* Added Heavy Daze effect, which is like Daze, but:
  * It pierces basic mental immunity.
  * Its revive costs 1 action.
* Revive (from Daze and Heavy Daze) is guaranteed to result in a disoriented
  soldier.
* Revive can no longer be used while burning or disoriented.
* Reviving from Heavy Daze ends the soldier's turn.
* Rebalanced Strengths and Weaknesses:
  * Chosen summoning abilities now have a 4-turn cooldown.
  * Removed Planeswalker from the available strength pool.
  * Shell shock damage bonus reduced to 33%.
  * Brittle Damage bonus reduced to 15%.
  * Bewildered Damage bonus reduced to 25%.
  * Adversary Damage bonus reduced to 25%.
  * Replaced Melee immunity with Melee Resistance, which reduces incoming
    melee damage by 50%.
  * Replaced Blast Shield immunity with a 50% damage resistance.
  * Groundling aim bonus increased to 20.
* Parting Silk now pierces 100 of the target's dodge
* Hunter:
  * No longer has bleeding rounds by default.
  * Will no longer use Tracking Shot, he'll just shoot you normally. Keep
    in mind the negative damage modifier, and the Squadsight long range penalty.
  * Has the ability to teleport to a soldier and extract knowledge from them
    (can only do that when activated, not when engaged).
  * Will no Longer use Tranq Shot, as standard pistol fire has pretty much taken
    over that purpose.
* Warlock:
  * Has Sabotage Weapon and The Elder's Champion, which act pretty much the same
    as A Better Chosen's.
  * Overwhelm Mindshield will now Heavy Daze rather than deal damage.
  * Should now slowly come towards the player (not as fast as the Assassin), rather
    than staying back like the Hunter.

## Missions

* The Sabotage Transmitter mission has been added to the guerrilla op pool.
* Recruit Raids now correctly result in captured XCOM soldiers when appropriate.
* Chosen Sarcophagi should now have higher HP (60/80/80/100 by difficulty).

## Campaign/Geoscape Changes

* The starting region's haven will no longer start with a Faceless in it.
* All rebels start on the Intel job now.
* You can now recruit 2 soldiers from each faction.
* Sit reps can now appear for missions. There is a 30% chance for this to happen.
  If you reach 125% infiltration, any associated sit reps are disabled.
* Sewer plots have been disabled for now to reduce the prevalence of Tunnels maps.
  Subway is still in the pool.
* You can now update soldier ability trees after upgrading LWOTC with the
  `RespecSelectedSoldier` and `RespectAllSoldiers` console commands. The first one
  will respec whichever soldier is selected in the armory when you run the command.

### Chosen

* The Chosen now activate at Force Level 5.
* Can't appear on network tower assaults or non-Chosen Avenger Defense.
* Can now appear on Smash and Grabs and Jailbreaks (Rescue Rebels).
* They start with 3 strengths.
* 25% chance for them to appear on a mission (up from 20%).
* Knowledge gain changes:
  * Decreased Retribution knowledge gain from 15 to 5
  * Increased guaranteed knowledge gain to 5 (from 4)
  * Increased knowledge gain from extract knowledge from 10 to 20
  * Decreased the base kidnap chance to 0
* Activity changes:
  * Chosen at knowledge level 0 can only train, and it is the lowest activity priority
  * They gain Retribution at knowledge level 1, Additional DE at knowledge level 2,
    Sabotage at knowledge level 3 and Avenger assault at knowledge level 4
* Chosen no longer level their stats up with training. They just get a perk now.
* Chosen can now train as much as they need to, thus they no longer have a hard limit
  on perk counts.
* Chosen now level their stats with force level (the FL thresholds are 8/13/17)
* Retribution now reduces the supply, intel and recruit job effectiveness by 33% for
  21 days instead of it's previous effect (should remind myself to update the localization).
  The effect stacks multiplicatively.
* Sabotage chance increased from 75% to 100%.
* Increased the max datapads stolen from 2 to 3.
* Increased the additional wound days of some soldiers from 5 to 9 days.
* Increased the elerium core stolen from 1-2 to 3-5.
* Increased the weapon mod stolen from 1-2 to 3-5.

## Bug fixes

### Strategy

* Soldiers can now equip conventional pistols on existing beta 2 campaigns.
* The stow location for pistols is no longer overridden, so mods like Akimbo should
  now work with LWOTC.
* SPARKs no longer get a pistol slot and other classes can be excluded via the new
  `EXCLUDE_FROM_PISTOL_SLOT_CLASSES` INI setting.
* Faction soldier XCOM abilities no longer increase in AP cost when other abilities
  at the same rank have been picked.
* The GTS upgrade slots now require 1 power instead of 2.

### Tactical

* Fixed a Smash and Grab, alert 2 schedule that should have had 9 enemies but in fact
  had 10. In other words, you might occasionally encounter Smash and Grab missions with
  10 enemies instead of the expected 9.
* Fixed a bug on some VIP Vehicle missions where the VIP wouldn't spawn in the vehicle.
* The Rapid Response dark event no longer forces reinforcements on missions that have a
  Chosen active.
* The Lost no longer stop appearing after you defeat all aliens/ADVENT on the Supply
  Extraction mission.
* The Lost will now appear on Hack, Recover Item and Destroy Object missions if the
  sit rep or Lost World dark event are active.
* Headshot works now if it's enabled.
* Precision Shot now only costs a single action point with the base Vektor Rifle.

## Modding

* Schematics are no longer disabled by default, so mods that provide them should work
  out of the box. However, in most cases, you should provide `ItemTable` entries for
  them in *XComLW_Overhaul.ini* so that individual items can be built.

We hope you enjoy the mod, and good luck commanders!
