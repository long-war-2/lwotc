Welcome to **dev build 20** of Long War of the Chosen!

The obvious question is why dev build 20 when the last one was 17? That's because two other builds were released only via our Discord. If you have played with either 18 or 19, know that dev build 20 includes the changes from dev build 18 but not those from 19.

A lot has changed since dev build 17, so it's probably worth starting a new campaign with dev build 20. You should be able to upgrade mid campaign, but you will need to respec all your soldiers to take advantage of the new XCOM row abilities and new Reaper.

To install dev build 20, just delete your existing LongWarOfTheChosen and X2WOTCCommunityHighlander folders from the *Mods* directory and unpack the following zip there:

||  **[Download the release from here](https://drive.google.com/file/d/1bhQ7ChsrOe_CGM0A5LBA2bzkq1f7qmke/view?usp=sharing)** ||

There is also an untested, smaller, patch version available here that can be unpacked on top of an existing dev build 17 installation:

||  **[Download dev build 17 to 20 patch from here](https://drive.google.com/file/d/1hsqjcATjAJfaj1zcQuenmkxJ9biES-00/view?usp=sharing)** ||

The big changes include:

 * A rework of the Lost that introduces Lost Grappler and Lost Brute, reduces the number of Lost that appear significantly, and scales the Lost's stats as the campaign progresses
 * A rework of the Reaper that does away with permanent stealth in favour of a stronger, 1-turn stealth ability
 * An overhaul of the XCOM row abilities for all soldier classes, with a lot of new abilities introduced
 * Integration of Combat Intelligence into Not Created Equal
 * A reversion of the Stock and Steady Weapon changes back to LW2 behaviour
 * Better controller support, and players can now switch between input devices in Options from the main menu
 * Replacement of the integrated Detailed Soldier Lists mod with a tweaked LW2 version - you can use the separate Detailed Soldiers Lists mod if you want

**Important** If you really want to upgrade mid campaign, be sure to use the `RespecSelectedSoldier` or `RespecAllSoldiers` console commands to update the ability trees for your Reapers and Skirmishers, or just all of your soldiers if you want the updated XCOM row abilities.

## Credits

A great many thanks to NotSoLoneWolf for permission to use the laser and coilgun strike rifle models from [Wolf's Asset Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=2245270253).

A big thank you to Musashi for permission to use the throwing knives from his [WotC Combat Knives](https://steamcommunity.com/sharedfiles/filedetails/?id=1135248412) mod. We would also like to thank everyone who gave permission to use their custom abilities from various perk packs.

Another big thank you to ObelixDK for permission to use the Lost Brute from the [World War L](https://steamcommunity.com/sharedfiles/filedetails/?id=1163327507) mod!

More thanks to kdm2k6 who has been fixing various issues with controller integration so that LWOTC can be played with a controller rather than mouse and keyboard. There are still things that need to be done, but great progress has been made already.

## Changelog

### The Reaper

We decided that the Reaper was far too dependent on permanent stealth, and Silent Killer was the must-have ability. This limited what you could really do with them and made them feel quite weak before they go Silent Killer.

In this build, we're trying a new approach: Shadow is now a 1-turn concealment with a very low detection radius that is on a cooldown. This means that there is no permanent stealth for the Reaper, but the unit can enter stealth multiple times per mission, perhaps to scout, hit hard with Death Dealer, get past overwatching enemies to get a flank, or just to get out of trouble.

For players used to permanent stealth, it may take a while to adjust to the new mechanics. However, we do think this makes the unit more interesting to play, especially as you don't need to worry as much about losing concealment/Shadow.

In addition to losing permanent stealth - don't forget, you can still build stealth Shinobis! - we've removed the Claymore in favour of throwing knives. This was partly because the Claymore was hard to mod, but also because it was a bit of a one-trick pony. Reapers still keep Remote Start and Homing Mine for now.

Throwing knives are low-damage, short-range weapons that can be used without losing Shadow. They have a nice bonus to crit chance, so they can do a fair bit of damage from flanking attacks.

Lastly, the Vektor Rifle now behaves more like a strike rifle from LW1, with a slight penalty to Aim at close range, but it can be used from Squadsight up to a point without penalty. However, the penalty does start applying about 5 tiles from outside visual range (around where it happens with Snap Shot) and the penalty starts increasing exponentially with increasing distance.

To fit with that theme, we're now using NotSoLoneWolf's laser and coilgun strike rifle models for those tiers of the Vektor rifle family, replacing the crossbows from before. The alternate conventional-tier crossbow is still available to use.

### The Lost

Dev build 20 introduces two new Lost units to LWOTC:

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

### Detailed Soldier Lists

This mod is no longer integrated into LWOTC; we're using a modified version of the old LW2 one instead. If you would like to continue using Detailed Soldier Lists instead, you can just subscribe to the mod from the Workshop. Just be aware that it won't display officer ranks, nor will it display the correct XP for a soldier.

As the built-in soldier list UI does not display XP, we recommend that you subscribe to [Extended Personnel Info](https://steamcommunity.com/sharedfiles/filedetails/?id=1458945379) if you want to see that information from soldier list views.

One very noticeable thing that has changed is the icon for Combat Intelligence: it is now the text "AP" coloured the same as with Detailed Soldier Lists. In addition, the icon can have up to four coloured points in the corners indicating the level of Combat Intelligence:

 * Red, no corner pips - Very Low
 * Amber, 1 corner pip - Low
 * Yellow, 2 corner pips - Average
 * Green, 3 corner pips - High
 * Blue, 4 corner pips - Very High

### Controllers

Contoller integration is steadily getting better, so there is less need for players to switch back to mouse & keyboard. Here are the improvements in this version:

 * Players can now switch input devices from the Options in the main menu (but not from within an active campaign)
 * The dark event lists on the Geoscape are now properly navigable
 * Officer training slots and the officer ability screen now work properly
 * Navigating the promotion screen should be less frustrating, as moving the focus between columns will no longer reset the focus to the first row
 * Highlighted soldier list view items are now more readable with Will values and the AP icon inverting their colours

**Important** If you're using LeaderEnemyBoss's No Drop Down List mod (highly recommended!) then switch to the [controller-compatible WOTC version](https://steamcommunity.com/sharedfiles/filedetails/?id=2098062078). 

### Balance

 * Skirmishers no longer have Justice at Squaddie (this should help tone down their incredible starting strength); it is now pickable at LCPL
 * Justice replaces Damn Good Ground, which has moved to CPL, replacing Tradecraft (which is now an XCOM-row ability)
 * Templar's Vigilance will now only trigger on revealing pods of 3 or more enemies
 * Templar's Reaper damage falloff now always applies before the Apotheosis bonus, so the Templar can no longer chain insane Reaper attacks together
 * Bladestorm can no longer trigger on the owning unit's turn
 * All XCOM row abilities have been shaken up, with new abilities being added:
   - There are now 4 tiers of XCOM-row (random) abilities
   - All soldier classes get 2 x tier 1, 2 x tier 2, 2 x tier 3 and 1 x tier 4
   - Each random pool of abilities is more tuned for its corresponding soldier class, i.e. there should be fewer "useless" abilities rolled
   - XCOM-row and pistol abilities at all ranks can now be purchased regardless of the soldier's rank, as long as the Training Center has been built
 * Combat Intelligence is now rolled as part of Not Created Equal, and the old "Gifted" is now the average that soldiers get
 * Ability Point rewards and costs have been rebalanced, mostly to rein in the ability to make faction soldiers godly by dumping all AP into them:
   - Soldiers get +4 AP for each promotion, down from +5
   - Hero MSGT abilities cost 30, up from 25
   - Costs of purchasing class abilities at ranks that already have one picked scales up faster (multiplier from 1.5 to 1.7)
   - Difficult/very difficult mission AP rewards down from 3/5 to 1/3
   - Ability Points covert action now rewards more at Rookie, very slightly more at Veteran, but rewards a little less on Legend compared to before
 * Intense Training rewards have been rebalanced to match their relative strength in Not Created Equal (except for Hack and Psi Offense)
 * The Improve Combat Intelligence covert action now takes longer to complete
 * Superior Weapon Upgrade and Superior PCS covert actions can now spawn at the starting influence level, down from Respected
 * Recruit Scientist and Engineer covert actions now require Respected, up from the starting influence level
 * Executioner and Locked On grant +20/+20 Aim/Crit, up from +10/+10
 * Walk Fire ammo cost from 2 to 1, no longer has a cooldown, and does 34% reduced damage, down from 50%, i.e. it does *more* damage than before
 * Interference is now a free action
 * Tracking radius from 25 to 30
 * Rupture now adds 4 rupture, up from 3
 * Cyclic Fire malus to 10 from 15, ammo count to 3 from 5, cooldown to 2 from 5
 * Shieldwall grants 5 armor from 3
 * Aim ability grants +20 Crit Chance in addition to +20 Aim
 * Flush's Dodge debuff increased to 30 from 10
 * Hail of Bullets ammo cost down from 4 to 3
 * Grazing Fire now works for all abilities/weapons that use standard aim, including those that use secondary or other non-primary weapons
 * Scanning Protocol now has 3 charges, up from 1
 * Needle Grenades now do +1 damage to unarmored targets
 * Rescue Protocol has +1 charges at all Gremlin tiers and grants the target +15 Dodge and +5 Mobility
 * Gunslinger's cooldown has been reduced from 4 to 3 and its range from 12 tiles to 8, but it now has 360 degree activation instead of a cone
 * Soul Storm no longer ignores armor, radius decreased to 7 meters from 8, and it can now target allies
 * Phase Walk has an 18-tile range, down from unrestricted
 * Soul Steal now heals *and* grants ablative HP, with the ablative lasting 3 turns
 * Horror no longer causes Will loss and will now panic the target instead of shattering it, but the chance to panic has been slightly increased
 * Decreased Sectopod damage from 9-16 average (12.5) to 9-13 (average 11) and health decreased from 35/60/80/95 to 35/55/75/90
 * Muton base damage decreased from 7 to 6 and no longer has 1 pierce that Centurions and Elites didn’t have
 * Gatekeeper defense gain from closed state decreased from 25 to 20, and Gateway radius from 10.5 meters to 8, but they shouldn’t Gateway their allies anymore
 * Decreased advent Vanguard aim by 5
 * Decreased Spectre weapon damage from 5-8/6-10 (average 6.5 / 8) to 4-7/6-8 (average 5.5/7)
 * Remodeled Priest AI to be less predictable, all Priests gain 10 Psi Offense, and Advanced and Elite Priests lose 10 innate Dodge; Priests will no longer stasis the Lost
 * Purifiers lose their unused grenade, granting them +1 Mobility, and their pistol damage has been decreased from 1-3/3-5/5-7 to 1-3/2-5/4-6, although their pistols still have 2/3/4 crit damage; they also gain Return Fire for their pistols
 * Beam Grenade launcher gains +2 range
 * Higher-tier Technical gauntlets have a higher chance to stun enemies
 * SMGs now have +2 Mobility (down from +3), 3 ammo (up from 2), and have higher close-range Aim bonuses than before * the range change also applies to Bullpups and Autopistols
 * The Stock has been reverted to providing Steady Weapon, as in LW2 - weapons no longer have this ability attached to them
 * Bluescreen rounds and EMP grenades no longer disorient non-robotic enemies
 * Spectres, Purifiers and Priests are a bit more common now, making it easier to acquire their corpses
 * Snakes of all types appear less often
 * Codexes appear more frequently in the end game
 * Some item corpse requirements (and the corresponding research projects) have been changed:
   - Battle Scanner requires a Trooper corpse rather than a Drone
   - Acid grenades require Spectre corpses instead of Archons
   - EMP grenades require Turret wrecks instead of Drones
   - Ionic Ripjack requires Muton corpse rather than Stun Lancer
   - Fusion Ripjack requires Andromedon corpse rather than Archon
   - Talon rounds require Officer corpses rather than Sectoids

### Bug fixes

 * Fuse and Apotheosis can no longer be used once a unit has no actions available (this prevents the problem with having to manually end the turn when soldiers with these abilities are in the squad)
 * Pods will now activate if a squadsight shot targeted at one of the members misses
 * Faceless and Chryssalids should now appear on missions with the corresponding Infiltrator sit rep
 * Dark event sit reps like Rapid Response should no longer appear on missions that they don't work on (for example, Rapid Response on untimed missions with no reinforcements)
 * Lost should no longer appear on Abandoned City missions that don't support The Lost sit rep (such as troop columns)

We hope you enjoy the mod, and good luck commanders!
