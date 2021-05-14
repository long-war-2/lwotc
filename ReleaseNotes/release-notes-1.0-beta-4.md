Welcome to a new version of Long War of the Chosen!

Beta 4 sees a lot of changes to LWOTC in several key areas: Chosen, Lost, hero/faction soldiers, psi operatives and more. This is intended to be the last beta before we hit version 1.0.

**IMPORTANT** You should start a new campaign if upgrading from beta 3.1 or earlier!

Here are some of the headline changes you may be interested in:

* Chosen have been completely reworked and now play very differently
* Templars and Reapers have been changed significantly in terms of both abilities and equipment, and how they function/play
* The Lost now appear in smaller numbers on average, but that scales with alert level
* The XCOM row perks have been refreshed so soldiers are more likely to get appropriate/useful abilities for their class
* Much improved controller support (thanks to kdm2k6)

||  **[Download the release from here]()** ||

More details on all the balance changes and bug fixes below.

Read the [installation instructions](https://github.com/long-war-2/lwotc/wiki/Installing-Long-War-of-the-Chosen) for information on how to perform the upgrade.

Please feel free to join us on our [Discord server](https://discord.gg/9fUCvcR), submit feedback via issues in GitHub, or start a thread on the [Pavonis Interactive forums](https://pavonisinteractive.com/phpBB3/viewforum.php?f=22).

# Changelog

Here are the changes since beta 3.1:

## Chosen

The Chosen have been significantly reworked to be more challenging in tactical battles and have a greater impact on the strategy game. Specifically, they are stronger than they were, but they only appear on retaliations and story missions where you generally have a large squad. To compensate for their increased difficulty, there are fewer enemies on the map when a Chosen is present and rebels have been buffed (see tactical changes).

They are now enabled by default.

### All Chosen

 * Now guaranteed to appear in the following missions, but won't appear in any others: intel raid, supply convoy (retaliation mission), recruit raid, Haven defense retaliations, Chosen Avenger Defense, invasions and the Golden Path (story) missions
 * Kidnap is now a 2-action-point ability that remotely kidnaps a bleeding out or unconscious soldier, and it no longer makes the Chosen leave the battlefield
 * Start with no strengths, but they get them regularly via the Training activity
 * Strengths are tiered, 1-4, with their power scaling with tier - tier 4 strengths make the Chosen very tough to deal with!
 * Activate at force level (FL) 5
 * Automatically upgrade to the next tier at force levels 9, 14 and 20
 * Take their turn before ADVENT/aliens
 * Cause ALL alien units to bleed units out instead of kill them (from only chosen having that passive)
 * Spawn much closer to XCOM and are instantly engaged
 * Immune to frost
 * No longer daze
 * No longer disable reinforcements
 * No longer summon by default
 * Drop alloys and elerium when killed

 In addition, we have:

 * Removed the Chosen-specific dark events
 * Added new Combat Readiness ability to the Chosen - gain a stackable 1-turn buff of +10 Aim and +10 Defense (when in cover and not flanked) that also removes Immobilized (from Maimed and Crippling Strike)
 * Given the Chosen prime reactions, but those reactions are limited to moving and Combat Readiness only
   - A new Second Wave option ("Baby Chosen") disables prime reactions when enabled
 * Increased Shell Shocked damage boost to 50% from 34%
 * Reduced Adversary Weakness dmg boost to 20% from 25%
 * Reworked and added many strengths
 * Given Chosen crit "immunity", with XCOM's crit chance against them incurring a -200% penaly, but their HP, armor and defense have been reduced
 * Decreased missions' alert level by 5 if a Chosen is present

### Chosen Hunter

Stays around 25-30 tiles away, high mobility, tries to pick off your soldiers while slowly retreating, if possible will try to flank from squadsight

Hunter has a new set of starting abilities:

 * Combat Readiness
 * Anticipation (50% damage reduction against dashing melee attacks)
 * Low Profile
 * Infighter
 * Disabler (pistol shots disable the target's primary weapon)
 * Ready for Anything
 * Quickdraw
 * Long Watch

### Chosen Assassin

Assassin – Close quarter menace, each bending reed move is now a lot shorter but it conceals. Low initial sword damage and crit damage, but almost always crits and damage gets boosted with each use.

 * She can enter concealment when she doesn't have the range to attack (?)
 * No longer has Bending Reed
 * No longer conceals after Parting Silk
 * Parting Silk can target civilians
 * Her sword attacks cannot be blocked by Combatives
 * Her prime reaction is now a move towards the closest target followed by a Slash if she's next to a target
 * Throws blind grenades for free with a 1-turn cooldown, but its radius has been reduced to 2 tiles from 3 1/3
 * Blind effect sight radius to 4 from 5
 * Harbor Wave deals sword-level damage, while its cone range has decreased from 25 to 15; Blood Thirst increases Harbor Wave's damage, but Harbor Wave does not trigger Blood Thirst

Assassin has a new set of starting abilities:

 * Blood Thirst (attacks grant a stackable flat damage boost that is cleared when the Chosen captures a unit)
 * Brawler (30% damage reduction within 4 tiles)
 * Impact Compensation (stackable 25% damage reduction after taking damage that lasts to the end of the Assassin's turn)
 * Banzai (same as Combat Readiness, but it additionally removes most debuffs, not just Immobilized)
 * Hit and Run
 * Gains Slash (the adjacent-only melee attack that's not turn ending)

### Chosen Warlock

Now is the support unit master and mid-range king. No longer gets neutered by mindshield. The weakest by himself, but can summon and make a lot of other units stronger.

mind scorch uses area suppression targeting, now has a 70% chance to set the target on fire instead of dazing, and deals low amount of damage

 * Mind control cooldown increased by 1
 * Teleport ally now grants the ally unit an action

Warlock has a new set of starting abilities:

 * Combat Readiness
 * Close Combat Specialist
 * Grazing Fire
 * The Warlock's Greatest Champion (grants energy shield to ally plus 67% damage reduction and bonuses to Aim, crit chance, Will and Psi Offense)
 * Chosen Summon

### Chosen Weapons (the rewards for XCOM)

 * All XCOM chosen weapons lose their built-in attachments and have different special abilities compared to vanilla WOTC
 * Weapon damage has been standardized to coil tier, except for the katana which is mag tier and has only +10% bonus accuracy
 * Arashi gains:
   - Vampirism - dealing damage with this weapon restores the same amount of health
   - Brawler - 30% damage reduction if attacker is within 4 tiles
   - Impact Compensation - after taking damage, grants 25% damage reduction for the rest of the turn
 * Katana:
   - gains Blood Thirst - after attacking with this weapon, gain a stackable +3 damage buff that lasts for 3 turns
   - -10 to Aim
 * Darklance gains:
   - Mark for Death - mark a target for 1 action point that lasts till end of XCOM's next turn, which refunds the action point cost of standard (not Snap Shot) shots against that target
   - +1 to magazine size
   - +10 Aim, +20 crit chance
   - Complex Reload - reloads end the turn (replaces the standard reload)
 * Darkclaw gains Fatality - grants +100 aim and crit chance against targets at 35% HP or less
 * Disruptor Rifle:
   - gains Overbearing Superiority (critical hits with this weapon refund actions) and Wrath Against Unworthy (+100% crit chance against psionic units)
   - +10 Aim

## The Lost

Beta 4 introduces two new Lost units to LWOTC:

 - Grapplers: slow units with average HP that has Bladestorm
 - Brutes: large, high-HP units that leak acid and shred armour

More generally, the Lost now spawn much closer to XCOM than before and the size of each pod scales with alert level.

Additionally:

 * Fewer Lost appear in pods, up to a 50% reduction compared to before
 * The number of Lost that appear scales with ADVENT strength in the region (internally, mission alert level)
 * Lost and Lost Dasher HP scales from 2 to 12 as the campaign progresses
 * Lost damage also scales with force level (roughly the date in the campaign)
 * Normal Lost units have had their mobility buffed from 8 to 14
 * Lost start appearing from force level 5, up from FL 3
 * Headshot is now also disabled on Veteran (it's still enabled on Rookie)
 * ADVENT/aliens should target the Lost a lot less now, making the Lost more of a threat to XCOM than a distraction for the enemy

## Mods

 * If you're using LeaderEnemyBoss's No Drop Down List mod (highly recommended!) then switch to the [controller-compatible WOTC version](https://steamcommunity.com/sharedfiles/filedetails/?id=2098062078)
 * Kiruka has done a fantastic job of balancing and bridging various mods to LWOTC via [Mod Jam](https://steamcommunity.com/sharedfiles/filedetails/?id=2299170518), such as Rocket Launchers 2.0, Gene Mods, and Dual Wield Pistols 2.0 among many others

### Detailed Soldier Lists

This mod is no longer integrated into LWOTC; we're using a modified version of the old LW2 one instead. If you would like to continue using Detailed Soldier Lists instead, you can just subscribe to the mod from the Workshop. Just be aware that it won't display officer ranks, nor will it display the correct XP for a soldier.

As the built-in soldier list UI does not display XP, we recommend that you subscribe to [Extended Personnel Info](https://steamcommunity.com/sharedfiles/filedetails/?id=1458945379) if you want to see additional information from soldier list views.

One very noticeable thing that has changed is the icon for Combat Intelligence: it is now the text "AP" coloured the same as with Detailed Soldier Lists. In addition, the icon can have up to four coloured points in the corners indicating the level of Combat Intelligence:

 * Red, no corner pips - Very Low CI
 * Amber, 1 corner pip - Low
 * Yellow, 2 corner pips - Average
 * Green, 3 corner pips - High
 * Blue, 4 corner pips - Very High

## Class and ability changes

**IMPORTANT** Hero classes can no longer purchase multiple class abilities at each rank by default. In order to get that behaviour, you can enable the Allow Same Rank Abilities second wave option (which applies to normal soldier classes as well).

### Reapers

We decided that the Reaper was far too dependent on permanent stealth, with Silent Killer being the must-have ability. This limited what you could really do with them and made them feel quite weak before they got Silent Killer. It also constrained build variety.

The old Reaper was also far too strong at cheesing certain types of mission. And lastly, Claymores were problematic because they were difficult to mod and could delete pods too easily.

Reapers no longer have permanent stealth. Instead, Shadow is a cooldown-based ability that grants a "cloak" for 2 turns, which is basically a very strong version of concealment, similar to vanilla WOTC's Shadow. For players used to permanent stealth, it may take a while to adjust to the new mechanics. However, we do think this makes the unit more interesting to play, especially as you don't need to worry as much about losing concealment/Shadow.

In addition to the Shadow changes, we've removed the Claymore in favour of throwing knives - thanks to Musashi for letting us use these. This was partly because the Claymore was hard to mod, but also because it was a bit of a one-trick pony. Reapers still keep Homing Mine and have Remote Start in their XCOM pool of random abilities. We also added Shadow Grenadier that allows Reapers to use any type of grenade without breaking Shadow.

Throwing knives are low-damage, short-range weapons that can be used without losing Shadow (the Vektor still breaks Shadow by default). These knives have a nice bonus to crit chance, so they can do a fair bit of damage from flanking attacks.

Lastly, the Vektor Rifle now behaves more like a strike rifle from LW1, with a slight penalty to Aim at close range, but it can be used from Squadsight - up to a point - without penalty. However, as with the Sharpshooter Snap Shot ability, the aim penalty for range starts applying about 5 tiles from outside normal weapon range and increases more agressively than for Snap Shot.

To fit with that theme, we're now using NotSoLoneWolf's laser and coilgun strike rifle models for those tiers of the Vektor rifle family, replacing the crossbows from before. The alternate conventional-tier crossbow is still available to use if you like it.

<img src="https://github.com/long-war-2/lwotc/raw/master/Media/Reaper%20Abilities.png" width=580 title="New Reaper ability tree"/>

New and reworked abilities:

 * Shadow lasts for 2 turns, has a 2-turn cooldown and reduces detection radius by 100%
 * Knife Juggler adds +1 throwing knife, +1 damage to throwing knives, and makes it so that kills with the primary weapon grant an extra knife
 * Shadow Grenadier allows the Reaper to throw grenades without breaking Shadow and also adds a grenade pocket to the class
 * Shooting Sharp grants ranged attacks +2 armor piercing and  +10 aim against units in cover
 * Crippling Strike is an active ability that throws a knife (consumes a knife charge) resulting in the target being Maimed if hit (they have 0 Mobility but can perform other actions)
 * Paramedic grants a free medikit charge, adds +2 charges to any equipped medikits, and makes the first use of a medikit each turn a free action
 * Bluescreen Knives grants throwing knives +2 armor piercing and makes them disorient robotic enemies
 * Banish shots can now crit, but each subsequent shot has -15 Aim compared to the previous one (so the 4th shot will have a -45 Aim penalty); the ability now has a 4-turn cooldown instead of a single charge
 * Knife Encounters grants a bonus action after a knife is thrown at an enemy within 4 tiles; procs no more than once per turn (like Close Encounters)
 * Death Dealer works for both the primary and secondary weapons
 * Impersonal Edge reduces Shadow cooldown by 1 turn and grants a stackable +20 Aim for 3 turns when the Reaper kills a unit with a knife
 * Packmaster grants +1 charge to every utility item equipped, including any grenades in the grenade pocket
 * Rend the Mark grants throwing knives a stackable effect when they hit an enemy that applies +50% crit chance against the target from all sources for the remainder of the turn; each Rend the Mark stack does not affect the knife throw that applied it
 * Homing Mine has 4 charges

### Skirmishers

Skirmishers work largely the same as in beta 3.1, but their abilities have been updated to account for only being able to pick one class ability at each rank by default. Some changes have been introduced for balance reasons or just to try to make the class more interesting.

Here's the current ability tree:

<img src="https://github.com/long-war-2/lwotc/raw/master/Media/Skirmisher%20Abilities.png" width=580 title="New Skirmisher ability tree"/>

New and reworked abilities:

 * Total Combat now grants Bombardier and Volatile Mix on top of the existing behavior
 * Packmaster grants +1 charge to every utility item equipped, including any grenades in the grenade pocket
 * Damn Good Ground now works on Justice and Wrath
 * Interrupt is a free action on a 3-turn cooldown that places the Skirmisher into a Battlelord-like overwatch, with the number of actions during the enemy turn limited to however many action points the Skirmisher had when activating Interrupt
 * Judgement has a +20% chance to proc
 * Only one of Close Encounters or Hit and Run can proc on a single turn
 * Reckoning no longer grants the free slash

### Templars

The Templar has been reworked substantially to differentiate it from the Shinobi. The class now carries a shield instead of the autopistol that provides interesting defensive abilities. Note that the Templar now has a pistol slot so can still equip an autopistol at the cost of 1 Mobility.

The shield grants the following:

 * 0/3/6 passive ablative HP based on the shield's tier
 * Makes the Templar ignore 2/4/6 HP in wound calculations
 * +30 Defense against flanking shots or if the Templar is not in cover

In addition, the Templar:

 * Loses 5 base Dodge, bringing it inline with other soldier classes
 * Loses +2 Aim that comes from the Squaddie rank
 * Has lower Aim progression overall
 * Loses 5% Aim bonus from the gauntlets (it's now +20% instead of +25%)
 * Loses 10% base crit chance on the gauntlets

Here's the current ability tree:

<img src="https://github.com/long-war-2/lwotc/raw/master/Media/Templar%20Abilities.png" width=580 title="New Templar ability tree"/>

New and reworked abilities:

 * Volt has +1 tile radius, has Aftershock built in, and no longer ends turn
 * Rend no longer has bonus damage from either focus or Fleche, but its base damage is now 4-6/6-9/9-12 based on gauntlet tier and it grants 1 focus on attack (hit or miss) rather than on kill
 * One for All provides high cover to adjacent allies and grants +4/7/10 ablative to the Templar based on shield tier, but applies a -30 Defense penalty to the Templar (stacks with the Defense provide by cover or the shield)
 * Invert now has Exchange incorporated into it, requires line of sight, requires the target to be within normal weapon/visual range, and has a 2-turn cooldown
 * Amplify is now a free action, but the bonus damage is 25% (down from 33%) and it only lasts for a single attack
 * Indomitable grants the Templar 1 focus when attacked for the first time each turn
 * Stun Strike has 85% to-hit chance, but no longer knocks targets back
 * Shield Bash is a new ability that bashes an enemy in melee range, knocking them back 2 tiles and doing 2-4/4-7/7-10 damage based on shield tier
 * Brawler grants 35% damage reduction against attacks from within 4 tiles
 * Pillar is now a free action and doesn't cost focus, but it has a 4-turn cooldown
 * Overcharge now grants +10% crit chance per point of focus instead of +5 Defense
 * Void Conduit always last 2 ticks and the damage per tick has been increased to 5
 * Concentration upgrades grazes to normal hits
 * Superior Aptitude makes Rend grant an additional +1 focus on attacks
 * Arc Wave's splash damage is no longer based on focus but gauntlet tier: 4/7/10
 * Crusader's Rage grants 50% increased damage when the Templar has 50% HP or less, and reduces max damage taken for wound recovery calculations by 4 HP (i.e. the Templar has shorter wound recovery times in general)
 * Impact Compensation grants a stacking 25% damage reduction after each attack against the Templar, lasting until the end of turn; all stacks and other sources combine multiplicatively rather than additively
 * Ionic Storm no longer grants focus on kills
 * Apotheosis now lasts for 2 turns and grants +20 Dodge for each point of focus above 2 consumed when activating the ability (so 3 focus consumed -> +20 Dodge, 4 focus consumed -> +40 Dodge)
 * Ghost now has a 5-turn cooldown instead of charges and works with Brawler, Impact Compensation, Concentration, Overcharge and Fortress

### Psi Operatives

Many thanks to Iridar for permission to use the three new abilities below which come from his More Psi Abilities mod!

 * Replaced Schism with Phase Walk - teleports the operative to any tile within line of sight and 18-tile range
 * Replaced Stasis Shield with Null Ward - grants ablative to the operative and nearby allies
 * Replaced Soul Merge with Soul Storm - deals psi damage in an area around the operative that also destroys cover and damages allies in range
 * Insanity has a much reduced chance to mind control, but has a much higher chance to panic (MC chance was too strong for a spammable  ability)
 * Stasis can no longer target large units, i.e. ones that occupy more than one square (Sectopods and Gatekeepers)
 * Mind Merge now grants more ablative, crit chance and Will as you can no longer get Soul Merge
 * Soul Steal heals for more HP and grants ablative HP that lasts 3 turns
 * Fuse is now a free action and removes all charges of the explosive from the target so they can't use the ability at all
 * Void Rift now applies rupture to all targeted enemies and the Insanity chance is higher
 * Dependencies between psi abilities have been reworked:

[![New psi ability tree](https://preview.redd.it/gpg2lro454451.png?width=718&format=png&auto=webp&s=347c24ebd1517a89a334957366d5641bbca563b4 "New psi ability tree")]

### Combat Intelligence

 * Combat Intelligence is now rolled as part of Not Created Equal
 * Starting combat intelligence before/without NCE is now Average (the old "Gifted")
 * Combat Intelligence is tied to Psi Offense in the NCE rolls, so high psi offense == high com int and low psi offense == low com int
 * Ability Point rewards and costs have been rebalanced, mostly to rein in the ability to make faction soldiers godly by dumping all AP into them:
   - Soldiers get +4 AP for each promotion, down from +5
   - Hero MSGT abilities cost 30, up from 25
   - Costs of purchasing class abilities at ranks that already have one picked scales up faster (multiplier from 1.5 to 1.7)
   - Difficult/very difficult mission AP rewards down from 3/5 to 1/3
   - Ability Points covert action now rewards more at Rookie, very slightly more at Veteran, but rewards a little less on Legend compared to before
 * High-combat-intelligence faction soldiers no longer get nearly as much soldier AP (ability points) as before, so they're more inline with normal soldiers

### Miscellaneous

 * All faction/hero soldier classes get a pistol slot
 * Faction soldiers no longer get their specific GTS upgrades
   - Parkour is now an XCOM-row ability for Skirmishers
   - Mentally Awake and Infiltration have simply been removed
 * All XCOM row abilities have been shaken up, with new abilities being added:
   - There are now 4 tiers of XCOM-row (random) abilities
   - All soldier classes get 2 x tier 1, 2 x tier 2, 2 x tier 3 and 1 x tier 4
   - Each random pool of abilities is more tuned for its corresponding soldier class, i.e. there should be fewer "useless" abilities rolled
   - XCOM-row and pistol abilities at all ranks can now be purchased regardless of the soldier's rank, as long as the Training Center has been built
 * Shinobis have Hit & Run and Hunter's Instinct swapped, so Hit & Run comes at TSGT and competes with Reaper (gives shooty Shinobis their power spike at the same rank as sword Shinobis)
 * Infighter Dodge bonus is now 33 (up from 25)
 * Lone Wolf scales linearly with distance from 0/0 bonus at 4-tiles distant to +12/+12 at 7-tiles distant or greater, so you don't lose the whole bonus as soon as you step within 7-tile range
 * Bring 'em On now works with explosives
 * Phosphorus has been reworked so that the flamethrower's base damage ignores fire immune targets and shreds 1/2/3 armor based on weapon tier
 * Combat Protocol now does more damage at tiers 2 and 3 of the Gremlin
 * Executioner and Locked On grant +20/+20 Aim/Crit, up from +10/+10
 * Walk Fire no longer has a cooldown, and does 34% reduced damage, down from 50%, i.e. it does *more* damage than before
 * Interference is now a free action
 * Cyclic Fire malus to 10 from 15, ammo count to 3 from 5, cooldown to 2 from 5
 * Cyclic Fire is now 3 standard shots (like Rapid Fire is 2 standard shots), whereas before it was a single shot that applied damage 3 times - this means stacking effects like Impact Compensation will proc three times rather than once
 * Shieldwall grants 5 armor from 3
 * Aim ability grants +20 Crit Chance in addition to +20 Aim
 * Flush's Dodge debuff increased to 30 from 10
 * Hail of Bullets ammo cost down from 4 to 3
 * Hail of Bullets, Cyclic Fire and Walk Fire can now be used with shotguns
 * Grazing Fire now works for all abilities/weapons that use standard aim, including those that use secondary or other non-primary weapons
 * Scanning Protocol now has 3 charges, up from 1
 * Needle Grenades now do +1 damage to unarmored targets
 * Rescue Protocol has +1 charges at all Gremlin tiers and grants the target +15 Dodge and +5 Mobility
 * Gunslinger's cooldown has been reduced from 4 to 3 and its range from 12 tiles to 8, but it now has 360 degree activation instead of a cone and the shots can crit even without Cool Under Pressure
 * Center Mass now works with sidearms - a different weapon category from "pistols" that the autopistol falls under
 * Death Dealer no longer applies to tick damage like bleeding and poison
 * Field Surgeon no longer applies to bleeding out units, but does now apply to haven advisers
 * Stock Strike now only targets soldiers and does 30% of max HP as armour-piercing damage

## Equipment

Thanks to Iridar for permission to use his sawed-off shotgun model and to InternetExploder for their grenade launcher model!

 * Added tier 3 Combat Knife (Advanced Vibroblade) - requires Andromedon autopsy to unlock it
 * Combat knives now have +35 Aim (from +20) and the stats have been rescaled to account for the extra tier:
   - Combat Knife: 2-4 damage (3 average), 3 crit damage, +35 aim, +20 crit chance
   - Vibroblade: 4-7 damage (5,75 average), 5 crit damage, +35 aim, +25 crit chance
   - Advanced Vibroblade: 6-11 damage (8,5 average), 8 crit damage, +35 aim, +50 crit chance
 * Added tier 3 Sawed-off Shotgun (Beam Shorty) - requires Plasma Rifle research to unlock it and uses the old Mag Shorty model
 * Mag Shorty uses a new model provided by Iridar
 * Sawed-off Shotgun stats rescaled:
   - Sawed-off shotgun: 4-8 damage (6 average), 3 crit damage, +15 crit chance
   - Mag Shorty: 7-13 damage (10 average), 5 crit damage, +15 crit chance
   - Beam Shorty: 10-18 damage (14 average), 7 crit damage, +15 crit chance
 * Added tier 3 Grenade Launcher (Beam Grenade Launcher) - requires both Plasma Rifle and WAR Suit research to unlock it
 * Beam Grenade Launcher has 2 less range than the Advanced, but uses Blaster Launcher targeting
 * EMP grenades and bombs are now guaranteed to disorient mechanical units
 * Bluescreen rounds now have a 50% chance to disorient mechanical units
 * Beam Grenade launcher gains +2 range
 * Higher-tier Technical gauntlets have a higher chance to stun enemies
 * SMGs now have +2 Mobility (down from +3), 3 ammo (up from 2), and have higher close-range Aim bonuses than before
 * The range change for SMGs also applies to Bullpups and Autopistols

## Tactical combat changes

### Experimental overwatch changes

The old LW2 overwatch behaviour meant that overwatch soldiers would often get flanking shots on the enemies. However, it also meant that soldier and the enemy could move just one tile and avoid the overwatch. Not only is this a bit cheesy, but it also makes suppression pretty unreliable.

With this release, you can **opt into** a modified version of WOTC overwatch rules, where any movement into or out of a tile covered by overwatch will proc an overwatch shot. In vanilla WOTC, this makes overwatch quite bad because the shot is typically against a unit in cover, so the target gets the defense bonus on top of the overwatch hit-chance reduction. We are trialling a system that mitigates this major downside by granting overwatch shots a reduction on the target's cover defense bonus (but not intrinsic defense or that granted by abilities).

The upshot of this change is that suppression seems to be more reliable and Covering Fire's value goes up significantly. On the flipside, you no longer get the flanking bonus to crit chance if the enemy starts in cover.

If you'd like to try out the new overwatch behaviour, simply disable the Revert Overwatch Rules mod. That's it. When the game loads up, it will show a dialog saying that the mod is required and is missing, but that's fine. Simply accept or click on "Never show again". LWOTC will work just fine without it, just with the new overwatch behaviour.

### Rebels

 * Chances for a rebel to have a particular loadout rebalanced to:
   - 60% assault rifle
   - 20% SMG
   - 20% shotgun
 * All rebels get +1 HP, +1 Mobility and +5 Aim
 * Rebels can now get Coilguns (requires Plasma Rifle research)
 * Lower-ranked rebels have a higher chance of getting a higher-tier weapons than before
 * All rebels get additional +2 HP if Combat Armor has been researched, and +3 HP on top of that if Powered Armor has been researched (so +5 HP total with both research projects completed)
 * All rebels gain a plasma grenade instead of a basic frag, and a smoke bomb over smoke grenade once Advanced Explosives has been researched
 * Rebels get much better abilities when they rank up
 * You always get the maximum number of rebels as possible on retaliations, i.e. the cap of 6 rebels, or the number of non-Faceless rebels in the haven if that's lower (up from 3-6 randomly)
 * All rebel civilians (unarmed rebels on retaliations that you can't control and need to be rescued) no longer have -20 Defense and they will try to run away from enemy units and take cover 
 * Rebel civilians also get the same bonus HP from armor research as armed rebels

### Will and Tiredness

 * Soldiers now lose 1 point of Will every 3 turns instead of 4, but they will no longer lose Will for taking damage
 * Tired soldiers will lose Will every 2 turns
 * Tired soldiers should no longer panic from units taking damage, being mind controlled, dying, etc.

### Enemies

 * Spectre's Horror no longer causes Will loss and will now panic the target instead of shattering it, but the chance to panic has been slightly increased
 * Decreased Sectopod damage from 9-16 (average 12.5) to 9-13 (average 11) and health decreased from 35/60/80/95 to 35/55/75/90
 * Muton base damage decreased from 7 to 6 and no longer has 1 pierce that Centurions and Elites didn’t have
 * Gatekeeper defense gain from closed state decreased from 25 to 20, and Gateway radius from 10.5 meters to 8, but they shouldn’t Gateway their allies anymore
 * The ADVENT General's damage has gone from 3-5 to 5-8 with +2 crit damage; M2's damage has gone up to 6-10 with +4 crit (we were inadvertently using vanilla Field Commander values, but the new ones are still a bit lower than in Long War 2)
 * Decreased advent Vanguard aim by 5
 * Decreased Spectre weapon damage from 5-8/6-10 (average 6.5 / 8) to 4-7/6-8 (average 5.5/7)
 * Remodeled Priest AI to be less predictable, all Priests gain 10 Psi Offense, and Advanced and Elite Priests lose 10 innate Dodge; Priests will no longer stasis the Lost
 * Purifiers lose their unused grenade, granting them +1 Mobility, and their pistol damage has been decreased from 1-3/3-5/5-7 to 1-3/2-5/4-6, although their pistols still have 2/3/4 crit damage
 * M2 Purifiers gain Phosphorus
 * Spectres, Purifiers and Priests are a bit more common now, making it easier to acquire their corpses
 * Snakes of all types appear less often
 * Codexes appear more frequently in the end game

### Miscellaneous

 * Poison always lasts for two turns now
   - Poison had the chance to disappear almost immediately, making Venom Rounds and Gas Grenades particularly weak
   - Soldiers will now be able to move out of poison clouds without poisoning themselves again, since they will still be poisoned for the turn following the poison being applied
 * Bladestorm can no longer trigger on the owning unit's turn
 * Anything that extends the mission timer (sit reps, map size) will now result in the reinforcements arriving more slowly, with bigger extensions resulting in a greater slowing of RNFs (this should help with large-map Jailbreaks and some Project Miranda missions)
 * The bonus detection radius granted to units on red alert on Legend difficulty is now the same as for Veteran and Commander
 * If a unit has Close Combat Specialist, they now get a blue circle around them with the same radius as CCS itself (similar to the Close Encounters circle)

## Missions

 * Up to 3 captured soldiers can now be rewarded for a single Jailbreak mission, making it easier to retrieve all your soldiers if a lot of them get captured by Chosen
 * Under-infiltrated Supply Raids and Troop Columns now have a sit rep that buffs the stats of the enemy units depending on the infiltration amount:
   - 75%-99% infiltration is Under infiltration (minor)
   - 50%-74% infiltration is Under infiltration (moderate)
   - 25%-49% infiltration is Under infiltration (major)
   - 0%-24% infiltration is Under infiltration (impossible)
   - The buffs apply flat bonuses to Aim and Defense, and a percentage increase to HP, with the values of the buffs increasing with decreasing infiltration
 * Command pods on troop columns and supply raids only ever have 5 units in them (they could have 8 before), and the pods are slightly weaker (this ensures that 100%-infiltrated missions are more appropriate for the alert level)
 * All retaliation missions except intel raid gain +2 alert level; intel raid gains +3
 * Intel Raid objective now has more HP across the board, especially late game
 * Recruit Raid rebels are now armed, and the mission reinforcements are slower
 * Defend (reinforcement-only) Haven retaliation now has a lot more brutal reinforcements, but they start turn 4 (reduced by alert level), up from turn 1
 * Invasion reinforcements now start slightly weaker
 * Redesigned Chosen Avenger Defense with a lot more strong enemies, and blowing destroying gun placements requires setting up X4-like charges rather than shooting them (thanks to RedDobe for the implementation)
 * Rendezvous missions are more difficult, as the effective force level is only 33% less than the global one (down from 50% less) with a -1 adjustment (down from -2)
 * Rendezvous have more varied enemies now, so you can meet aliens on them (Sectoids, Mutons, etc.)
 * Sabotage Transmitter now starts with a 4-turn timer, down from 3

## Campaign/Geoscape Changes

### Covert Actions

Covert actions can once again be ambushed, which has led to some other rebalancing of them.

To begin with, the ambush mission is different from before: you now have 12 hours to send a quick-response squad of 4 soldiers to go and rescue your covert operatives. Your squad starts at one end of the map in the evac zone, while the covert operatives start at the other end. There are (currently) 7-9 enemies in between the two sets of soldiers. Be warned that your covert operatives may activate a pod at the start, so make sure they're kitted out properly!

Other changes include:

 * The first covert action will now have risks enabled on it
 * "Hunt the Chosen" durations have been reduced substantially
 * Failure chances have been reduced a bit across the board
 * You can upgrade the Resistance Ring once to add an engineer slot for a further reduction in covert action durations (if staffed)
   - The old Resistance Ring upgrades are no longer available
   - Engineers reduce duration by 25%, down from 33% (because 2 engineers reduce duration by 50%)
 * Improve Combat Intelligence covert action has been removed
 * Chosen no longer increase the base chance of covert action risks when they reach a certain knowledge level
 * Bradford will hopefully no longer nag you to build the Resistance Ring
 * Intense Training rewards have been rebalanced to match their relative strength in Not Created Equal (except for Hack and Psi Offense)
 * Superior Weapon Upgrade and Superior PCS covert actions can now spawn at the starting influence level, down from Respected, and they can spawn multiple times (they could only spawn once per campaign before)
 * Recruit Scientist and Engineer covert actions now require Respected influence, up from the starting influence level

### Research

 * Some item corpse requirements (and the corresponding research projects) have been changed:
   - Battle Scanner requires a Trooper corpse rather than a Drone
   - Acid grenades require Spectre corpses instead of Archons
   - EMP grenades require Turret wrecks instead of Drones
   - Ionic Ripjack requires Muton corpse rather than Stun Lancer
   - Fusion Ripjack requires Andromedon corpse rather than Archon
   - Talon rounds require Officer corpses rather than Sectoids
 * Mechanized Warfare now costs 50 supplies (from 100) and no longer requires ADVENT Robotics

### UI

 * The dark events screen now has a background, is a bit tidier and shows the Avenger resources properly (supplies, alloys, intel, etc.)
 * The plot type selected for a mission is now displayed in the mission summary panel (where mission expiry is displayed)
 * Enable the `USE_LARGE_INFO_PANEL` config variable in *XComLW_UI.ini* to use a large-text version of the mission information panel
 * Enable the `CENTER_TEXT_IN_LIP` config variable in the same file to switch to centered text rather than the default left aligned
 * The objectives screen (accessible via the Command button on the Avenger) no longer looks terrible, so you can actually read the details of the objectives
 * The Recruit screen now has all the recruits in a scrollable pane, so you'll be able to see all of them when you have more than can fit in one screen
 * Rookie stats will no longer disappear from the Recruit screen as soon as you recruit one of them

### Miscellaneous

 * Starting regions will now have 3-4 links with other regions and you will be much less likely to start in the same small selection of regions each campaign - this makes the start of the campaign noticeably less punishing
 * Shaken now takes 20-24 days to recover from
 * Reaper HQ intel gain increased slightly, from 0-4 every 2 days to 2-4 on Commander and Legend difficulties, from 2-6 to 4-6 on Rookie and from 1-6 to 3-6 on Veteran
 * Soldier haven advisor now gets a big boost to recruiting efficiency when there are fewer than 6 rebels
 * Uncontacted regions now have a slightly higher chance to recruit rebels and a lower chance to gain vigilance
 * When a haven has 6 rebels or fewer, the recruit job has a 100% chance to recruit rebels instead of the normal 67% for rebels and 33% for rookies
 * Missions that will be on large or very large maps will now have a corresponding Large Map or Very Large Map sit rep attached to them
 * Alien rulers will appear significantly more often than before

## Controllers

Contoller integration is steadily getting better, so there is less need for players to switch back to mouse & keyboard. Here are the improvements in this version:

 * If you are using a controller, you will no longer see the Save Squad button and the Squad Container dropdown; consider using the [Squad Management For LWotC](https://steamcommunity.com/sharedfiles/filedetails/?id=2314584410) mod for a better experience
 * Players can now switch input devices from the Options in the main menu (but not from within an active campaign)
 * The dark event lists on the Geoscape are now properly navigable
 * Officer training slots and the officer ability screen now work properly
 * Navigating the promotion screen should be less frustrating, as moving the focus between columns will no longer reset the focus to the first row
 * Highlighted soldier list view items are now more readable with Will values and the AP icon inverting their colours
 * Controller X is now used to open a haven from the resistance management screen
 * Controller X is now used to change the haven adviser in the haven screen, either to open the soldier list to add an adviser or to remove the existing adviser

## Bug fixes

### Strategy

 * Starting global ADVENT strength no longer varies between campaigns
 * Chosen icons are displayed for each
 * Alien Rulers will now appear noticeably more frequently on relevant missions (UFOs, troop columns, HQ assaults, facilities)
 * Infiltrator (officer ability) now correctly applies its bonus to mission infiltration time
 * Researching any basic level grenade Proving Ground project after Advanced Explosives no longer gives you the advanced version of that grenade (for example, you could previously research Advanced Explosives, then the EMP grenades project, which would grant you an EMP *Bomb*)
 * The Shadow Chamber panel updates immediately on boosting the infiltration of a mission

### Tactical

 * Get Up will now always disorient the target as it was supposed to
 * Coup de Grace will now determine the damage bonus based on whichever debuff on the target has the biggest effect (disoriented-only units grant half the normal damage bonus)
 * Fuse and Apotheosis can no longer be used once a unit has no actions available (this prevents the problem with having to manually end the turn when soldiers with these abilities are in the squad)
 * Pods will now activate on shots at them from squadsight range even if those shots miss
 * Faceless and Chryssalids should now appear on missions with the corresponding Infiltrator sit rep
 * Dark event sit reps like Rapid Response should no longer appear on missions that they don't work on (for example, Rapid Response on untimed missions with no reinforcements)
 * Lost should no longer appear on Abandoned City missions that don't support The Lost sit rep (such as troop columns)
 * M3 Gunners can now make use of their Traverse Fire ability
 * Najas will now favour moving as far away as possible from XCOM to the edge of vision
 * Infighter no longer procs at 2 tiles higher range than intended
 * Psi operatives should no longer get Soul Steal twice as a training option (works around a bug in vanilla game)
 * Fixed the camera focusing on Sectoid Commanders 3 turns after their death
 * WOTC enemies now properly get War Cry bonuses and their corpses are now correctly destroyed when the unit is killed by explosives
 * Biggest Booms no longer bypasses Fortress/Bastion

## Modding

 * We've added a new `CLASSES_INELIGIBLE_FOR_MISSION_XP` config array in *XComLW_Overhaul.ini* that allows you to specify a list of soldier classes that won't share in the mission XP at the end of the mission (useful for "soldier classes" that don't rank up, like SHIVs)
 * A new `CLASSES_INELIGIBLE_FOR_OFFICER_TRAINING` config array in *XComLW_OfficerPack.ini* allows mods to prevent certain soldier classes from training as officers
 * A new `UNMODIFIABLE_SLOTS_WHILE_ON_MISSION` config array in *XComLW_Overhaul.ini* allows mods to configure additional slots that can't be edited in the loadout screen while a unit is on a mission
 * A new `QUICKBURN_ABILITIES` config array in *XComLW_SoldiersSkills.ini* allows mods to configure additional abilities that are affected by Quickburn
 * A new `PISTOL_SLOT_WEAPON_CATS` config array in *XComLW_Overhaul.ini* allows mods to configure which weapon categories are allowed in the pistol slot

# Credits and Acknowledgements

[TBD]

A big thanks to the following:

* The Community Highlander team, as we rely heavily on its bug fixes and modding features
* The various folks that have been submitting pull requests
* The people that have provided translations for LWOTC:
  - Italian: SilentSlave
  - Russian: FlashVanMaster and Roman-Sch
  - French: Savancosinus
* The folks on XCOM 2 Modders Discord, who have been incredibly helpful at all stages of this project
* All the folks that have been testing the development builds and providing feedback and issue reports

We hope you enjoy the mod, and good luck commanders!
