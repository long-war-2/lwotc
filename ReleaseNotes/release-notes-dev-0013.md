Welcome to **dev build 3** of Long War of the Chosen!

This is an experimental build in which many changes are being tested out. It is a drop-in replacement for earlier dev builds and beta 2.

**Important** We have fixed a critical bug in covert actions introduced in dev build 12, so we highly recommend you upgrade from dev build 12 as soon as possible (earlier builds are fine). You can read all about it below.

Here are some of the headline changes you may be interested in:

* Find Faction/Farthest Faction covert actions can no longer fail (see below under *Covert actions*)
* WOTC enemies have received the Long War treatment, so they're a bit tougher to deal with now
* Alien Rulers can no longer appear quite as early as before
* Encounter-modifying sit reps like Savage and Psionic Storm have been enabled

**[Download the release from here](TODO)**

# Changelog

Here are the changes since dev build 12:

## Covert actions

Dev build 12 introduced some serious problems, the primary one being that Find Faction and Find Farthest Faction covert actions could fail. Unfortunately, if they did fail, it broke the game.

**Note** The fix in this build will not apply to those covert actions that have already been generated in an existing campaign. However, if your Find (Farthest) Faction actions fail, you can manually run the new `MeetFaction <Faction>` console command, e.g. `MeetFaction Skirmishers`. If your soldiers are still stuck in the covert action after that, `CompleteCurrentCovertAction` should do the trick.

This build includes some fixes to those problems, while also introducing some rebalancing based on early feedback:

* Find Faction, Find Farthest Faction, and Recruit Faction Soldier (only available if you've lost your current one) can no longer fail
* The covert action report screen will now display failed CAs as FAILED!
* Durations have been reduced again
* Resource rewards have been increased (except for ability points)
* The per-rank failure chance reduction has been at least doubled, but now the base failure chance increases with force level (meaning Squaddies and LCPLs have a much bigger effect early game, but become less useful CA operatives later in the campaign)

In addition, we have added a new covert action - Intense Training - that will boost a random stat on whichever soldier goes on the mission (you know in advance which stat and by how much). This covert action is guaranteed to succeed, but it costs 5 ability points to start it.

## WOTC Enemies

### Purifiers

* Their flamethrower now uses LW2 flamethrower targeting (yes, the one that can get round high cover)
* They can flamethrower while disoriented
* Purifiers get a pistol - low base damage, but decent crit damage
* New AI - now extremely aggressive, will often ignore cover just to get closer to you, and will never ever use the grenade
* Heavy stat tweaks - most notably with Aim brought down to reasonable levels, severely reduced mobility (9 with all the stuff they carry), and increased Will
* Flamethrower cone length reduced by 1
* Flamethrower burn damage down to 1-3 from 2-4
* M2s and M3s gain Burnout and M3s additionally gain Formidable

These changes mean that Purifiers perform the function of close-quarters, low-mobility juggernauts. Keeping your distance from them will be extremely important, but also much easier.

### Priests

* Heavy stat tweaks - most notably with Psi Offence severely nerfed (Legend M1 Psi Offence down to 25 from 40, Rookie down to 15)
* Stasis no longer ends turn
* New AI - slightly more intelligent use of stasis, only attempts mind control with a very high (>=80) chance of success, and actually uses the gun on exposed targets
* M1 Priests now have mind control
* Significantly increased Holy Warrior offensive buffs to stats (+Aim, +Crit chance, +HP)
* Holy warrior will no longer kill the target unit on the Priest's death
* Reworked how the Priest Sustain works: instead of a flat chance, it's now a 100% chance - (25/17/10% * Overkill Damage), i.e. the more overkill damage dealt, the less likely Sustain is to trigger, potentially to a 0% chance
* Increased their M3 weapon base damage
* M2s and M3s gain Fortress, while M3s additionally get Bastion
* Reworked the sustaining sphere cost: it now costs 2 Priest corpses, an elerium core and 5 supplies (but it's still consumable)

### Spectres

* Small AI tweaks: won't use Shadowbind on targets with < 50% HP, will shoot at exposed targets, and will use Horror more
* Increased the weapon and Horror base damage
* M2s gain Low Profile

## Encounter-modifying sit reps

Sit reps like Savage and Psionic Storm modify the composition of enemy pods ("encounters"), typically replacing the initial units with others of a certain type, such as melee units (Savage) or psi units (Psionic Storm) for example.

These don't work quite the same in LWOTC as they did in vanilla: they replace the units in *some* pods on a mission. So even if Savage is active, for example, you will still likely encounter ADVENT and other types of unit. How many pods are modified like this depends on what schedule was selected for the mission. For those that aren't familiar with how enemies are selected for missions, just understand that 1 to 3 pods (and maybe very rarely more) will be changed.

For those of you that are used to schedule and encounter definitions, the unit replacement only happens for "OPNx" encounter definitions. Sometimes there is only one such encounter in a schedule. Often there are more.

Anyway, this should hopefully help with 3rd-party mods that use the standard vanilla approach to introduce their own enemy types via sit reps.

## Balance

* Will recovery is a bit faster (from 8 days to recover from 67% Will to full, to 6 days)
* Viper King can start appearing from FL8 (up from 4), Berserker Queen from FL11 (up from 8) and the Archon King from FL15 (up from 12)
* Damage falloff has (hopefully) been reverted to LW2 values for the moment because grenades could do 1 damage on the center tile
* Throwing the evac flare now breaks the Reaper's Shadow concealment (if the Reaper throws it of course)

## Bug fixes

* Templar Overcharge now works (I'm sure of it!...)
* The Loot Chests sit rep no longer marks missions as "difficult" (so no more free ability points!)
* ADVENT/alien units will no longer run away from the Lost like scaredy cats
* Stun Lancers will use their batons again

We hope you enjoy the mod, and good luck commanders!
