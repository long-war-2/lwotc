Welcome to **dev build 23** of Long War of the Chosen!

The last dev build was supposed to be the basis for beta 4, but one of the recent bug fixes was far reaching enough that it really needed testing in another dev build. So here we are! And plenty of changes have been made since dev build 22.3, among them:

 * Reaper's throwing knives get a chance to bleed now, their higher tiers do an average of 1 more damage than before, and Silent Killer has a chance to extend the duration of Shadow
 * Soldiers will now lose Will more quickly in missions, but they will no longer lose it when taking damage, and nor will Tired soldiers panic from random stuff that happens
 * Gunners have been nerfed hard because some bugs with Lockdown and Mayhem made them godlike - sorry if you missed that!
 * Anything that extends the mission timer (sit reps, map size) will now result in the reinforcements arriving more slowly, with bigger extensions resulting in a greater slowing of RNFs
 * Chosen will no longer appear on HQ Assaults

To install dev build 23, just delete your existing LongWarOfTheChosen and X2WOTCCommunityHighlander folders from the *Mods* directory and unpack the following zip there:

||  **[Download the full release and/or the patch from Nexus Mods]()** ||

The patch version can be unpacked on top of any existing dev build 21 or more recent installation.

## Changelog 23

### Quality of life

 * The plot type selected for a mission is now displayed in the mission summary panel (where mission expiry is displayed)
 * You can change the value of the `USE_LARGE_INFO_PANEL` config variable in *XComLW_UI.ini* to enable a large-text version of the mission information panel, while `CENTER_TEXT_IN_LIP` allows you to switch to centered text rather than the default left aligned
 * Controller X is now used to open a haven from the resistance management screen
 * Controller X is now used to change the haven adviser in the haven screen, either to open the soldier list to add an adviser or to remove the existing adviser

### Balance

*Strategy*:

 * Starting regions will now have 3-4 links with other regions and you will be much less likely to start in the same small selection of regions each campaign - this makes the start of the campaign noticeably less punishing
 * The first covert action will now have risks enabled on it
 * Chosen no longer increase the base chance of covert action risks when they reach a certain knowledge level
 * Chosen will no longer appear on HQ Assaults
 * Ambush risk chances are no longer higher for more difficult covert actions
 * Average chance of ambush is now 20%, down from 25%
 * Shaken now takes 20-24 days to recover from

*Tactical*:

 * Soldiers now lose 1 point of Will every 3 turns instead of 4, but they will no longer lose Will for taking damage; Tired soldiers will lose Will every 2 turns
 * Tired soldiers should no longer panic from units taking damage, being mind controller, dying, etc.
 * Anything that extends the mission timer (sit reps, map size) will now result in the reinforcements arriving more slowly, with bigger extensions resulting in a greater slowing of RNFs (this should help with large-map Jailbreaks and some Project Miranda missions)
 * Silent Killer now has a 25% chance to extend the duration of Shadow when it procs
 * Throwing Knives' base damage is now 4-6 at tier 2 (from 3-5) and 6-9 at tier 3 (from 5-8)
 * Throwing Knives have a chance to cause bleeding on units that can bleed (30% for tier 1, 50% for tier 2 and 70% for tier 3)
 * *(You will not need to respec your Reapers for the above changes to take effect)*
 * Boosted Cores applies to tick damage (poison and burning) once again, just like it did in Long War 2
 * Apotheosis now prevents focus gain from Rend kills (helps tame the Apotheosis/Reaper combo a little)
 * Combat Readiness now removes Iron Curtain correctly (the effect wasn't removed before)
 * The ADVENT General's damage has gone from 3-5 to 5-8 with +2 crit damage; M2's damage has gone up to 6-10 with +4 crit

### Mods

 * Mods can configure slots so they can't be edited in the loadout screen while a unit is on a mission via the new `UNMODIFIABLE_SLOTS_WHILE_ON_MISSION` config array in *XComLW_Overhaul.ini*
 * Mods can prevent certain soldier classes from training as officers via the new `CLASSES_INELIGIBLE_FOR_OFFICER_TRAINING` config array in *XComLW_OfficerPack.ini*

### Bug fixes

*Strategy*:

 * Hopefully there should be fewer problems after rescuing certain soldiers that have been captured (specifically those captured automatically at the end of missions rather than by the Chosen)
 * The objectives screen no longer looks terrible as it no longer tries to overlay two blocks of text over one another
 * You can now choose not to start a covert action when a supply drop happens and still be able to start one before the next supply drop (the notification on the Geoscape that provides this feature is back)
 * Researching any basic level grenade Proving Ground project after Advanced Explosives no longer gives you the advanced version of that grenade (for example, you could previously research Advanced Explosives, then the EMP grenades project, which would grant you an EMP *Bomb*)
 * Cooldowns in descriptions should all be consistent in treating a 1-turn cooldown as "can be used once a turn", i.e. the number of turns of cooldown includes the turn on which the ability is used
 * If you are using a controller, you will no longer see the Save Squad button and the Squad Container dropdown; consider using the [Squad Management For LWotC](https://steamcommunity.com/sharedfiles/filedetails/?id=2314584410) mod for a better experience

*Tactical*:

 * The cover defense reduction bonus used by the new overwatch rules is no longer active when the Revert Overwatch Rules mod is enabled
 * Mayhem and Lockdown no longer stack (Gunners were getting the effects twice each for some reason)
 * Lockdown is no longer stronger than advertised (it was in fact +22 aim); its bonus has been raised to +20 Aim to compensate
 * Area Suppression will now correctly use the new overwatch rules if those are enabled (by disabling/removing the Revert Overwatch Rules mod)
 * Lone Wolf's Defense bonus is now calculated correctly (before, it was calculating distance between the attacker and *their* nearest ally)
 * Quick Zap now works
 * Bring 'em On now works with explosives
 * Center Mass now works with sidearms, which include the Templar's autopistol (it's not categorised as a pistol)
 * Death Dealer no longer applies to tick damage like bleeding and poison
 * Units summoned by the Warlock should now render properly (no more floating heads with guns)
 * The Vektor Rifle aim no longer drops off rapidly a few tiles into Squadsight, instead falling off linearly at a rate of -3 aim per tile

Thanks to everyone for their contributions, including:

 * kdm2k6
 * Amnesieri
 * Kiruka

We hope you enjoy the mod, and good luck commanders!
