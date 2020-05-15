Welcome to a new version of Long War of the Chosen!

While beta 1 was supposed to mark the stage of "feature complete", that wasn't really the case, as you'll discover with the huge number of changes in beta 3! Because of that, we highly recommend you start a new campaign when you upgrade to beta 3 from beta 2.

Here are some of the headline changes you may be interested in:

* Chosen now activate at force level 5, increase in strength (more HP and armour) at fixed, later force levels, and have more impact on the strategy layer with Sabotage and Retribution
* All the faction soldiers have had some significant work done on their abilities
* Covert actions can now fail, with the rank of the soldiers on the action influencing the failure chance (higher ranks == greater failure chance reduction); not all covert actions can fail, though
* You will now encounter sit reps, both positive and negative, on some of the missions
* Alien Rulers now appear via sit reps (gated by force level) rather than according to some obscure rules
* Temporary dark events that affect tactical battles directly, for example Undying Loyalty and Rapid Response, no longer apply to all missions while active; instead, they increase the chance that you will encounter the corresponding sit rep on a mission
* Resistance orders are disabled by default, but can be enabled via a second wave option
* Will loss and recovery has changed significantly, for example, Will no longer recovers during infiltration

||  **[Download the release from here](https://www.dropbox.com/s/joysj8r5n6j8bnm/LongWarOfTheChosen-1.0-beta-3.zip?dl=0)** ||

More details on all the balance changes and bug fixes below.

**WARNING** If you choose not to upgrade to 1.0 beta 3 yet, be aware that a new version of Dedicated Pistol Slot mod will cause issues with pistol slots in existing campaigns. See [this Reddit post](https://www.reddit.com/r/LWotC/comments/gcmn9k/warning_prepare_for_changes_to_dedicated_pistol/) for details and a solution.

**Mod dependency changes** Dedicated Pistol Slot and Revival Protocol Fixes are now integrated into LWOTC and incompatible with it. You will need to unsubcribe from them or disable them.

**IMPORTANT** If you're upgrading from beta 2 or a development build and want to continue an existing campaign, make sure you load a strategy save after the upgrade, i.e. one that was created while you were on the Avenger. Also, use the new `RespecSelectedSoldier` console command on your faction soldiers to get the new ability trees.

Read the [installation instructions](https://github.com/long-war-2/lwotc/wiki/Installing-Long-War-of-the-Chosen) for information on how to perform the upgrade.

Please feel free to join us on our [Discord server](https://discord.gg/9fUCvcR), submit feedback via issues in GitHub, or start a thread on the [Pavonis Interactive forums](https://pavonisinteractive.com/phpBB3/viewforum.php?f=22).

# Changelog

Here are the changes since beta 2:

## Mods

* Dedicated Pistol Slot is no longer required and must be disabled or removed
* Revival Protocol Fixes is no longer required and must be disabled or removed
* [LW2: Better Squad Icon Selector](https://steamcommunity.com/sharedfiles/filedetails/?id=848382778) has been integrated into LWOTC
* Using LWOTC and RPGO together should no longer result in a massive drop in FPS

## Class and ability changes

### Reapers

* Distraction now disorients enemies caught in the Claymore explosion rather
  than putting the Reaper into Shadow. Replaces Walk Fire at LCPL rank.

* Lone Wolf replaces Precision Shot at LCPL.

* Tracking is a new ability that allows Reapers to detect units within
  slightly more than visual range, even if they are out of line of
  sight. Replaces Target Definition at CPL.

* Sting swaps with Silent Killer and Dead Eye replaces Distraction at SGT.

* Highlands replaces Covert at SSGT, with Covert moving to TSGT.

* Covert replaces Death Dealer, Homing Mine replaces Highlands, and
  Precision Shot replaces Lone Wolf at TSGT.

* Disabling Shot is a new ability that stuns most units in the game
  for 2 actions (it won't work on units immune to stun), or for 4
  actions if it crits. Does half normal damage and can't do crit damage.
  Replaces Dead Eye at GSGT.

* Hit and Run replaces Homing Mine at GSGT.

* Shadow Rising (one extra Shadow charge) and Serial replace Ghost
  Grenade and Implacable at MSGT. Ghost Grenade is now an XCOM
  ability.

* Squad Sight is now a tier 2 XCOM ability for Reapers instead of tier 1.

* Reapers now get a normal selection of XCOM abilities like other
  soldier classes.

* Throwing the evac flare now breaks the Reaper's Shadow concealment
  (if the Reaper throws it of course).

### Skirmishers

* Reflex can proc once per turn now, but not more than once.

* Justice and Wrath now have a 4-turn cooldown (down from 5).

* Justice should no longer destroy everything (rocks, walls, etc.).

* Judgement has a greater base chance to cause panic and the higher
  the Skirmisher's Will, the greater the addtional chance for it to proc.

* Full Throttle's mobility buff is now 3 (up from 2) and lasts for 2
  turns (including the turn it activates). Still stacks.

* Whiplash behaves more like Justice and Wrath now, with scaling
  damage based on Ripjack tier, a 1-action-point cost, and a bonus
  to aim. It still does bonus damage to robotic enemies.

* Battlelord now has a 5-turn cooldown in place of charges. It can also
  proc an unlimited number of times on the turn it's active. Hit and Run,
  Death from Above, Close Encounters and Full Throttle can not proc while
  Battlelord or Skirmisher Interrupt are active.

* Reckoning is back as a MSGT ability (it provides Fleche and Slash abilities
  that use the Ripjack).

* Manual Override is now targetable and resets all the target's cooldowns.
  Cannot currently be used on self.

### Templars

* Templars no longer have a guaranteed hit on Rend. This means your
  Templars can now graze as well as miss. The gauntlets give +25 aim
  to compensate.

* You can now equip Templars with caster gauntlets (conventional, ionic
  and fusion versions) instead of the original shard gauntlets.

* The caster gauntlets give the Templar 1 focus at the start of the
  mission and provide the Channel ability (killed units have a chance
  to drop collectable focus).

* Both shard and caster gauntlets grant Deep Focus at ionic (Arc Blade)
  tier and Supreme Focus at fusion tier.

* The shard gauntlets add a Fleche damage bonus to Rend, although slightly
  less generous than for Shinobis' sword attack.

* Focus does not provide bonus mobility any more, and it only increases
  dodge by +3 for each point of focus, and damage by +1 at focus levels
  of 1 and 3 (focus levels of 2 and 4 do not add any extra damage
  beyond 1 and 3).

* Overcharge has been reworked to simply provide bonus aim and defense
  based on the current focus level.

* Templars now have access to a LCPL Vigilance ability that grants 1 focus
  when an enemy pod is activated, i.e. they scamper.

* Volt uses area suppression targeting, so the number of units you can
  hit no longer depends on the Templar's focus level. The radius is 1 less
  than for Gunner's Area Suppression.

* Blademaster replaces Channel at CPL.

* There is a new SGT High Voltage ability that increases the radius of Volt
  by 2 tiles.

* Pillar can be used in place of a Momentum action. It can still be
  used as a normal action as well.

* Stun Strike now stuns instead of disorienting enemies.

* Templars now have access to a Solace ability for clearing mental
  conditions on their allies. It's a targetable ability rather than an
  aura.

* Terrorize is a new ability at TSGT that adds a chance to panic to
  Volt.

* Void Conduit should disable for the correct number of actions (a bug meant
  that it wasn't disabling at all if the Templar had 2 focus or less).

* Apotheosis is a new MSGT ability that consumes all focus and grants the
  Templar +100 Dodge, double Rend damage, and +2 Mobility per focus consumed
  above 2, i.e. +2 for 3 focus, +4 for 4 focus. Requires a minimum of 3 focus
  to activate.

* Templars now get a normal selection of XCOM abilities like other
  soldier classes.

### Miscellaneous

* XCOM soldiers start with lower Will than before, with a much lower range
  of Will values. Will values are now closer to what they were in original
  Long War 2.

* Faction soldier stat progression, particularly HP, has been toned down a
  bit, so they won't be quite so tanky at MSGT.

* Fleche bonus damage is capped at +5, so moving more than 20 tiles with a
  Shinobi Fleche does not provide any extra damage beyond that.

* Fleche no longer applies its bonus damage to other damage effects like
  Shredder or the Burning effect of Fusion Blade.

* The Fleche bonus damage can now graze (so no more 7+ damage grazes with a
  conventional sword).

* Full Override's first ability is now Greater Shutdown, which simply shuts
  a robotic enemy down for 3 turns.
  
* Full Override's Master Enemy now has a special variant for Sectopods with
  a much-reduced success chance, which means you have to be quite lucky to
  pull off this mission-winning tactic.

* MECs mastered via Full Override will now become Resistance MECs even if you
  evac them from a mission.

* Bombardier (+2 to grenade range) now works for Reaper Claymores as well.

* Close and Personal is now a tier 2 XCOM ability for Shinobis rather than tier 1.

* Various AP cost issues have been fixed, for example where Squad Sight as an
  XCOM perk was costing 25 AP rather than 20.

## Tactical combat changes

### Chosen

  * Shell shock damage bonus reduced to 34%.
  * Brittle Damage bonus reduced to 15%.
  * Bewildered Damage bonus reduced to 25%.
  * Adversary Damage bonus reduced to 25%.
  * Replaced Melee immunity with Melee Resistance, which reduces incoming
    melee damage by 50%.
  * Replaced Blast Shield immunity with a 50% damage resistance.
  * Groundling aim bonus increased to 20.

### Will and Tiredness

* Soldiers no longer lose Will from encountering enemy pods.
* Instead, all soldiers will lose 1 point of Will every 4 turns.
* Tired soldiers are much less likely to panic than before.
* Will loss from taking wounds is now capped at 20% of max Will.

(See campaign/Geoscape changes for more info on Will recovery)

### Enemies

* Lost targeting changed to 60% XCOM, 40% aliens/ADVENT.
* ADVENT Sentries do a bit less damage than before (they were doing the
  same damage as Officers rather than using their own config). So from
  3-5 down to 2-5.
* Sidewinders now have the same range table as SMGs rather than a short
  one (like shotguns), meaning that their aim doesn't drop off at distance
  quite as quickly as it did.
* Drones will more aggressively try to stun units, even when flanking them.
* The Drone's stunner now has a 2-turn cooldown, i.e. it can only be used
  once every three turns.
* Sectopods no longer have Resilience.
* Purifier changes:
  - Flamethrower now uses LW2 flamethrower targeting (yes, the one that can
    get round high cover).
  - Flamethrower cone length reduced by 1.
  - Flamethrower burn damage down to 1-3 from 2-4.
  - They can flamethrower while disoriented.
  - They get a pistol - low base damage, but decent crit damage.
  - New AI - now extremely aggressive, will often ignore cover just to get
    closer to you, and will never ever use the grenade.
  - Heavy stat tweaks - most notably with Aim brought down to reasonable
    levels, severely reduced mobility (9 with all the stuff they carry), and
    increased Will.
  - M2s and M3s gain Burnout and M3s additionally gain Formidable.
  - Purifiers perform the function of close-quarters, low-mobility juggernauts.
    Keeping your distance from them will be extremely important, but also much
    easier.
* Priest changes:
  - Heavy stat tweaks - most notably with Psi Offence severely nerfed (Legend
    M1 Psi Offence down to 25 from 40, Rookie down to 15).
  - Stasis no longer ends turn (now the same as for XCOM).
  - New AI - slightly more intelligent use of stasis, only attempts mind control
    with a very high (>=80) chance of success, and actually uses the gun on
    exposed targets.
  - M1 Priests now have mind control.
  - Significantly increased Holy Warrior offensive buffs to stats (+Aim, +Crit
    chance, +HP).
  - Holy warrior will no longer kill the target unit on the Priest's death.
  - Reworked how the Priest Sustain works: instead of a flat chance, it's now a
    100% chance - (25/17/10% * Overkill Damage), i.e. the more overkill damage
    dealt, the less likely Sustain is to trigger, potentially to a 0% chance.
  - Increased their M3 weapon base damage.
  - M2s and M3s gain Fortress, while M3s additionally get Bastion.
  - Reworked the sustaining sphere cost: it now costs 2 Priest corpses, an
    elerium core and 5 supplies (but it's still consumable).
* Spectre changes:
  - Small AI tweaks: won't use Shadowbind on targets with < 50% HP, will shoot
    at exposed targets, and will use Horror more.
  - Increased the weapon and Horror base damage.
  - M2s gain Low Profile.
* Enemy units will now activate if they are shot at from squad sight, even
  if the shot misses.
* Enemy units will advance via cover on snipers that target them (and if
  there aren't other XCOM soldiers in vision).

### Miscellaneous

* Steady Weapon has been reworked:
  * It provides +20 aim, +20 crit chance on all tiers of sniper rifles.
  * +30 aim, +30 crit chance on Gunners' cannons and SPARK cannons.
  * +40 aim, +40 crit chance on shotguns.
  * Soldiers no longer lose the buff if they're wounded by the enemy
    before they can use it.
  * It can no longer be used from concealment.
* Shredder and Shredstorm guns now have damage falloff that applies from
  the shooter, i.e. full damage at point-blank range, minimum damage at
  the range limit of the gun. This does not apply to the weapons'
  environment damage.
* Alien Hunter and SPARK weapons have had damage spreads brought into line
  with the standard weapons (slight nerf to damage over all).
* Fusion Axe now has same burn chance as Fusion Blade (currently 10%).
* Skullmine gets the same damage boost as Skulljack to ensure kills.
* All soldiers now have two new abilities:
  - Stock strike - Strikes a mind-controlled soldier with the butt of your
    weapon, stunning the target for 1 turn. Costs 1 action and ends turn.
  - Get Up - Removes the unconscious effect from a soldier. Costs 2 actions
    and ends turn.
* Collector no longer procs on killing Lost.
* Evac flare has the same effect on Lost activation as a standard shot.
* You should now encounter a maximum of 2 Sectopods in a pod, down from 3.

## Missions

* The Sabotage Transmitter mission has been added to the guerrilla op pool.
* Recruit Raids now correctly result in captured XCOM soldiers when appropriate.
* Chosen Sarcophagi should now have higher HP (60/80/80/100 by difficulty).
* Recruit Raids will likely happen a bit more frequently (fixed a typo in
  their cooldown config).

## Campaign/Geoscape Changes

### Chosen

* The Chosen now activate at Force Level 5.
* Can't appear on network tower assaults or non-Chosen Avenger Defense.
* Can now appear on Smash and Grabs and Jailbreaks (Rescue Rebels).
* Additional DE at knowledge level 2, Sabotage at knowledge level 3 and Avenger
  assault at knowledge level 4.
* Chosen no longer level their stats up with training. They just get a perk.
* Chosen can now train as much as they need to, thus they no longer have a hard limit
  on perk counts.
* Chosen now level their stats with force level (the FL thresholds are 8/13/17).
* Retribution now reduces the supply, intel and recruit job effectiveness by
  25% for 21 days instead of its previous effect -- the effect stacks multiplicatively.
* Sabotage chance increased from 75% to 100%.
* Increased the max datapads stolen from 2 to 3.
* Increased the additional wound days of some soldiers from 5 to 9 days.
* Increased the elerium core stolen from 1-2 to 3-5.
* Increased the weapon mod stolen from 1-2 to 3-5.

### Alien Rulers

Alien Rulers now have a sit rep each that places them on missions. If you
have the Alien Nest mission enabled, they won't be able to spawn on missions
until it's completed. After that, or if it's disabled, they will be able to
spawn once you reach a certain force level:

  * FL8 for Viper King
  * FL11 for Berserker Queen
  * FL15 for Archon King

Alien Rulers will only spawn on these missions:

  * Troop Columns
  * Landed UFO
  * HQ Assault
  * Facility

### Covert Actions

One of the main issues with covert actions was that you could throw any old
soldiers, including rookies in many cases, onto a mission that provided stat
bonuses and other rewards for little investment. And they were always
guaranteed to succeed. To compensate, we increased the durations significantly.

We have tried to make them more interesting, or at least require a bit more
thought, by allowing them to fail. To compensate, you get more covert actions
to choose from and many of the durations have been significantly reduced.

In summary:

* Covert actions can now fail (chance to fail displayed as a percentage, as are
  all other risks).
* The covert action report screen will now display failed CAs as FAILED!
* Use higher-ranked soldiers to reduce the chance of failure (reduction scales
 linearly with rank).
* Covert actions can no longer be ambushed, because the Ambush mission really
  needs to be reworked.
* Wound and capture risk chances are now significantly lower.
* More covert actions are available to you from the start.
* The number of available covert actions (CAs) increases with influence
  (low influence: 4, medium: 5, high: 6).
* There is now a covert action to get enemy corpses (a random selection of
  force-level appropriate enemy corpses weighted slightly towards the most useful
  ones for research and equipment).
* Many durations have been reduced significantly.
* Some covert actions now require more soldiers than before.
* Only Capture risk can currently be mitigated with an investment of Intel.
* Stat bonuses are no longer awarded except via the Intense Training covert action,
  which cost 5 *XCOM* ability points.
* A soldier can only go on a maximum of two Intense Training CAs.
* Find Faction, Find Farthest Faction, and Recruit Faction Soldier can not fail.
* The Recruit Extra Faction Soldier CA no longer spawns before you can undertake
  it (it requires high influence).

**Note** If you're upgrading LWOTC in the middle of a campaign, consider using the
`RefreshCovertActions` console command to refresh your covert actions and get access
to the extra ones. Note that the permanent ones, like Hunt the Chosen or Find Faction,
won't be updated.

### Sit Reps

Sit reps now have a chance to appear for missions. By default, there is a 30% chance for
this to happen for those missions that allow sit reps. Retaliations, invasions, rendezvous,
network towers and HQ assaults can not have sit reps.

Sit reps like Savage and Psionic Storm modify the composition of enemy pods ("encounters"),
typically replacing the initial units with others of a certain type, such as melee units
(Savage) or psi units (Psionic Storm) for example.

These don't work quite the same in LWOTC as they did in vanilla: they replace the units in
*some* pods on a mission. So even if Savage is active, for example, you will still likely
encounter ADVENT and other types of unit. How many pods are modified like this depends on
what schedule was selected for the mission. For those that aren't familiar with how enemies
are selected for missions, just understand that 1 to 3 pods (and maybe very rarely more)
will be changed by these sit reps.

For those of you that are used to schedule and encounter definitions, the unit replacement
only happens for "OPNx" encounter definitions. Sometimes there is only one such encounter
in a schedule. Often there are more.

Other changes:

* Sit reps have an internal difficulty rating.
* "Difficult" missions award 3 ability points at the end of the mission whereas "Very
  Difficult" missions award 5 AP (no UI for this yet, sorry).
* Supplies awarded by Resistance Contacts and Loot Chests sit reps have been lowered
  significantly (down to 5-12 for resistance contacts, 8-16 for chests).
* Location Scout grants the Tracking ability (see Reaper faction class) to all squad
  members instead of making the whole map visible.
* Added a Project Miranda sit rep that reduces aim by 20 and mobility by 2 for all
  organic units on the map (including ADVENT), compensated slightly by +2 to the turn
  timer.
* Added a "There's Something in the Air" sit rep that grants Combat Rush on critical
  hits to both XCOM and ADVENT (the effect doesn't work on robotic units).

### Dark Events

The big change here is that the following dark events won't affect every mission while
they are active, instead giving a chance for a corresponding sit rep to be added to a
mission:

* High Alert
* Infiltrators (Faceless)
* Infiltrators (Chryssalids)
* Lost World
* Rapid Response
* Return Fire
* Sealed Armor
* Vigilance
* Undying Loyalty

This makes those dark events less of a drag. On the flip side, those sit reps can also
spawn like any other sit rep when the corresponding dark event is *not* active. And to
compensate, the dark events last about 50% longer.

In summary:

* Missions spawned during the dark event have a 40% chance to get a dark event sit rep.
* The dark event sit rep is *in addition* to any other sit rep that's rolled normally.
* You can only have one dark event sit rep active on any given mission.
* Mission types that don't allow normal sit reps *can* have a dark event sit rep (but
  only while the corresponding dark event is active).
* These new sit reps can also be attached to missions as normal sit reps, just like
  Location Scout and Project Miranda.
* The new sit reps have appropriate force level requirements so that you don't encounter
  them too early.
* The sit reps only appear on missions that make sense for them, for example the Rapid
  Response sit rep will only appear on missions with normal reinforcements that don't
  appear every turn.

Other changes:

* Permanent dark events are displayed as permanent (English-language only)
* You will now receive a notification when dark events expire
* Spider and Fly disabled because covert actions can no longer be ambushed.
* Wild Hunt disabled because it doesn't affect Chosen spawns in LWOTC.

### Will and Tiredness

* Will can no longer be recovered during infiltration, covert actions, haven
  duty or training.
* Will takes 6 days to recover from 67% of max to 100%.
* High Will is beneficial because soldiers recover the Will lost on missions
  more quickly (Will loss is based on flat numbers, while recovery is based
  on percentage of max Will).

### Research

* Incendiary grenades require Purifier corpses and the autopsy to research and build
  them -- Officers corpses aren't required for anything any more and the +1 HP Vest
  bonus is gone (for now)

### Miscellaneous

* Resistance orders are disabled by default, but can be enabled via an advanced/second
  wave option on campaign start
* Equivalents of some of the old LW2 continent bonuses have been added:
  * Popular Support (more Supplies in drops)
  * Quid Pro Quo (buy from Black Market more cheaply)
  * Under The Table (sell to Black Market for extra Supplies)
  * Recruiting Centers (reduced cost of Rookie recruits)
  * Inside Job (all Intel rewards increased)
  * Hidden Reserves (extra Avenger Power)
  * Ballistics Modeling (faster weapon research)
  * Noble Cause (faster Will recovery for soldiers on Avenger)
* The starting region's haven will no longer start with a Faceless in it.
* All rebels start on the Intel job.
* You can now recruit 2 soldiers from each faction if you have sufficient influence
  with them.
* Sewer plots have been disabled to reduce the prevalence of Tunnels maps. Subway
  is still in the pool.
* Shadow Chamber info is now displayed on the mission screen for all missions once
  it's built and it shows the correct number of units. It won't show Alien Rulers
  currently, but you'll know from the sit rep.
* Rookies' stats are now displayed on the Recruit screen, as they were in LW2 1.5.
* Facility Lead and UFO mission description changed to better indicate which mission
  is which. UFO discovery missions now have "Find Enemy Flight Paths" as the objective,
  while facility lead missions now have "Find a Facility Lead".
* You can now update soldier ability trees after upgrading LWOTC with the
  `RespecSelectedSoldier` and `RespecAllSoldiers` console commands. The first one
  will respec whichever soldier is selected in the armory when you run the command.

## Bug fixes

### Strategy

* Soldiers can now equip conventional pistols on existing beta 2 campaigns.
* The stow location for pistols is no longer overridden, so mods like Akimbo should
  now work with LWOTC.
* SPARKs no longer get a pistol slot and other classes can be excluded via the new
  `EXCLUDE_FROM_PISTOL_SLOT_CLASSES` INI setting.
* Faction soldier XCOM abilities no longer increase in AP cost when other abilities
  at the same rank have been picked.
* The GTS upgrade slots now require 1 power instead of 2.
* You will no longer get your starting faction's HQ bonus on campaign start (Skirmisher
  and Templar HQ bonuses were applying permanently for the whole campaign, and scanning
  at the corresponding HQ just increased the bonus).
* When selecting scientists or engineers as haven advisers, they will no longer be
  displayed as "Rank Too Low".

### Tactical

* Skirmishers and Templars can now throw the evac flare.
* Fixed a Smash and Grab, alert 2 schedule that should have had 9 enemies but in fact
  had 10. In other words, you might occasionally encounter Smash and Grab missions with
  10 enemies instead of the expected 9.
* Fixed a bug on some VIP Vehicle missions where the VIP wouldn't spawn in the vehicle.
* The Rapid Response dark event no longer forces reinforcements on missions that have a
  Chosen active.
* Revival Protocol will no longer give extra actions to stunned and disoriented units
  that are revived.
* The Lost no longer stop appearing after you defeat all aliens/ADVENT on the Supply
  Extraction mission.
* The Lost will now appear on Hack, Recover Item and Destroy Object missions if the
  sit rep is active.
* Headshot works now if it's enabled.
* Enemy units should no longer be able to target through walls and other obstructions
  with AoE abilities, like Poison Spit and Micro Missiles.
* Whirlwind on M3 stun lancers now works.
* Hit and Slither on M2 and M3 Sidewinders now works.
* Precision Shot now only costs a single action point with the base Vektor Rifle.
* Incendiary grenades now have a 75% chance to burn regardless of whether thrown or
  launched (via Grenade Launcher). Same applies to the 85% for Fire Bombs. Previously,
  thrown MkI and MkII fire grenades would have 75% chance and launched MkI and MkII fire
  grenades would have 85% chance.

## Modding

* Schematics are no longer disabled by default, so mods that provide them should work
  out of the box. However, in most cases, you should provide `ItemTable` entries for
  them in *XComLW_Overhaul.ini* so that individual items can be built.

# Credits and Acknowledgements

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
