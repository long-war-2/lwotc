Welcome to **dev build 15** of Long War of the Chosen!

This is (hopefully) the last experimental build for a while. It is a drop-in replacement for earlier dev builds and beta 2. We will be requesting feedback on balance and features over the coming weeks to give us an idea of what should stay, what should change, and what should be reverted.

**Important** As with dev build 14, you must disable the Revival Protocol Fixes mod with this build!

The big change in this build is that the following dark events don't affect every mission while they are active and instead give a chance for a corresponding sit rep to be added to a given mission:

* High Alert
* Infiltrators (Faceless)
* Infiltrators (Chryssalids)
* Lost World
* Rapid Response
* Return Fire
* Sealed Armor
* Vigilance
* Undying Loyalty

This makes those dark events less of a drag. On the flip side, those sit reps can also spawn like any other sit rep when the corresponding dark event is *not* active.

## Changelog

### Dark events

The dark events listed above no longer have a direct impact on all the missions that are run while they are active. Instead, we have the following behaviour:

* Missions spawned during the dark event have a 40% chance to get a dark event sit rep
* The dark event sit rep is *in addition* to any other sit rep that's rolled normally
* You can only have one dark event sit rep active on any given mission
* Mission types that don't allow normal sit reps *can* have a dark event sit rep (but only while the corresponding dark event is active)
* These new sit reps can also be attached to missions as normal sit reps, just like Location Scout and Project Miranda
* The new sit reps have appropriate force level requirements so that you don't encounter them too early

### Better Squad Icon Selector

This is an old LW2 mod that has been integrated into LWOTC. It allows you to click on the squad icon in the squad management screen and pick an icon from a grid that's displayed (rather than using the forwards and backwards buttons to cycle through the icons). Thanks to robojumper for allowing us to integrate it and suggesting we do so.

### Balance

* Covert action failure risk chances are now a bit lower in the early game, but are notably higher in the mid game - this should make early covert actions a bit more appealing while requiring higher level soldiers than CPLs and LCPLs in the mid game to get very low failure chances
* Normal sit reps can no longer be active on invasions
* Sit reps can no longer be removed by overinfiltrating to 125%+
* The Lost can no longer appear on untimed missions
* Low Visibility has been removed (it was far too buggy)
* Location Scout grants the Tracking ability (see Reaper faction class) to all squad members instead of making the whole map visible
* Added a "There's Something in the Air" sit rep that grants Combat Rush on critical hits to both XCOM and ADVENT (the effect doesn't work on robotic units)
* Project Miranda is restricted to FL4 and above
* Tactical Analysis can no longer be awarded as a continent bonus
* Equivalents of some of the old LW2 continent bonuses have been added:
  * Popular Support (more Supplies in drops)
  * Quid Pro Quo (buy from Black Market more cheaply)
  * Under The Table (sell to Black Market for extra Supplies)
  * Recruiting Centers (reduced cost of Rookie recruits)
  * Inside Job (all Intel rewards increased)
  * Hidden Reserves (extra Avenger Power)
  * Ballistics Modeling (faster weapon research)
  * Noble Cause (faster Will recovery for soldiers on Avenger)

### Bug fixes

* The correct Training Center is now displayed when clicking on a soldier's AP points in Squad Select (requires the latest robojumper's Squad Select mod)
* The Gunner's Quickdraw ability is 5 AP (it was 10 AP before, twice the value for the other classes!)
* Command Range 7 on Field Commanders now has descriptive text rather than being blank

**[Download the release from here](https://www.dropbox.com/s/z72fhgel8xl2540/lwotc-dev-0015.zip?dl=0)**

If you already have dev build 14.1, then you can download and extract [this patch](https://www.dropbox.com/s/og2y2opdu3dscn5/lwotc-dev-0015-from-14-patch.zip?dl=0) to your *XComGame/Mods* directory (**don't** delete the existing directories in this case).

We hope you enjoy the mod, and good luck commanders!
