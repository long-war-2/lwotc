# Long War of the Chosen Rebalanced (LWOTC-R)

This is a Fundamental Rebalance of Long War Of the Chosen, with the following design goals:

1.  Significantly lower the reliance on alpha striking (more 3-4 + turn engagements than 1-2 turn ones)
2.  Eliminate the need to manage pod activations
3.  A wide variety of distinct tools for the player, and a wide range of distinct challenges to deal with, such as:
- Much more distinct enemy design
- Significantly more nuanced perk trees and equipment 
4. More even pacing and difficulty of the campaign
5. Repurpose stealth from an ambush and combat avoidance tool to a scouting and defensive one.


## Current State
Currently the Mod is in alpha, in a playable but feature incomplete and unpolished state.

Particularly, the not-implemented features (In this case: Not rebalanced/redesigned yet) so far include:
Psi ops
Sparks
Alien Hunters DLC
The Chosen

## Features

Here's a headline list of features of this mod

### Podless
* As soon as you are spotted, every enemy in the map activates. Enemy count, XCOM HP, and defensive tools are redesigned with that in mind.

### Revamped concealment
* With some exceptions, shared concealment now breaks at the start of the 2nd turn.

* Phantom is reworked to temporarily concealing yourself as a free action for 1 turn. (with 3 charges)

* Enemy Detection ranges are severely decreased

* Shadow is keeping its LWOTC Variant

### Grenade Scatter

* Grenades are overall more powerful, but also more unreliable, and can now scatter just like rockets.
* Damage falloff is also quite a bit harsher

### Cover
* Cover Defense is further increased to 40/55 from 30/45 - significantly raising the value of cover
* Base Flanking crit bonus increased to 50% from 40%

### Ammo management
* Reloads are now turn ending
* Pistols and autopistols no longer carry any mobility penalty
* Sawed-off can now be equipped in a pistol slot 

### Attachments
* Attachments now only have 1 tier, and are infinite items available as soon as you get modular weapons
* All weapons now start with only 1 attachment slot, and can gain 2 more slots by researching proving ground projects

Attachments have been rebalanced to:
* SCOPE - Gain 5 aim
* Laser sight - Gain 10 crit

* Hair trigger - After a miss, gain +25 aim
* Stock - Missed attacks have a 50% chance to become a graze. Your attacks ignore up to 15 dodge

* Expended magazine - Gain +1 weapon capacity
* Auto-loader - Grants quick reload - Reload up to 2 ammo, non-turn ending

### Overwatch and suppression
Overwatch has been overhauled:

* Overwatch is now: Fire on the first enemy within line of sight of this soldier (at the time of activating Overwatch) that moves. No aim penalty and ignores cover defense. A unit can only go on overwatch if it has an enemy in line of sight
* Overwatch is no longer removed upon taking damage

Similar to LWR overwatch rules, except it doesn't have covering fire by default. This is an important mechanic change because:
* Makes sure not every mission is a spawn defense with podless
* Makes reinforcements (RNF) something that you will have to deal with instead of just blowing up instantly
* Makes overwatch strong without needing multiple overwatch perks beforehand

* Suppression is now: Fire a barrage that pins down a target, reducing their action points by 1 (units unable to take cover are immune), restricting the use of many abilities, and imposing a 15 penalty to the target's aim. Grants an  overwatch shot that deals half damage if the target moves.

These changes make suppression far more effective at locking down units, and far less effective at killing them.

### Soldiers

* All soldiers now start as squaddies - Eliminates the boring rookie phase where your toolset was severely limited

* All soldier trees have been redesigned to have their role defining tools/power spikes happen earlier in the tree than later - Makes the builds go online a lot sooner, and decreases the impact of losing higher ranked soldiers, and increases the ability to more easily replace them

* Soldier base stats have been rescaled like this:
8 base HP
80 base aim
16 base mobility
40 base will

* Soldier HP, Aim and Will growths have been completely removed - Makes sure cover is just as important early game as it is late

* All soldier classes (except templars) now have access to the following "Universal" primary weapon categories: Assault rifle, Shotgun, SMG, Bullpup, Vektor, Grenade launcher

##### Classes

* The Ranger and Grenadier classes have been removed - their "niches" have been incorporated into the builds of other classes,
sawed-offs are now universal sidearm slot weapons, grenade launchers are now universal primary weapons.

###### Gunner Class
* New Squaddie set of perks - Suppression, flush, bladestorm knife fighter

###### Technical Class
* No longer has gauntlet, instead the technical has a rocket launcher secondary weapon, and is the only class that can equip a primary flamethrower called an immolator

* Can Equip several new rocket types, detailed in the weapons section
* Immolator allows to equip special canisters in the sidearm slot, detailed in the weapons section


###### Shinobi Class
* New Squaddie set of perks - Phantom, Slash, Whirlwind
* Phantom has been reworked to: Temporarily conceal yourself for 1 turn with no detection radius. Standard Slash attack does not reveal you. 3 charges
* Gets +1 mobility at squaddie

###### Assault Class
* New Squaddie set of perks - Close encounters, Arc thrower stun
* Gets +1 mobility at squaddie


###### Sharpshooter Class
* Same Squaddie set of perks - Squadsight, Holotarget, except:
* Holotargeting is now a free action, on a 3 turn cooldown


###### Specialist Class
* New Squaddie set of perks - Aid Protocol, Blinding Protocol, Combat Protocol

You can find new class trees [here.](https://docs.google.com/spreadsheets/d/1Sdk8q8FWuxaaPSpgdK1BOIwQZYgUXXFv/edit?usp=sharing&ouid=101693235569137515434&rtpof=true&sd=true)

### Enemies

* Enemy Aim and Will growths have been completely removed - Makes sure cover is just as important early game as it is late
* Rescaled all enemies across 5 tiers, scaled from FL 1 to FL 25
* New tier naming is : Basic, Advanced, Elite, Supreme, With T5 enemies having special names
* Incorporated over 100 new permament dark events as new and unpredictable enemy scaling
* Removed Najas - squadsight doesn't fit that well in podless
* Removed MEC Archers - squadsight doesn't fit and they weren't an interesting enough enemy
* Removed ADVENT grenadiers, rocketeers, scouts, sergeants, commandos, vanguards and shock troopers - Their variants have been incorporated elsewhere

More detailed enemy changes can be found here, I'll just present some more important changes here
#### Troopers
* Gains Marauder (standard shots are no longer turn ending)

#### Officers
* Gains Defilade (All allies in sight of the officer gain 30 crit resistance)
* Mark target is now a free action

#### Sectoids
* Reworked Mind Spin: Is now a free action, Cannot mind control by default, but will always mind control targets that are disoriented, stunned, or panicked
* Reduced Psi Offense by a lot so mindspin can now fail sometimes
* Sectoid Commanders lose Mass Mindspin because it wasn't very effective/working correctly.

#### Drones
* Repair is now a free action
* Stunner to 3 actions from 4

#### Stun lancers
* Stun Lance is no longer a dash attack, deals a lot more damage, and will now always stun for 1 action (instead of a random effect including unconscious)
* Gains Whirlwind
* Gains Flashbangs

#### Priests
* No longer have Mind Control by default

#### Sidewinders
* Have Hit and Slither by default

#### Mutons
* Gains Will to Survive

#### Mecs
* Gains Damage Control by default

#### Spectres
* Shadowbind is no longer a dash move

#### Codex
* Gains Evasive

#### Andromedons
* Primary Weapon now has short range
* Acid Blob cooldown to 1, but it has severely reduced radius and can now scatter

#### Sectopods
* Significantly less initial armor and HP
* Gains Protective Servos - gain stackable 2 armor for each damage you take this turn
* It can wrath cannon only as a last action, and will always wrath cannon as a last action
* Wrath Cannon cooldown to 1, and damage to 20

#### Gatekeeper
* Significantly Less initial armor and HP
* Will no longer attack allies for no reason

#### Archons
* Gains a lot more defense and dodge
* Has Close Combat Specialist by default




### PRIMARY WEAPONS

* Tweaked Weapon Damage Scaling:

Base Damage is 4/5/6/7/8 depending on weapon tier (from 4/5.5/7/8.5/10)

* Significantly decreased the amount of shred in the game - makes armor actually important
* Rebalanced Primary weapons the following way

#### AR
* 100% weapon damage
* 4 ammo capacity
* Medium range

#### SMG
* 75% base damage
* 30 base crit
* 3 ammo capacity
* 100% crit damage (from 50)
* +1 mobility
* MidShort Range

#### Bullpup
* 100% base damage
* 15 base aim
* 3 ammo capacity
* -50 base crit
* +1 mobility
* MidShort Range

#### Strike Rifle (Vektor)
* 100% base damage
* 5 base aim
* 3 ammo capacity
* 30 base crit
* Mid long range
* no more bonus crit damage

#### Shotgun
* 125% base damae
* 0 base crit
* 4 ammo capacity
* Short Range

#### Sniper Rifle
* 125% base damage
* 20 base aim
* 30 base crit
* 3 ammo capacity
* Long Range

#### Cannon
* 150% base damage
* -15 base aim
* -1 mobility
* 6 ammo capacity
* mid long range


#### Immolator (technical only)
* Primary Flamethrower, uses lw2 targeting
* -1 mobility
* 75% base damage, has 100% chance to set someone on fire
* 7 tile long, 5 tile wide
* infinite ammo, but 2 only ammo capacity, in addition flamethrower has 2 turns cooldown.
* T0 is availible at game start
* T1 Is unlocked with purifier autopsy
* T2 is unlocked with Berserker autopsy
* T3 is unlocked with Sectopod autopsy
* Allows to equip canisters in the pistol slot

* Immolator Attachments:

Wide Angle Nozzle - +2 cone width

High Velocity Nozzle - +1 cone length

Expanded Fuel Tank - +2 ammo capacity

Heat Resistant Tank - -2 cooldown on flamethrower

Fuel Line - +1 canister charge

Light Frame - reduced infiltration time

Outrider Frame - +1 weapon mobility, at the cost of -35% weapon damage

#### Blast canister:
* 150% base weapon damage, very short range, knocks enemies back
* Available instantly

#### Smoke canister
* 0% weapon damage, smoke, wide radius
* available instantly

#### Gas Canister:
* 50% weapon damage, longer range, inflicts poison
* unlocked with Viper autopsy

#### Acid Canister:
* 50% weapon damage, inflicts acid
* unlocked with Spectre autopsy

#### Bluescreen Canister
* 150% weapon damage, armor piercing, stuns for 1 action and only affects mechanicals
* unlocked with Bluescreen Protocol


#### Medical canister
* 0% weapon damage, smoke, +2 weapon range, regeneration
* unlocked with Chryssalid autopsy


#### GRENADE LAUNCHER
* +3/4/4 grenade throw range depending on tier
* +15 grenade accuracy
* Plasma grenade launcher grants blaster launcher targeting

### Secondary weapons
* Sword
* 175% base weapon damage
* 40 aim

#### Arc thrower
* Arc thrower is no longer turn ending by default, Has the electroshock effect by default
* Advanced arc thrower grants 10 aim 
* Superior arc thrower grants +1 stun action 

#### Holotargeter
* Holotargeting aim stays at 15
* Holotargeting is now a free action with a 3 turn cooldown
* Rapid targeting reduces the cooldown of holo by 1

* Advanced holotargeter grants hidef holo
* Elite holotargeter grants Vital point targeting

#### Knife:
* 100% weapon damage
* 35 aim
* 20 crit

#### Rocket launcher (technical)
* Has 2 standard rockets by default
* Firing a rocket has a 3 turn cooldown

Rocket types:
#### Standard:
* 125% weapon damage
* 5 radius
* 0 shred
* 0 pierce

#### Shredder
* 150% weapon damage
* 3 radius
* 1/2/3 shred
* 2/3/4 pierce

#### lockon
* 200% weapon damage
* single target
* 4/6 pierce
* can only be fired at holo’d targets

#### flechette
* 175% weapon damage
* 6 radius
* Damage is reduced a lot against cover and armor

#### Concussion:
* 50% weapon damage
* 5 radius
* Can Disorient And stun

#### Plasma Ejector:
* 150% weapon damage in a line - replaces plasma blaster

### Sidearms

#### Pistol
* 75% base damage
* infinite ammo capacity
* midshort range

#### Autopistol
* 75% base damage
* 50 base crit
* ignores up to 30 dodge
* short range

#### Sawed off 
* 125% base damage
* sawed-off range
* does not work with any of the pistol skills
* 2 Ammo, after that can be reloaded
* doesn't have both barrels anymore

### Grenades

#### Frag Grenade
* 4-6 weapon damage
* 4 radius
* 0 shred

#### Magnetic Grenade
* New Tier 2 Frag grenade upgrade
* 6-9 damage
* 4 radius
* 0 shred

#### Plasma Grenade
* Now acts as a tier 3 grenade
* 8-12 damage
* 4 radius
* 0 shred


### Weapon Ranges

Here are new Weapon Ranges:
```
LMG_ALL_RANGE[0] = -15
LMG_ALL_RANGE[1] = -15
LMG_ALL_RANGE[2] = -10
LMG_ALL_RANGE[3] = -5
LMG_ALL_RANGE[4] = 0
LMG_ALL_RANGE[5] = 4
LMG_ALL_RANGE[6] = 6
LMG_ALL_RANGE[7] = 8
LMG_ALL_RANGE[8] = 9
LMG_ALL_RANGE[9] = 10
LMG_ALL_RANGE[10] = 9
LMG_ALL_RANGE[11] = 8
LMG_ALL_RANGE[12] = 7
LMG_ALL_RANGE[13] = 6
LMG_ALL_RANGE[14] = 5
LMG_ALL_RANGE[15] = 4
LMG_ALL_RANGE[16] = 3
LMG_ALL_RANGE[17] = 2
LMG_ALL_RANGE[18] = 1
LMG_ALL_RANGE[19] = 0
LMG_ALL_RANGE[20] = -4
LMG_ALL_RANGE[21] = -8
LMG_ALL_RANGE[22] = -12
LMG_ALL_RANGE[23] = -16
LMG_ALL_RANGE[24] = -20
LMG_ALL_RANGE[25] = -24
LMG_ALL_RANGE[26] = -100

MID_LONG_ALL_RANGE[0] = -30
MID_LONG_ALL_RANGE[1] = -30
MID_LONG_ALL_RANGE[2] = -27
MID_LONG_ALL_RANGE[3] = -24
MID_LONG_ALL_RANGE[4] = -21
MID_LONG_ALL_RANGE[5] = -18
MID_LONG_ALL_RANGE[6] = -15
MID_LONG_ALL_RANGE[7] = -12
MID_LONG_ALL_RANGE[8] = -9
MID_LONG_ALL_RANGE[9] = -6
MID_LONG_ALL_RANGE[10] = -3
MID_LONG_ALL_RANGE[11] = 0
MID_LONG_ALL_RANGE[12] = 0
MID_LONG_ALL_RANGE[13] = 0
MID_LONG_ALL_RANGE[14] = 0
MID_LONG_ALL_RANGE[15] = 0
MID_LONG_ALL_RANGE[16] = 0
MID_LONG_ALL_RANGE[17] = 0
MID_LONG_ALL_RANGE[18] = 0
MID_LONG_ALL_RANGE[19] = 0
MID_LONG_ALL_RANGE[20] = -3
MID_LONG_ALL_RANGE[21] = -6
MID_LONG_ALL_RANGE[22] = -9
MID_LONG_ALL_RANGE[23] = -12
MID_LONG_ALL_RANGE[24] = -15
MID_LONG_ALL_RANGE[25] = -18
MID_LONG_ALL_RANGE[26] = -21
MID_LONG_ALL_RANGE[27] = -24
MID_LONG_ALL_RANGE[28] = -27
MID_LONG_ALL_RANGE[29] = -30
MID_LONG_ALL_RANGE[30] = -33
MID_LONG_ALL_RANGE[31] = -36
MID_LONG_ALL_RANGE[32] = -39
MID_LONG_ALL_RANGE[33] = -42
MID_LONG_ALL_RANGE[34] = -45
MID_LONG_ALL_RANGE[35] = -48
MID_LONG_ALL_RANGE[36] = -51
MID_LONG_ALL_RANGE[37] = -54
MID_LONG_ALL_RANGE[38] = -57
MID_LONG_ALL_RANGE[39] = -60
MID_LONG_ALL_RANGE[40] = -80
 
 
MEDIUM_ALL_RANGE[0] = 30
MEDIUM_ALL_RANGE[1] = 30
MEDIUM_ALL_RANGE[2] = 27
MEDIUM_ALL_RANGE[3] = 24
MEDIUM_ALL_RANGE[4] = 21
MEDIUM_ALL_RANGE[5] = 18
MEDIUM_ALL_RANGE[6] = 15
MEDIUM_ALL_RANGE[7] = 12
MEDIUM_ALL_RANGE[8] = 11
MEDIUM_ALL_RANGE[9] = 10
MEDIUM_ALL_RANGE[10] = 9
MEDIUM_ALL_RANGE[11] = 8
MEDIUM_ALL_RANGE[12] = 7
MEDIUM_ALL_RANGE[13] = 6
MEDIUM_ALL_RANGE[14] = 5
MEDIUM_ALL_RANGE[15] = 4
MEDIUM_ALL_RANGE[16] = 3
MEDIUM_ALL_RANGE[17] = 2
MEDIUM_ALL_RANGE[18] = 1
MEDIUM_ALL_RANGE[19] = 0
MEDIUM_ALL_RANGE[20] = -5
MEDIUM_ALL_RANGE[21] = -10
MEDIUM_ALL_RANGE[22] = -15
MEDIUM_ALL_RANGE[23] = -20
MEDIUM_ALL_RANGE[24] = -25
MEDIUM_ALL_RANGE[25] = -100

SAWED_OFF_RANGE[0]=60
SAWED_OFF_RANGE[1]=60
SAWED_OFF_RANGE[2]=20
SAWED_OFF_RANGE[3]=0
SAWED_OFF_RANGE[4]=-30
SAWED_OFF_RANGE[5]=-60
SAWED_OFF_RANGE[6]=-90
SAWED_OFF_RANGE[7]=-100

MIDSHORT_ALL_RANGE[0] = 45
MIDSHORT_ALL_RANGE[1] = 45
MIDSHORT_ALL_RANGE[2] = 35
MIDSHORT_ALL_RANGE[3] = 25
MIDSHORT_ALL_RANGE[4] = 15
MIDSHORT_ALL_RANGE[5] = 10
MIDSHORT_ALL_RANGE[6] = 7
MIDSHORT_ALL_RANGE[7] = 3
MIDSHORT_ALL_RANGE[8] = 0
MIDSHORT_ALL_RANGE[9] = 0
MIDSHORT_ALL_RANGE[10] = 0
MIDSHORT_ALL_RANGE[11] = 0
MIDSHORT_ALL_RANGE[12] = -3
MIDSHORT_ALL_RANGE[13] = -6
MIDSHORT_ALL_RANGE[14] = -9
MIDSHORT_ALL_RANGE[15] = -12
MIDSHORT_ALL_RANGE[16] = -16
MIDSHORT_ALL_RANGE[17] = -19
MIDSHORT_ALL_RANGE[18] = -22
MIDSHORT_ALL_RANGE[19] = -30
MIDSHORT_ALL_RANGE[20] = -45
MIDSHORT_ALL_RANGE[21] = -60
MIDSHORT_ALL_RANGE[22] = -75
MIDSHORT_ALL_RANGE[23] = -90
MIDSHORT_ALL_RANGE[24] = -100
MIDSHORT_ALL_RANGE[25] = -100

SHORT_ALL_RANGE[0] = 60
SHORT_ALL_RANGE[1] = 60
SHORT_ALL_RANGE[2] = 45
SHORT_ALL_RANGE[3] = 30
SHORT_ALL_RANGE[4] = 15
SHORT_ALL_RANGE[5] = 8
SHORT_ALL_RANGE[6] = 4
SHORT_ALL_RANGE[7] = 0
SHORT_ALL_RANGE[8] = 0
SHORT_ALL_RANGE[9] = -4
SHORT_ALL_RANGE[10] = -8
SHORT_ALL_RANGE[11] = -16
SHORT_ALL_RANGE[12] = -32
SHORT_ALL_RANGE[13] = -40
SHORT_ALL_RANGE[14] = -48
SHORT_ALL_RANGE[15] = -60
SHORT_ALL_RANGE[16] = -70
SHORT_ALL_RANGE[17] = -80
SHORT_ALL_RANGE[18] = -90
SHORT_ALL_RANGE[19] = -100
SHORT_ALL_RANGE[20] = -100
SHORT_ALL_RANGE[21] = -100
SHORT_ALL_RANGE[22] = -100
SHORT_ALL_RANGE[23] = -100
SHORT_ALL_RANGE[24] = -100
SHORT_ALL_RANGE[25] = -100
 
LONG_ALL_RANGE[0] = -40
LONG_ALL_RANGE[1] = -40
LONG_ALL_RANGE[2] = -36
LONG_ALL_RANGE[3] = -32
LONG_ALL_RANGE[4] = -28
LONG_ALL_RANGE[5] = -24
LONG_ALL_RANGE[6] = -20
LONG_ALL_RANGE[7] = -16
LONG_ALL_RANGE[8] = -12
LONG_ALL_RANGE[9] = -8
LONG_ALL_RANGE[10] = -4
LONG_ALL_RANGE[11] = 0
LONG_ALL_RANGE[12] = 0
LONG_ALL_RANGE[13] = 0
LONG_ALL_RANGE[14] = 0
LONG_ALL_RANGE[15] = 0
LONG_ALL_RANGE[16] = 0
LONG_ALL_RANGE[17] = 0
LONG_ALL_RANGE[18] = 0
LONG_ALL_RANGE[19] = 0
LONG_ALL_RANGE[20] = -2
LONG_ALL_RANGE[21] = -4
LONG_ALL_RANGE[22] = -6
LONG_ALL_RANGE[23] = -8
LONG_ALL_RANGE[24] = -10
LONG_ALL_RANGE[25] = -12
LONG_ALL_RANGE[26] = -14
LONG_ALL_RANGE[27] = -16
LONG_ALL_RANGE[28] = -18
LONG_ALL_RANGE[29] = -20
LONG_ALL_RANGE[30] = -22
LONG_ALL_RANGE[31] = -24
LONG_ALL_RANGE[32] = -26
LONG_ALL_RANGE[33] = -28
LONG_ALL_RANGE[34] = -30
LONG_ALL_RANGE[35] = -32
LONG_ALL_RANGE[36] = -34
LONG_ALL_RANGE[37] = -36
LONG_ALL_RANGE[38] = -38
LONG_ALL_RANGE[39] = -40
LONG_ALL_RANGE[40] = -42
LONG_ALL_RANGE[41] = -44
```
* Notice mid range being much better at longer ranges, and midlong and long ranges having very harsh close range penalties


### Armor

* Removed all ablative plating equipment from the game. Instead armor gives plating and there are PG projects to further increase plating

#### Kevlar

##### Light Kevlar

* 0 hp, 0 ablative, 2 mobility

##### Kevlar:

* 0 hp, 3 ablative, 0 mobility

#### Plated:

##### Spider suit

* 2 hp, 1 ablative, 2 mobility, grapple

##### Predator armor

* 3 HP, 1 armor, 4 ablative

##### EXO

* 3 HP, 1 armor, 4 ablative,
* No longer grants a heavy weapon slot
* Exoskeleton Servos: This Unit's mobility cannot go below 14
* -1 Equipment Slot

#### Powered

##### Wraith suit

* 6 hp, 2 ablative, 2 mobility, grapple, wraith properties


##### Warden armor:

* 8hp, 2 armor, 5 ablative

##### WAR Suit

* 8hp, 2 armor, 5 ablative,

* Exoskeleton Servos: This Unit's mobility cannot go below 14

* -1 equipment slot

* ShieldWall



### DOT EFFECTS CHANGES

* Disorient: more or less the same, slighty lower aim penalty and no longer kills zombies 

* Poison: does not block any abilities, but has much more severe stat penalties than disorient and deals damage 

* Burn now blocks only standard shot, overwatch, and throw/launch grenade, everything else works

* Acid burn: One of the few sources of shred, the game is getting changed so armor is overall rarer but shred is much, MUCH less common and harder to do 

### Barracks

* Rookie promotion now happens on the basis of super classes: there are 3

Assault - Specialist

Sharpshooter - Shinobi

Gunner - Technical

* Reduced the amount of starting soldiers to 16 from 22 - compensates for the average soldier being far more useful, reduces overall mission density and soldier management, makes recruiting worth more


* All Soldiers Autopromote every 24 hours to squaddies

* Removed GTS train rookies slots (not needed anymore)
* Introduced Xcom Training Program Unlocks:

XTP1: All Soldiers Autopromote to Lance Corporals (unlocked with first lieutenant)

XTP2: All Soldiers Autopromote to Corporals (unlocked with Major)

XTP3: All Soldiers Autopromote to Sergeants (unlocked with Colotel)

XTP4: All Soldiers Autopromote to Staff Sergeants (unlocked with Field Commander)


* Most GTS Unlocks have been moved to proving ground projects

Vengeance: Unlocked with Trooper autopsy

Wet Work: Unlocked with Sectoid autopsy

Integrated warfare: Unlocked with Priest Autopsy

Lightning Strike: Unlocked with Spectre Autopsy

Stay with me: Unlocked with Chryssalid Autopsy

Vulture: Unlocked with Alien Encryption research

### Officers
* Air Controller skyranger turn reduction to 1 from 2
* New ability: Fall Back (Give a free but uncontrolled action to a unit that has spent their action points that causes it to retreat)
* New ability: Resupply - make all allies within command range that have spent their action points reload.

#### NEW OFFICER TREE
* Oscar mike vs Focus fire
* Incoming vs Get Some
* Air Controller vs Jammer
* Fall Back vs Collector
* Fire Discipline vs Defilade
* Resupply vs Scavenger
* Combined Arms vs Infiltrator

## Acknowledgements and Credits

### LWOTC Credits:

 * Track Two, who has provided a huge amount of advice and insight that saved me lots of time
   and ensured certain bugs got fixed at all.
 * The folks behind X2WOTCCommunityHighlander.
 * All the folks in XCOM 2 modders' Discord who have answered my questions.
 * All the authors of the mods that are integrated into this port:
   - robojumper's Squad Select
   - Detailed Soldier List
 * The Long War 2 team for producing the mod in the first place!

 * Peter and Grobo as Main devs
 * Iridar for permission to use his [More Psi Abilities](https://steamcommunity.com/sharedfiles/filedetails/?id=2245270253), [One Handed Templar](https://steamcommunity.com/sharedfiles/filedetails/?id=1593890402), and sawn-off shotgun (from [LW2 Secondary Weapons](https://steamcommunity.com/workshop/filedetails/?id=1140434643))
 * Musashi for permission to use his [Ballistic Shields](https://steamcommunity.com/sharedfiles/filedetails/?id=1416242202) and throwing knives (from [WotC Combat Knives](https://steamcommunity.com/sharedfiles/filedetails/?id=1135248412)).
 * InternetExploder for permission to use their [Beam Grenade Launcher](https://steamcommunity.com/sharedfiles/filedetails/?id=1181681128)
 * Favid for permission to use abilities from the [[WOTC] Shadow Ops Perk Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1519841231) and their [[WOTC] Extended Perk Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1546482849)
 * Shiremct for permission to use abilities from [[WOTC] Proficiency Class Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1265143828)
 * bstar for permission to use abilities from [their perk pack](https://steamcommunity.com/sharedfiles/filedetails/?id=2115077818)
 * The Community Highlander team, as we rely heavily on its bug fixes and modding features
 * The various folks that have been submitting pull requests
 * The people that have provided translations for LWOTC:
   - Italian: SilentSlave
   - Russian: FlashVanMaster
   - French: Savancosinus
 * The folks on XCOM 2 Modders Discord, who have been incredibly helpful at all stages of this project
 * All the folks that have been testing the development builds and providing feedback and issue reports


### LWOTC-R specific Credits:

* Iridar for his [Rocket Launchers](https://steamcommunity.com/sharedfiles/filedetails/?id=1775963384&searchtext=rocket+launcher)
* Iridar and claus for [Immolator Models](https://steamcommunity.com/sharedfiles/filedetails/?id=2237137501&searchtext=immolator+overhaul)
* Mitzuri for [Immolator code/Canisters](https://steamcommunity.com/sharedfiles/filedetails/?id=1918448514&searchtext=immolator+overhaul)
* Mitzuri for [Chaining Jolt Code](https://steamcommunity.com/sharedfiles/filedetails/?id=1561030099&searchtext=perk+pack)
* NeIVIeSiS for various 2D icons (Like the light kevlar one)
* Iridar for [Grenade scatter mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2025928724&searchtext=grenade+scatter)
* Claus for [Magnetic Grenade](https://steamcommunity.com/sharedfiles/filedetails/?id=2552974509&searchtext=assault)
* Grimy for [Primary nade launcher](https://steamcommunity.com/sharedfiles/filedetails/?id=1673431726&searchtext=grenade+launcher)
* Hnefi for [Some of the podless code](https://steamcommunity.com/sharedfiles/filedetails/?id=1302278158&searchtext=podless+wotc)
* Xylth for [Rookie's choice GTS code](https://steamcommunity.com/sharedfiles/filedetails/?id=1302278158&searchtext=podless+wotc)

#### Ability Changelog
The actual list is too long, but here are the few important ones
* Will To survive Decreases defense by 15, Grants 2 ablative hp, 35% cover damage reduction, and 20% wound time reduction
* Serial and reaper are now passives
* Lethal is now 30% damage, and also applies to grenades
* Chain lightning now replaces normal arc thrower shots, chained attacks disorient rather than stun, and only hits up to 3 targets
* Fleche no longer grants any bonus damage, and has a 3 turn cooldown
* Sentinel, Guardian and RR can now work against the same target

### New Abilities

Similarly, only the important ones

* Bullet Wizard: Grants Area suppression. Suppression and Area suppression deal small amount of damage to the targets.
* Merciless: Once per turn, taking a standard shot with your primary weapon on a disoriented, panicked, or stunned enemy will refund your actions.
* Impact: Your Attacks can now remove enemy overwatch on hit.
* Advanced Robotics: Upgrades ABC protocols by granting Threat Assessment, Shock Therapy and Chaining Jolt.

Threat assessment makes Aid protocol target go on overwatch

Shock therapy makes Blinding protocol have a 50% chance to stun the targets.

Chaining Jolt causes combat protocol to jump to up to 3 additional targets.

## Installing and playing the mod

Installing the mod works exactly the same as normal lwotc, except you download it from here. You can find general instructions on LWOTC's [wiki page.](https://github.com/long-war-2/lwotc/wiki/Installing-Long-War-of-the-Chosen)

You can grab a release from either the discord sercver, or release section in this repository (experimental ones get posted on discord, more stable ones here)

If you have some kind of trouble or Want to give feedback you can join [LWOTC-R discord server](https://discord.gg/bNcp2V79FG), Or raise an issue in github
## Contributing translations

If you would like to contribute to translations for LWOTC, then check out the
[wiki page](https://github.com/long-war-2/lwotc/wiki/Contributing#localization-translating-text-in-the-game)
that explains how it works.

## Building and running the mod

If you want to contribute changes to code or assets, then you will need to
build the mod so that you can test them. Before you can do that, you need to
set some things up:

 1. Make sure you have the WOTC SDK `full_content` branch installed - see the
    [xcom2mods wiki](https://www.reddit.com/r/xcom2mods/wiki/index#wiki_setting_up_tools_for_modding)
    for details on how to do that (plus lots of other useful information)

 2. [Fork this repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
    and then clone your fork locally, which you can do via [Git for Windows](https://gitforwindows.org/)
    (a command-line tool), [GitHub Desktop](https://desktop.github.com/), or some other
    git client tool

 3. Once you have cloned the repository, you may need to pull the code for the embedded
    highlander. If the *X2WOTCCommunityHighlander* directory is empty, then use the
    command line from the project's root directory (the one containing this README.md):
    ```
        > git submodule update --init
    ```
    or whatever is the equivalent with the git client tool you are using.

 4. Download the LWOTC media assets (video, graphics and sound) from
    [this Dropbox link](https://www.dropbox.com/s/209rybpdl3khb26/lwotc-content.zip?dl=0)
    and unpack the resulting zip file into this project's *LongWarOfTheChosen* directory.

 5. Set up the following environment variables:
    * `XCOM2SDKPATH` — typically &lt;path to Steam&gt;\steamapps\common\XCOM 2 War Of The Chosen SDK
    * `XCOM2GAMEPATH` — typically &lt;path to Steam&gt;\steamapps\common\XCOM 2\XCom2-WarOfTheChosen
    Don't put these paths in quotes.
	
 6. Open a new command prompt after setting those environment variables and run
    the following from the LWOTC project directory:
    ```
    > build-lwotc.bat -config default
    ```
    (You can specify `-config debug` to compile with debug info)
 
 7. You should also build the Community Highlander, which you can do by opening
    the solution file in X2WOTCCommunityHighlander in Mod Buddy and using that
    to build the project, or you can open the LWOTC project directory in VS Code
    and use the "Terminal > Run Task..." menu option and select "Build CHL
    (final release)" and then "Build DLC2 CHL" once the previous task has finished.

Once the highlander and LWOTC are built, you will be able to select them as local
mods in Alternative Mod Launcher and run Long War of the Chosen.

## Contributing

Contributions are welcome. If you just want to raise issues, please do so [on GitHub](https://github.com/long-war-2/lwotc/issues),
preferably including a save file if possible.

If you wish to contribute to development — and this project will rely heavily on such contributions — then please
look through the issues and if you want tackle one, just leave a comment along the lines of "I'll take this one".
If you find you can't complete the issue in a reasonable time, please add another comment that says you're relinquishing
the issue.

All contributions are welcome, but bug fixes are _extremely_ welcome!

