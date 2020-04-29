Welcome to **dev build 14.1** of Long War of the Chosen!

This is an experimental build in which many changes are being tested out. It is a drop-in replacement for earlier dev builds and beta 2. 

**Important** You must disable the Revival Protocol Fixes mod with this build! It wasn't fixing the Revival Protocol bugs properly, so we have implemented the fixes directly in LWOTC instead. Once you've disabled the mod, loading an existing campaign will warn about it being missing. That's fine and the warning can be safely ignored.

**UPDATE** Dev build 14 was released with a defective highlander (no idea what happened there), so there is now a dev build 14.1 release (download link below has been updated).

## Dev build 14.1

* Technical and Templar pistol perks now cost the same as for other classes

* Inconsistencies in faction soldier ability costs have been fixed,
  such as Judgement costing 25 AP when it's not a GSGT or MSGT perk

* When the option for allowing players to purchase multiple class
  abilities at each rank for non-faction soldiers is enabled, the
  ability costs now match the faction soldier ability costs rather than
  the ones for the XCOM row, i.e. 10, 11, 12, etc. instead of 10, 10,
  10, 20, 20, 40

## Dev build 14

This is mostly a bug fix release - changes listed below.

### Balance

* Steady Weapon has been reworked (again):
  * It provides +20 aim, +20 crit chance on all tiers of weapons
  * It is now available on assault rifles, Gunners' cannons, shotguns and SPARK cannons in addition to sniper rifles
  * Soldiers no longer lose the buff if they're wounded by the enemy before they can use it
  * It can no longer be used from concealment
* Beam Shard Gauntlets now get Deep Focus
* Squad Sight is now a tier 2 XCOM ability for Reapers instead of tier 1
* The number of available covert actions (CAs) increases with influence now (low influence: 4, medium: 5, high: 6)
* The Recruit Extra Faction Soldier CA no longer spawns before you can undertake it (it requires high influence)
* The Intense Training CA can spawn for multiple factions at the same time

### Bug fixes

* The Intense Training CA can now be started (unless you don't have the necessary 5 XCOM AP available!)
* Enemy units should no longer be able to target through walls and other obstructions with AoE abilities, like Poison Spit
* Revival Protocol will no longer give extra actions to stunned and disoriented units that are revived
* Templar's Solace is no longer a free action and has a 2-turn cooldown (a misconfiguration meant it was free
  and had no cooldown)
* Purifiers **can** now use their flamethrower while disoriented (a bug was preventing this from happening)
* Some faction soldier XCOM abilities were costing 25 AP instead of 10, 20 or 40 depending on rank - this is now fixed
* Lone Wolf was appearing as an XCOM ability for Reapers even though it's a class ability - this has been removed from
  the Reaper's XCOM ability pool
* HEAT Warheads was configured as both a tier 1 (AP cost 10) and a tier 2 (AP cost 20) XCOM ability for Skirmishers -
  it's only available at tier 1 now

**[Download the release from here](https://www.dropbox.com/s/vc5a027y9j1ll5j/lwotc-dev-0014.1.zip?dl=0)**

We hope you enjoy the mod, and good luck commanders!
