Welcome to a new version of Long War of the Chosen!

Here are some of the headline changes you may be interested in:

* Regular soldiers now have a pistol slot and the pistol abilities work (conventional pistols won't be available in existing campaigns, only new ones, but you will be able to equip pistols that you build)
* The old LW2 Smash and Grab mission is back, so you will now get a mix of that and the Supply Extraction mission
* Headshot on The Lost is now disabled by default on Commander and Legend difficulties (configurable in INI)
* You can enable a campaign Advanced Option so that you can purchase multiple class abilities at the same rank (this is blocked by default to prevent XCOM power creep)
* Reapers, Skirmishers and SPARKs now have laser and coilgun variants of their primary weapons (we would really appreciate new models and skins for these!)
* You will now face the correct Chosen on the Stronghold assault

**[Download the release from here](https://www.dropbox.com/s/lj9iui1q1om0jf1/LongWarOfTheChosen-1.0-beta-2.zip?dl=0)**

More details on all the balance changes and bug fixes below.

**IMPORTANT** If you're upgrading from beta 1 or a development build and want to continue an existing campaign, make sure you load a strategy save after the upgrade, i.e. one that was created while you were on the Avenger.

Read the [installation instructions](https://github.com/long-war-2/lwotc/wiki/Installing-Long-War-of-the-Chosen) for information on how to perform the upgrade.

Most balancing feedback comes from Legend players right now, so we would greatly appreciate feedback from Rookie, Veteran and Commander players. You can join us on our [Discord server](https://discord.gg/9fUCvcR), submit feedback via issues in GitHub, or start a thread on the [Pavonis Interactive forums](https://pavonisinteractive.com/phpBB3/viewforum.php?f=22).

# Changelog

Here are the changes since beta 1:

## Mods

* [Revival Protocol Fixes](https://steamcommunity.com/sharedfiles/filedetails/?id=1123037187) is now a required mod
* [Dedicated Pistol Slot](https://steamcommunity.com/sharedfiles/filedetails/?id=1705464884) is now a required mod
* [Reliable Smoke](https://steamcommunity.com/sharedfiles/filedetails/?id=650751923) is recommended to get LW2-like behavior for smoke grenades
* [Show More Buff Details](https://steamcommunity.com/sharedfiles/filedetails/?id=709499969) is recommended so you can see status durations, like how long a hack or mind control will last

## Class and ability changes

* Reapers, Skirmishers and SPARKs now have laser and coilgun variants of their weapons, although new models and skins that match the aesthetic of the tiers would be welcome contributions!
* Purchasing a class ability at the same rank as you have already picked one will incur a cost penalty: the first such ability will cost 1.5x normal, the next one will cost double, the next 2.5x and so on (this penalty is tracked per soldier) - this only affects faction soldiers unless you have enabled the Advanced Option to allow purchasing extra class abilities for regular soldiers
* The random XCOM abilities have been changed so each soldier gets 4 tier 1 abilities, 2 tier 2, and 1 tier 3, at costs of 10AP, 20AP and 40AP respectively - this is to provide soldier variety without making them overpowered
* Pistol abilities will now work if a soldier has a pistol equipped in the dedicated pistol slot
* Removed Light 'em Up from Sharpshooter XCOM branch (allowed Sharpshooter to shoot twice in one turn with no cooldown)
* Rapid Fire now has a 1-turn cooldown, i.e. it will be unavailable for just one turn after the turn it's used
* Chain Lightning has a -50 penalty to aim
* Resilience crit defense reduced from 50 to 30 - since the Sectopod now has it, didn't want to make it *that* hard to crit the thing

## Tactical combat changes

* On Commander and Legend, Headshot no longer works on The Lost, making them more of a tactical challenge (you can change this setting for all difficulties via the `HEADSHOT_ENABLED` property in _XComLW\_Overhaul.ini_)
* The Lost's turn now occurs between XCOM and the aliens - this stops The Lost from wasting all the enemy's overwatch shots
* The Lost now target both XCOM and the aliens 50% of the time each (basically Fair Lost Targeting)
* Purifiers and the Chosen now have more HP and armor
* Purifiers have a higher chance to hit (but the flamethrower is still blocked by full cover)
* Teamwork now requires line of sight to work (just like the officer ability Command)
* Enemies on yellow or red alert have an increased detection radius (a small increase for yellow, a larger one for red) - this makes it harder to keep a non-stealth-focused Shinobi concealed for a whole mission, encouraging their use as fighters; also nerfs spotters for snipers
* Reinforcements should now drop more randomly, rather than often dropping in the same spot every turn
* All unique sources of hack defense reduction (Redscreen Rounds, Bluescreen Bombs, Arc Pulser etc.) now stack with one another, but they cannot stack with themselves, i.e. multiple hits with Redscreen Rounds won't reduce the hack defense more than a single hit
* Redscreen Rounds reduce hack defense by 30, up from 25 - this makes up for the fact they no longer stack with themselves
* The death of the Templar Ghost no longer triggers Vengeance if it's active
* Mutons have a cooldown for their bayonet attacks, so Combatives will only lock them down for one turn before they shoot
* Auto Loaders and Expanded Magazines can no longer be used on the same weapon (the combination gives certain high damage builds a significant power boost)
* Scopes give +4/+7/+10 Aim, Hair Triggers give +4/+7/+10 Aim (after reaction fire penalty)
* Stocks provide a 20/25/30% chance of Grazing Fire (extra roll to turn a miss into a graze)
* Steady Weapon has been moved from stocks to sniper rifles and the bonus crit chance has been removed
* Fusion sword burn chance reduced to 10%, Arc Blade stun chance reduced to 5% - reduces the surprisingly high lockdown chance when combined with Combatives and Bladestorm
* Sectopods now have Resilience (-30% crit chance for soldier targeting it) - makes the unit less susceptible to Kubiriki shots
* Extended Information's shot HUD will now be used automatically if that mod is installed

## Missions

* The Lost will no longer appear on missions before Force Level 3, since Rookies have a hard time dealing with them - this also means they won't show up on Gatecrasher
* The old LW2 Smash and Grab (with a revealed start) can now spawn instead of the Supply Extraction mission (basically a 50-50 chance of getting one or the other)
* Supply Extraction mission rewards significantly less alloys and elerium now, bringing it close to the old Smash and Grab rewards - the mission was leaving players swimming in alloys and elerium by mid game, making it very easy to build plenty of coilguns
* The disabled-UFO mission will no longer grant corpses or end automatically once all enemy units are dead if the beacon wasn't disabled in time - this also fixes a bug where the mission wouldn't end if you didn't disable the beacon in time
* Chosen Stronghold now requires 100% infiltration, just like the Golden Path missions
* The final room in the Chosen Stronghold now has more enemies at the start, and more spawn than before when the Chosen is "killed"


## Campaign/Geoscape Changes

* Liberation 1 missions are now labeled "Start Liberating Region" to help newcomers understand it's an important mission and what it's for
* It is no longer possible to enable the Lost and Abandoned mission or the Precision Explosives Advanced (Second Wave) Option - the former caused campaigns to bug out and the latter does nothing because LWOTC adds damage falloff to all grenades anyway
* You can now activate an "Allow Same Rank Abilities" Advanced Option at the beginning of the campaign or during one so that you can purchase class abilities with AP on regular soldiers (once the Training Center has been built), not just faction soldiers
* The covert actions for tracking down the Chosen require higher-rank soldiers than before, slowing down access to more resistance order slots and the stronghold mission
* The Find Faction covert actions now require SGT and SSGT soldiers - this is to slow down the acquisition of the other faction soldiers, making the starting faction more impactful
* The Find Faction covert actions now reward soldiers at CPL and SGT (for nearest and furthest factions respectively)
* Reaper HQ now generates significantly less Intel than it did before (1-4 every two days)
* Templar HQ only improves healing rate by 25% now instead of 50%
* Corpse rendering, Basic Research, Engineering Research, ADVENT datapad decryption and Alien Data Cache decryption can no longer be inspired (so you should get more useful inspirations now)
* Faction soldiers can now go on Combat Intelligence covert actions
* The Counter Attack dark event has been disabled because it was interacting badly with the yellow alert reflex actions (the ones taken after a pod scampers)
* Troopers no longer get Lightning Reflexes from the tactical (i.e. permanent) dark event of the same name (for now...) - WOTC introduced a new dark event with exactly the same name as an existing LW2 one, which was causing a conflict
* The Information War resistance order now requires the second level of faction influence - it pretty much guaranteed control of drones in the early game
* Volunteer Army resistance order has been disabled - the extra soldier is too strong for every mission, even as just a distraction
* Munitions Expert and Bomb Squad resistance orders have been disabled because they only apply to proving ground projects that don't exist in LWOTC
* Suit Up resistance order has been disabled as it saves too much research time for WAR Suit, EXO Suit and the mobile armor techs (it was also disabled in LW2)
* Machine Learning resistance order has been disabled because breakthroughs are currently disabled
* The weapon attachment Proving Ground projects are now easier (require fewer attachments) and cheaper to build

## Bug fixes

### Strategy

* You will now face the correct Chosen on their Stronghold assault mission
* Supplies lost to Faceless will now be correctly deducted from the supply drop
* Shaken soldiers can no longer train as officers until they have recovered
* Wounded SPARKs that are already infiltrating a mission can no longer be selected for other missions
* Psi operatives will now show a promote icon if they can be promoted (but they still need to be placed in a psi training tube to rank up)
* You should no longer find Sting grenades, Dense smoke or Ghost grenades in the Avenger's inventory
* Scientists assigned to the infirmary will no longer contribute to research
* Scientist haven advisers will no longer reduce research speed more than they should (they aren't contributing to research, but the bug meant that this "penalty" was in effect doubled, reducing the effective scientist count by an extra 1)
* You can no longer get disabled resistance orders as continent bonuses
* Covert Actions will definitely not award promotions now (a bug meant the previous attempt at this didn't work)
* Soldiers will no longer roll empty XCOM abilities
* Soldier respec times are now the same as LW2, i.e. they get longer the higher the rank of the soldier being respecced
* The correct soldier XP is now displayed in soldier lists
* All PCSes have images now

### Tactical

* Concealment should no longer break because enemy units have mysteriously teleported behind XCOM
* Enemy detection radii will now vary based on infiltration percentage - underinfiltrated missions will have higher detection radii, overinfiltrated will have lower
* Coilguns now shred for 2 armor rather than 1
* Panicked soldiers should now only ever hunker down
* Psi zombies can no longer drop loot
* Napalm X now works
* Trojan works properly now, removing all action points from the targeted unit when a hack wears off
* Mind-controlled XCOM soldiers that are stunned no longer remain stunned when the mind control is removed or wears off
* Patrolling enemies should no longer cause civilians to yell, which was putting those enemies on yellow alert
* Haven advisers that are bleeding out at the end of intel retaliation, non-evac full retaliation, and other such missions will no longer die
* Soldiers that are bleeding out at the end of the Supply Extraction mission will no longer be recovered (they will die instead)
* Faceless civilians should no longer appear on missions other than Neutralize VIP unless the Infiltrator dark event is active
* Breaking out of the hack animation early will now put Haywire on cooldown or remove the Full Override charge depending on which ability was used to start the hack
* Gunners' knife attack and Shinobis' Slash can now target mind-controlled team mates
* Locked On now works if other squad members attack the same target in between the Locked-On shots
* Whirlwind now activates after Slash, not just Fleche

# Credits and Acknowledgements

A big thanks to the following:

* Grobobobo for his many contributions (and nerfs!)
* Favid for his coding contributions (again)
* Anthogator for doing the much needed but desperately boring job of removing bad Faceless civilian entries from the mission schedules
* Veehementia for the [Dedicated Pistol Slot](https://steamcommunity.com/sharedfiles/filedetails/?id=1705464884) mod and adding a hook to configure it for LWOTC
* Hotchocletylez for use of [Vektor Crossbows](https://steamcommunity.com/sharedfiles/filedetails/?id=1773420239) (used for Reaper's laser and coilgun variants)
* Iridar for use of [Enemy Within MEC Weapons](https://steamcommunity.com/sharedfiles/filedetails/?id=1626184587) (used for SPARK lasers and coilguns)
* The team behind [Covert Infiltration](https://github.com/WOTCStrategyOverhaul/CovertInfiltration/wiki) for sharing solutions to some problems, like preventing Lost and Abandoned being selected
* The folks on XCOM 2 Modders Discord, who have been incredibly helpful at all stages of this project
* All the folks that have been testing beta 1 and development builds and providing feedback and issue reports

We hope you enjoy the mod, and good luck commanders!
