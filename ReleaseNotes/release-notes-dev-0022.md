Welcome to **dev build 22** of Long War of the Chosen!

This is intended to be the precursor build to beta 4, with some notable balance changes that need testing. The big changes include:

 * A slightly reworked Reaper tree to make it more suitable for the new Shadow and to generally buff the unit
 * The Assassin is now more dangerous and acts more like a juggernaut (she won't often run away)
 * More common Alien Ruler encounters (a *lot* more common)
 * Underinfiltrated supply raids and troop columns now buff the enemies on the map rather than having a very difficult command pod (actually added in 21.3 but not explained well)
 * Covert action ambushes are back and the "wounded" risk has gone
 * Poison now lasts a fixed 2 turns, rather than potentially disappearing almost as soon as it's applied
 * Chosen correctly appear on the missions they're supposed to (and don't appear on ones they shouldn't)
 * Jailbreaks can have multiple captured XCOM soldiers (up to 3) as rewards
 * Chosen gain knowledge a lot more slowly than before from Retribution, and a little more slowly from captures

**Important** If you want to upgrade mid campaign and want to test the Reaper tree changes, be sure to use the `RespecSelectedSoldier` console command, although be aware that this will change the XCOM-row abilities too.

To install dev build 22, just delete your existing LongWarOfTheChosen and X2WOTCCommunityHighlander folders from the *Mods* directory and unpack the following zip there:

||  **[Download the full release from Nexus Mods](https://www.nexusmods.com/xcom2/mods/757?tab=files)** ||

There is also a smaller, patch version available at that link that can be unpacked on top of any existing dev build 21 installation.

## Changelog

### The Reaper

While some players considered the new Reaper to be strong, others considered them to be mediocre. In this build, we're buffing the Reaper's ability tree in various ways and making some of the abilities work better with the new Shadow:

 * Shadow now grants 100% detection range reduction, up from 70%
 * Knife Juggler is now at LCPL
 * Reposition and Silent Killer are now available at CPL
 * Blood Trail now applies a Dodge reduction bonus to the target instead of bleeding, making killing shots more reliable against units with Dodge (still has +1 damage, and both effects require the target to already be damaged in that turn; also only works for the primary weapon)
 * Lone Wolf is now available at SGT
   - As an additional benefit, Lone Wolf's effect tapers so that it doesn't lose the entire bonus if you're just within the minimum 7-tile range (applies to Lone Wolf generally, not just for Reapers)
 * Shadow Grenadier is a new passive ability at SGT that allows the Reaper to throw grenades without breaking Shadow; it also grants a grenade pocket
 * Soul Harvest at SSGT now grants +10% base crit chance plus additional +4% per kill up to an overall maximum of +30%
 * Sting at SSGT has 2 charges and applies both holotargeting and 1 point of rupture to the target (can still only be used from Shadow and guarantees that the Reaper remains in Shadow)
 * Poisoned Blades is a new passive ability at SSGT that makes throwing knife attacks apply poison
 * Charge Battery is a new charge-based ability at TSGT that allows the Reaper to extend the duration of Shadow by 1 turn (currently a free action)
 * Knife Faceoff is a new ability at GSGT with a single charge that behaves like Faceoff for throwing knives
 * Needle, Remote Start, and Homing Mine all have been moved to the random ability decks (XCOM-row abilities)

### Chosen

Assassin gets a slight rework, turning her into a juggernaut:

 * Loses Bending Reed and Cool Under Pressure, and no longer conceals after Parting Silk
 * Loses Bladestorm as a basic ability and gains it as a tier-3 strength
 * Gains Brawler (30% damage reduction within 4 tiles)
 * Gains Instant Reaction Time (gain 2 dodge against attacks for each tile distant from the attacker)
 * Gains Slash(the adjacent only melee attack that's not turn ending)
 * Her prime reaction now causes to move towards the closest target, AND ALLOWS HER TO SLASH
   - Assassin throws blind grenades for free with 1 turn cooldown, but its radius has been reduced to 2 tiles from 3 1/3 tiles
   - Blind effect sight radius to 4 from 5
   - Harbor Wave is now readded, and deals sword level damage, while also triggering Blood Thirst for each target, while its cone range has decreased from 25 to 15; Blood Thirst does increase its damage
 * Increased HP and amour at various tiers and difficulties to make her tankier
 * Mobility decreased to 10
 * She now correctly runs toward cover during scamper
 * Parting Silk can now target civilians
 * Her sword is no longer a guaranteed crit (so she deals slightly less damage late game) but it bypasses Combatives for real this time

In addition, there are more general changes to the Chosen, some of which are very significant:

 * Lowered Retribution knowledge gain from 15 to 5
 * Chosen kidnap knowledge gain to 15 from 20
 * Retribution now requires level 1 knowledge, which means that a Chosen that has 0-25 knowledge will always train; the less a Chosen kidnaps, the more terrifying it is
 * Chosen Sabotage cooldown to 3 from 1 but the effects are a lot stronger, for example a 75% drain on supplies
 * Chosen Avenger Defence has several changes:
   - It now has way more powerful enemies
   - The Avenger health has been increased to 550
   - The armored car damage per turn has gone up to 4 from 1
   - You no longer get corpses
   - The activation time is shorter (2-10 days, down from 4-20)
 * Added a Chosen-immunities passive which displays what they're innately immune to
 * Chosen will no longer have Keen and kidnap on Chosen Avenger Defense and Chosen Showdown missions
 * Increased T4 Chosen HP on all difficulties
 * Chosen are now resistant to immobilize, getting a -50% penalty to mobility instead of not being able to move at all
 * Chosen kidnap now has an animation and can only target XCOM soldiers
 * Timer on Defend_LW retaliations is now 2 turns less but RNFs start significantly weaker; reinforcements do ramp up a bit faster than in dev build 21 and notably faster than in Long War 2
 * Increased Hunter's grapple cooldown by 1
 * Chosen prime reactions should now properly display in their F1
 * Tweaked the strength table, chosen will now get their defensive perks earlier
 * Soulstealer nerfed to regain 75% of health as damage from 100%
   - was too strong compared to regeneration
 * Regeneration now heals 16% of the unit's max HP
 * Apex Predator now correctly specifies that it works with a primary weapon only

### Covert actions

Covert actions can once again be ambushed, which has led to some other rebalancing of them.

To begin with, the ambush mission is different from before: you now have 12 hours to send a quick-response squad of 4 soldiers to go and rescue your covert operatives. Your squad starts at one end of the map in the evac zone, while the covert operatives start at the other end. There are (currently) 7-9 enemies in between the two sets of soldiers. Be warned that your covert operatives may activate a pod at the start, so make sure they're kitted out properly!

Other changes include:

 * "Hunt the Chosen" durations have been reduced substantially
 * Failure chances have been reduced a bit across the board
 * You can upgrade the Resistance Ring once to add an engineer slot for a further reduction in covert action durations (if staffed)
   - The old Resistance Ring upgrades are no longer available
   - Engineers reduce duration by 25%, down from 33% (because 2 engineers reduce durations by 50%)
 * Improve Combat Intelligence can no longer fail, you only send one soldier on it, and you can no longer send Very-High com int soldiers on it; on the flip side, it takes longer to complete
 * Bradford will hopefully no longer nag you to build the Resistance Ring

### Experimental overwatch changes

The old LW2 overwatch behaviour meant that overwatch soldiers would often get flanking shots on the enemies. However, it also meant that soldier and the enemy could move just one tile and avoid the overwatch. Not only is this a bit cheesy, but it also makes suppression pretty unreliable.

With this release, you can **opt into** a modified version of WOTC overwatch rules, where any movement into or out of a tile covered by overwatch will proc an overwatch shot. In vanilla WOTC, this makes overwatch quite bad because the shot is typically against a unit in cover, so the target gets the defense bonus on top of the overwatch hit-chance reduction. We are trialling a system that mitigates this major downside by granting overwatch shots a reduction on the target's cover defense bonus (but not intrinsic defense or that granted by abilities).

The upshot of this change is that suppression seems to be more reliable and Covering Fire's value goes up significantly. Gotcha Again's overwatch indicators will also be accurate with this change.

If you'd like to try out the new overwatch behaviour, simply disable the Revert Overwatch Rules mod. That's it. When the game loads up, it will show a dialog saying that the mod is required and is missing, but that's fine. Simply accept or click on "Never show again". LWOTC will work just fine without it, just with the new overwatch behaviour.

### Balance

 * Reapers and Skirmishers get a pistol slot and pistol abilities (note that Quickdraw works for throwing knives!)
 * Shinobis have Hit & Run and Hunter's Instinct swapped, so Hit & Run comes at TSGT and competes with Reaper
 * Nerfed Rupture to give 3 again, down from 4, since it's strong vs Chosen
 * Infighter Dodge bonus up to 33 from 25
 * Faction soldiers no longer get their specific GTS upgrades
   - Parkour is now an XCOM-row ability for Skirmishers
   - Mentally Awake is already on caster gauntlets
   - Infiltration isn't particularly useful with the new Shadow
 * High-combat-intelligence faction soldiers no longer get nearly as much soldier AP (ability points) as before, so they're more inline with normal soldiers
 * Supply raids and troop columns now scale enemies based on underinfiltration
   - One of Minor, Moderate, Major or Impossible? sit reps is applied, depending on the level of infiltration (75-99%, 50-74%, 25-49%, 0-24%)
   - These sit reps increase the Aim, Defense, Dodge, and HP of all units on the map by varying amounts
   - The command pods are now always 5 units (no more 8-unit command pods) and have force-level-appropriate units in them
 * Up to 3 captured soldiers can now be rewarded for a single Jailbreak mission, making it easier to retrieve all your soldiers if a lot of them get captured by Chosen
 * Poison always lasts for two turns now
   - Poison had the chance to disappear almost immediately, making Venom Rounds and Gas Grenades particularly weak
   - Soldiers will now be able to move out of poison clouds without poisoning themselves again, since they will still be poisoned for the turn following the poison being applied
 * Reaper HQ intel gain increased slightly, from 0-4 every 2 days to 2-4 on Commander and Legend difficulties, from 2-6 to 4-6 on Rookie and from 1-6 to 3-6 on Veteran
 * Mechanized Warfare no longer has the MEC wreck requirement, since many players were struggling to get one in a reasonable time frame

### Bug fixes

 * Sabotage Transmitter mission's timer now starts at 4, down from 5
 * Chosen will now appear on golden-path missions and on their own Chosen Avenger Assaults
 * Chosen will no longer appear on missions that have an Alien Ruler on them
 * Alien Rulers will now appear fairly frequently on relevant missions (UFOs, troop columns, HQ assaults, facilities)
 * M3 Gunners can now make use of their Traverse Fire ability
 * Najas will now favour moving as far away as possible from XCOM to the edge of vision
 * Scrap Metal now works
 * Infighter no longer procs at 2 tiles higher range than intended
 * All havens should now be selectable via a controller
 * Acid Grenades Proving Ground project now correctly requires a Spectre corpse
 * Talon Rounds Proving Ground project now correctly requires an Officer corpse
 * The Recruit screen now has all the recruits in a scrollable pane, so you'll be able to see all of them when you have more than can fit in one screen
 * The Recruit screen will also no longer have the stats disappear when you recruit a soldier
 * Psi operatives should no longer get Soul Steal twice as a training option (works around a bug in vanilla game)

Lastly, a big thank you to FlashVanMaster for contributing a significant chunk of Russian translations.

We hope you enjoy the mod, and good luck commanders!
