Welcome to a new version of Long War of the Chosen!

This is the first beta version and marks effectively "feature completedness". And as part of that, we're using the new name Long War of the Chosen publicly to help distinguish it from original Long War 2. It's been called LWOTC informally for a while, so this just makes it official.

Apologies for this not being on Steam Workshop. We were hoping to put the beta on there, but it just hasn't worked out. We will try to get it ready for the next release.

The major change for this release is a significant rebalancing of the faction soldiers. Every one of them now has a Master Sergeant rank and they have more abilities to flesh out their perk trees. Much more work will need to be done to balance these powerful soldiers, but hopefully you will enjoy the new abilities in the meantime. Except for Reapers. They got nerfed *hard*.

For installation instructions, look at the starter guide in the zip file or follow [the instructions on the wiki](https://github.com/long-war-2/lwotc/wiki/Play-testing-Long-War-of-the-Chosen).

**Upgrade notes** If you're upgrading from alpha 5 or newer, please follow these steps:

 * Make sure you save your current campaign while you're on the Avenger!
 * Replace the existing mods with the new ones.
 * Subscribe to the newly required mods:
   - [WotC: robojumper's Squad Select](https://steamcommunity.com/sharedfiles/filedetails/?id=1122974240)
   - [Better Second Wave Mod Support](https://steamcommunity.com/sharedfiles/filedetails/?id=1149493976)
   - [[WOTC] Revert Overwatch Rules Change](https://steamcommunity.com/sharedfiles/filedetails/?id=1127539414)
 * Remove the old LongWarOfTheChosen and X2WOTCCommunityHighlander mod directories and replace them with the new ones.
 * After starting the game, load from your strategy save.
 * **If you had the Chosen enabled** be sure to open up the Change Difficulty menu on the Avenger, select Advanced Options and then make sure the Enable Chosen second wave option is checked. Once you've done that, save your game again.
 * If you want to get the latest perk trees for the faction soldiers, subscribe to the [Additional Soldier Console Commands](https://steamcommunity.com/sharedfiles/filedetails/?id=1370543410) mod and use the `RebuildSelectedSoldierClasses` console command when you have the soldier you want to respec open in any of the Armory screens.
 * If you want to remove Increase Income and Breakthrough Tech Covert Actions (which have now been disabled), use the `RefreshCovertActions` console command.

This is a significant release, with plenty of folks to thank. See Acknowledgements at the end to learn who's been contributing. And feel free to join us on our [Discord server](https://discord.gg/9fUCvcR)!

# Changelog

Here are the changes since alpha 6:

## Reaper

Overall, Reaper's stealth has been nerfed, but they are still the stealthiest unit in the game, especially if they get Covert, and they're the only one that can damage and kill units without losing concealment. They just can't single-handedly win missions any more.

* Now has a Master Sergeant rank
* Detection radius has increased to be in line with Shinobis, but they get Ghostwalker for free at Squaddie level.
* Precision Shot and Walk Fire have been addeded a LCPL.
* Remote Start has been moved to CPL and now only has a single charge rather than a cooldown.
* Needle has been moved to down CPL from SGT.
* Shrapnel has been moved up to SGT from CPL.
* Covert has been added at SSGT.
* Lone Wolf has been added at TSGT.
* Banish has been moved up to GSGT from Tech Sergeant.
* Dead Eye has been added at GSGT.
* Annihilate had been added at MSGT, while Ghost Grenade and Implacable have been added at this rank.

## Skirmisher

Skirmishers are in a state of flux right now, so expect more changes here. The current rebalance focuses on making them true "skirmishing" units that stick to the fringes of battle and make a nuisance of themselves. Note that Forward Operator was removed because it was simply broken, allowing Skirmishers to basically complete some missions solo without any risk. It may return in a modified form in a later version.

* Now has a Master Sergeant rank.
* Starts with Hit and Run instead of Marauder to encourage more mobility in battle. Also gets a grenade slot for utility, has a small infiltration bonus, and gets the Damn Good Ground bonus.
* Justice and Wrath cooldowns are now 4 turns, and Whiplash has a 4-turn cooldown as well instead of having a single charge.
* Interrupt is now a free action with a 3-turn cooldown and is an XCOM ability (like an AWC ability)
* The GTS Parkour research decreases the Grapple cooldown to 2 from 3.
* Total Combat is now an XCOM ability and replaced by Combat Awareness at LCPL.
* Retribution has been moved to LCPL from SSGT
* Low Profile and Body Shield have been added at CPL, while Zero In has been moved to the XCOM abilities.
* Smart Macrophages and Combat Fitness have been added at SGT.
* Full Throttle has been moved up to SSGT from SGT, where Shredder and Formidable have been added.
* Combat Presence has been moved to the XCOM abilities.
* Judgement has been moved from GSGT to TSGT, where Run and Gun and Aggression have been added.
* Waylay has been removed as a Skirmisher skill entirely as has Reckoning (for now).
* Implacable and BringEmOn have been added at GSGT.
* Battlelord has been moved to MSGT where it is joined by Lethal and Tactical Sense

## Templar

Templars don't have many changes in the skill slots, but some skills themselves have been reworked.

* Now has a Master Sergeant rank.
* Pillar is now a free action that can be used after Rend (like Parry)
* Stun strike no longer disorients, but will stun and knock back the enemy; hit chance increased from 65% to 75%; stuns for 1 turn.
* Deflect has a 25%/30%/35%/40% chance to block a shot with 1/2/3/4 focus.
* Reflect has a chance to reflect the shot back at the shooter on a successful Deflection; the chance to turn a Deflect into a Reflect is 80%/85%/90% at 2/3/4 focus.
* Reflect can also trigger on a Parry at a 30%/40%/50% chance at 2/3/4 focus.
* Reaper has been added at GSGT.
* Bladestorm and Supreme Focus (requires Deep Focus, increases max focus to 4) have been added at MSGT.

## Mission Changes

* The Chosen base assault is now a 5-soldier mission.
* The Avenger Defense mission works with faction soldiers now, so they're counted properly and can evac the mission.
* Turrets from the Defense Matrix will now appear on the Avenger Defense mission.
* XCOM reinforcements on the Avenger Defense now have action points, so you can actually use them!
* The Invasion mission doesn't ramp up reinforcements as fast as it did before, but you can no longer cheese the mission by shooting the spike for 10 damage or more in one shot. It's harder to shoot the spike with Sharpshooters too now, as some of the locations with clear lines of sight around them have been moved.
* Faction soldiers can now pick up the Black Site vial.
* All-alien pods should have greater diversity in their unit composition now.
* Alien Rulers now behave as they do in WOTC, which means that stuns, frozen, etc. only last per Ruler Reaction. However, non-offensive or non-move actions do not trigger Ruler Reactions.
* Special grenades like Sting and Ghost grenades should no longer appear as items in the Avenger's inventory after missions.
* Soldiers that are left behind on missions should now be captured (or killed if they're bleeding out) instead of returning to the Avenger. Mostly affects stunned/unconscious units.
* Purifiers and drones have been removed from reinforcements.
* The reinforcements alert is working again (the coloured one in the top left corner of the screen).
* Units recover properly from the Arc Thrower stun now.
* The LW2 flamethrower targeting is back! Burninators rejoice!! (This basically means you can step out to use the flamethrower and enemy units stepping out from high cover will get hit)
* The Blaster Launcher targeting has been fixed.
* Rapid Fire no longer has a cooldown.
* Various abilities like Death From Above, Hit And Run, etc. now work properly when you regain control of a mind-controlled unit _after_ the start of your turn, for example if you flashbang the mind controller with another soldier.
* Double Tap is now working again with Death From Above, allowing the latter to trigger on _both_ Double Tap shots.
* ADVENT Rocketeers can no longer shoot through obstructions, like walls.
* The officer perk Focus Fire is now working properly, i.e. it's increasing the aim bonus with every shot on the target.

## Campaign/Geoscape Changes

* There is now a Second Wave option to enable the Chosen when you start the campaign (click on the Advanced Options button of the campaign start screen to get there). The old config setting no longer has any effect.
* The Chosen will now activate automatically after you complete your first Liberation Network Tower mission successfully.
* Chosen are now guaranteed to appear on the first mission after activation unless it is one of the mission types they are excluded from
* The chance for Chosen to appear on other (non-excluded) missions is a flat 20%, but under infiltrating a mission will increase this chance, while over infiltrating will decrease it
* Faction influence can now be gained without having the Chosen active by liberating regions under the control of a faction's Chosen adversary (they have one even if the Chosen aren't active)
* The Chosen-related monthly report screens should now be skipped if they aren't active.
* The Covert Actions for facility leads and Avatar progress reduction are now unique, meaning you can only complete the once per faction per campaign.
* The Gone To Ground dark event (it shuts the Black Market down for a period of time) has been removed. It wasn't working properly and is probably too harsh for LWOTC.
* The Show Infiltration Percentage in Squad Select mod has been integrated, meaning the Squad Select screen now displays enemy activity based on the maximum infiltration you can achieve, as well as when you boost the infiltration.
* The Squad Select screen now displays the map type, i.e. Slums, City Center, Abandoned City, etc.
* The Squad Select screen now has Clear Squad and Autofill Squad buttons.
* Rebels now get AWC abilities when they rank up. This change is retroactive if you load a strategy save after upgrading, so rebels who have already ranked up will also get some abilities.
* The Trial By Fire resistance order has been removed as it has minimal effect without the ability point events. It could be reinstated once we have a more reliable source of common-pool Ability Points.
* The Training Center, Resistance Ring, the latter's upgrades, and the Hypervital Module no longer require upkeep. Initial costs of those have been adjusted to compensate.
* Faction soldier armours now have the same engineer requirements as the corresponding medium armour (Predator and Warden).
* Shaken soldiers can no longer become haven advisers.

# Acknowledgements

A big thanks to the following:

* martox and jmartinez for their work on the faction rebalance
* Favid for his coding contributions and, in particular, his fix for the LW2 flamethrower targeting and animations
* Kaen for some thorough testing and sterling work on the starter guide, FAQ and troubleshooting guide (the latter two will appear on the wiki) - you can catch him on [Twitch as Kaen_SG](https://www.twitch.tv/Kaen_SG)
* Finik for some fixes to the Russian translations (other contributions to localisation files are very welcome!)
* s4320079 for the fix to Rapid Fire's cooldown
* All the folks that have been testing the alphas and development builds and providing feedback and issue reports

We hope you enjoy the mod, and good luck commanders!