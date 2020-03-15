Welcome to **dev build 12** of Long War of the Chosen!

This is an experimental build in which many changes are being tested out. It is a drop-in replacement for earlier dev builds and beta 2.

Here are some of the headline changes you may be interested in:

* Will loss and recovery has been reworked significantly (see below)
* Resistance Orders are disabled by default (can be enabled via a Second Wave Option)
* Reworked Covert Actions so that they can now fail, but you have more to choose from
* Improved various units' AI
* Added an Easter egg

**[Download the release from here](https://www.dropbox.com/s/bksudz5x6oh83o7/lwotc-dev-0012.zip?dl=0)**

# Changelog

Here are the changes since dev build 11:

## Will loss and recovery

After some discussions in the project's Discord, we decided to try an alternative approach to Will loss and fatigue:

* Soldiers no longer lose Will from encountering enemy pods
* Instead, all soldiers will lose 1 point of Will every 4 turns
* Will can no longer be recovered during infiltration, covert actions, haven duty or training

Overall, this means that soldiers will lose Will more slowly, but will take longer to recover it. Also note that high-Will soldiers will recover Will more quickly because the amount of Will recovered each day is proportional to the maximum Will of the soldier.

## Covert Actions

One of the main issues with covert actions was that you could throw any old soldiers, including rookies in many cases, onto a mission that provided stat bonuses and other rewards for little investment. And they were always guaranteed to succeed. To compensate, we increased the durations significantly.

We have tried to make them more interesting in this build by allowing them to fail. To compensate, you get more covert actions to choose from and many of the durations have been significantly reduced. This should make the Resistance Ring a more appealing first facility.

If you're upgrading LWOTC in the middle of a campaign, consider using the `RefreshCovertActions` console command to refresh your covert actions and get access to the extra ones. Note that the permanent ones, like Hunt the Chosen or Find Faction, won't be updated.

In summary:

* Covert actions can now fail (chance to fail displayed as a percentage, as are all other risks)
* Use higher-ranked soldiers to reduce the chance of failure (reduction scales linearly with rank)
* Covert actions can no longer be ambushed, because the Ambush mission really needs to be reworked
* There is now a covert action to get enemy corpses
* More covert actions are available to you from the start
* Many durations have been reduced significantly (and more tweaking to all CA durations will probably be needed)
* Some covert actions now require more soldiers than before
* Stat bonuses are no longer awarded (hope to add a different mechanism for granting stat bonuses in the future)

## AI changes

* These abilities no longer target Lost:
  * Drone stun
  * Viper bind
  * Priest's Stasis
  * Stun Lancer sword/baton attack
  * Officer's Mark
* ADVENT/aliens are now slightly less likely to target The Lost overall
* Drones will try to flank units before shooting (and the have the same range table as SMGs now)
* Enemy units will now activate if they are shot at from squad sight, even if the shot misses
* Enemy units will also advance via cover on snipers that target them (and there aren't other XCOM soldiers in vision)
* Vipers should no longer target poison-immune targets with Poison Spit (includes units with medikits)
* Purifiers should no longer target fire-immune targets

## Resistance Orders

These are now disabled by default, but you can re-enable them via a Second Wave Option (similar to the Chosen). Note that they will remain enabled in existing campaigns that have resistance orders active.

We were having to disable a lot of these, plus some of them granted hefty XCOM bonuses with little investment or trade off. It's just simpler to disable them rather than invest the time into balancing them right now.

We will hopefully come up with a great idea for resistance orders in the future to make them more interesting and fit better into the Long War strategy mechanics.

## Balance

* Sidewinders now have the same range table as SMGs rather than a short one, meaning that their aim doesn't drop off at distance quite as quickly as it did
* Sharpshooter's Kubikiri has been replaced by Disabling Shot
* Spider and Fly dark event disabled because covert actions can no longer be ambushed
* Wild Hunt dark event disabled because it doesn't affect Chosen spawns in LWOTC

## Bug fixes

* Skirmishers and Templars can now throw the evac flare
* Whirlwind on M3 stun lancers now works
* Hit and Slither on M2 and M3 Sidewinders now works
* The camera in the after-mission screen no longer puts the soldier in the center of the screen when promoting them

We hope you enjoy the mod, and good luck commanders!
