//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_ShotHUD
//	Author: tjnome, GrimyBunyip
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_ShotHUD extends UITacticalHUD_ShotHUD config(PerfectInformation);
 
var config bool SHOW_AIM_ASSIST_MAIN_HUD;
var config bool SHOW_MISS_CHANCE_MAIN_HUD;


 
var UIBGBox GrimyBox1, GrimyBox2, GrimyBox3, GrimyBox4, GrimyBox5;
var UIText GrimyTextDodge, GrimyTextDodgeHeader, GrimyTextCrit, GrimyTextCritHeader, GrimyTextHitChance, GrimyTextHitChanceHeader;
var config int BAR_HEIGHT, BAR_OFFSET_X, BAR_OFFSET_Y, BAR_ALPHA, BAR_WIDTH_MULT, DODGE_ALPHA;
var config int DODGE_OFFSET_X, DODGE_OFFSET_Y, CRIT_OFFSET_X, CRIT_OFFSET_Y;
var config string HIT_HEX_COLOR, CRIT_HEX_COLOR, DODGE_HEX_COLOR, MISS_HEX_COLOR;
var config bool PREVIEW_MINIMUM, AIM_LEFT_OF_CRIT, SHOW_DODGE, SHOW_CRIT_DMG, PREVIEW_HACKING;
 
simulated function Update()
{
    local bool isValidShot;
    local string ShotName, ShotDescription, ShotDamage;
    local int HitChance, CritChance, TargetIndex, MinDamage, MaxDamage, AllowsShield;
    local ShotBreakdown kBreakdown;
    local StateObjectReference Shooter, Target, EmptyRef;
    local XComGameState_Ability SelectedAbilityState;
    local X2AbilityTemplate SelectedAbilityTemplate;
    local AvailableAction SelectedUIAction;
    local AvailableTarget kTarget;
    local XGUnit ActionUnit;
    local UITacticalHUD TacticalHUD;
    local UIUnitFlag UnitFlag;
    local WeaponDamageValue MinDamageValue, MaxDamageValue;
    local X2TargetingMethod TargetingMethod;
    local bool WillBreakConcealment, WillEndTurn;
	local XComGameStateHistory History;
   
    // New from Grimy Shot Bar
	local int MissChance, GrazeChance;
	local int SomeDamageHitChance;

	local int GrimyHitChance, GrimyCritChance, GrimyCritDmg;
	local int GrimyMissChance, GrimyGrazeChance;
	local int GrimyFullDamageHitChance;

    local int GrimyHitWidth, GrimyCritWidth, GrimyGrazeWidth, GrimyMissWidth,GrimyFullDamageHitWidth;
    local string FontString;
	
	local string HIT_TEXT; //VBN

   
    TacticalHUD = UITacticalHUD(Screen);
 
    // Remove the shotbar box when you aren't looking at it
    if ( GrimyBox1 == none ) {
		GrimyBox1 = Spawn(class'UIBGBox', self);
		GrimyBox1.InitBG('GrimyBox1').SetBGColor("gray");
		GrimyBox1.SetColor(HIT_HEX_COLOR);
		GrimyBox1.SetHighlighed(true);
		GrimyBox1.AnchorBottomCenter();
		GrimyBox1.SetAlpha(default.BAR_ALPHA);
    }
    if ( GrimyBox2 == none ) {
        GrimyBox2 = Spawn(class'UIBGBox', self);
        GrimyBox2.InitBG('GrimyBox2').SetBGColor("gray");
        GrimyBox2.SetColor(DODGE_HEX_COLOR);
        GrimyBox2.SetHighlighed(true);
        GrimyBox2.AnchorBottomCenter();
        GrimyBox2.SetAlpha(default.DODGE_ALPHA);
    }
    if ( GrimyBox3 == none ) {
		GrimyBox3 = Spawn(class'UIBGBox', self);
        GrimyBox3.InitBG('GrimyBox3').SetBGColor("gray");
        GrimyBox3.SetColor(CRIT_HEX_COLOR);
        GrimyBox3.SetHighlighed(true);
        GrimyBox3.AnchorBottomCenter();
        GrimyBox3.SetAlpha(default.BAR_ALPHA);
    }
    if ( GrimyBox4 == none ) {
        GrimyBox4 = Spawn(class'UIBGBox', self);
        GrimyBox4.InitBG('GrimyBox4').SetBGColor("gray");
        GrimyBox4.SetColor(MISS_HEX_COLOR);
        GrimyBox4.SetHighlighed(true);
        GrimyBox4.AnchorBottomCenter();
        GrimyBox4.SetAlpha(default.BAR_ALPHA);
    }
	

    if ( GrimyTextDodge == none ) {
        GrimyTextDodge = Spawn(class'UIText', self);
        GrimyTextDodge.InitText('GrimyText1');
        GrimyTextDodge.AnchorBottomCenter();
    }
    if ( GrimyTextDodgeHeader == none ) {
		GrimyTextDodgeHeader = Spawn(class'UIText', self);
		GrimyTextDodgeHeader.InitText('GrimyText2');
		GrimyTextDodgeHeader.AnchorBottomCenter();
    }

    if ( GrimyTextCrit == none ) {
        GrimyTextCrit = Spawn(class'UIText', self);
        GrimyTextCrit.InitText('GrimyText3');
        GrimyTextCrit.AnchorBottomCenter();
    }
    if ( GrimyTextCritHeader == none ) {
        GrimyTextCritHeader = Spawn(class'UIText', self);
        GrimyTextCritHeader.InitText('GrimyText4');
        GrimyTextCritHeader.AnchorBottomCenter();
    }

	GrimyBox1.Hide();
	GrimyBox2.Hide();
	GrimyBox3.Hide();
	GrimyBox4.Hide();
	GrimyTextDodge.Hide();
	GrimyTextDodgeheader.Hide();
	GrimyTextCrit.Hide();
	GrimyTextCritHeader.Hide();
	 
    SelectedUIAction = TacticalHUD.GetSelectedAction();
    if (SelectedUIAction.AbilityObjectRef.ObjectID > 0) //If we do not have a valid action selected, ignore this update request
    {
		History = `XCOMHISTORY;

        SelectedAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SelectedUIAction.AbilityObjectRef.ObjectID));
        SelectedAbilityTemplate = SelectedAbilityState.GetMyTemplate();
        ActionUnit = XGUnit(`XCOMHISTORY.GetGameStateForObjectID(SelectedAbilityState.OwnerStateObject.ObjectID).GetVisualizer());
        TargetingMethod = TacticalHUD.GetTargetingMethod();
        if( TargetingMethod != None )
        {
            TargetIndex = TargetingMethod.GetTargetIndex();
            if( SelectedUIAction.AvailableTargets.Length > 0 && TargetIndex < SelectedUIAction.AvailableTargets.Length )
                kTarget = SelectedUIAction.AvailableTargets[TargetIndex];
        }
 
        //Update L3 help and OK button based on ability.
        //*********************************************************************************
        if (SelectedUIAction.bFreeAim)
        {
            AS_SetButtonVisibility(Movie.IsMouseActive(), false);
            isValidShot = true;
        }
        else if (SelectedUIAction.AvailableTargets.Length == 0 || SelectedUIAction.AvailableTargets[0].PrimaryTarget.ObjectID < 1)
        {
            AS_SetButtonVisibility(Movie.IsMouseActive(), false);
            isValidShot = false;
        }
        else
        {
            AS_SetButtonVisibility(Movie.IsMouseActive(), Movie.IsMouseActive());
            isValidShot = true;
        }
 
        //Set shot name / help text
        //*********************************************************************************
        ShotName = SelectedAbilityState.GetMyFriendlyName(kTarget.PrimaryTarget);
 
        if (SelectedUIAction.AvailableCode == 'AA_Success')
        {
            ShotDescription = SelectedAbilityState.GetMyHelpText();
            if (ShotDescription == "") ShotDescription = "Missing 'LocHelpText' from ability template.";
        }
        else
        {
			if (SelectedUIAction.AvailableCode == 'AA_AbilityUnavailable')
			{
				ShotDescription = SelectedAbilityState.GetMyHelpText();
			}
			else
			{
				ShotDescription = class'X2AbilityTemplateManager'.static.GetDisplayStringForAvailabilityCode(SelectedUIAction.AvailableCode);
			}

			if (ShotDescription == "") 
			{
				ShotDescription = "Missing 'LocHelpText' from ability template.";
			}
        }
 
 
        WillBreakConcealment = SelectedAbilityState.MayBreakConcealmentOnActivation(kTarget.PrimaryTarget.ObjectID);
        WillEndTurn = SelectedAbilityState.WillEndTurn();
 
        AS_SetShotInfo(ShotName, ShotDescription, WillBreakConcealment, WillEndTurn);
 
        // Display Hack Info if relevant
        AS_SetShotInfo(ShotName, UpdateHackDescription(SelectedAbilityTemplate, SelectedAbilityState, kTarget, ShotDescription, SelectedAbilityState.OwnerStateObject), WillBreakConcealment, WillEndTurn);
 
        // Disable Shot Button if we don't have a valid target.
        AS_SetShotButtonDisabled(!isValidShot);
 
        ResetDamageBreakdown();
 
        // In the rare case that this ability is self-targeting, but has a multi-target effect on units around it,
        // look at the damage preview, just not against the target (self).
        if( SelectedAbilityTemplate.AbilityTargetStyle.IsA('X2AbilityTarget_Self')
           && SelectedAbilityTemplate.AbilityMultiTargetStyle != none
           && SelectedAbilityTemplate.AbilityMultiTargetEffects.Length > 0 )
        {
            SelectedAbilityState.GetDamagePreview(EmptyRef, MinDamageValue, MaxDamageValue, AllowsShield);
        }
        else
        {
            SelectedAbilityState.GetDamagePreview(kTarget.PrimaryTarget, MinDamageValue, MaxDamageValue, AllowsShield);
        }
        MinDamage = MinDamageValue.Damage;
        MaxDamage = MaxDamageValue.Damage;
       
        if (MinDamage > 0 && MaxDamage > 0)
        {
            if (MinDamage == MaxDamage)
                ShotDamage = String(MinDamage);
            else
                ShotDamage = MinDamage $ "-" $ MaxDamage;
 
            if( MinDamageValue.BonusDamageInfo.Length > 0 || MaxDamageValue.BonusDamageInfo.Length > 0 )
			{
				AddDamage(class'UIUtilities_Text'.static.GetColoredText(ShotDamage, eUIState_Warning2, 38), true);
			}
			else
			{
				AddDamage(class'UIUtilities_Text'.static.GetColoredText(ShotDamage, eUIState_Good, 36), true);
			}
        }
 
        //Set up percent to hit / crit values
        //*********************************************************************************
       
        if (SelectedAbilityTemplate.AbilityToHitCalc != none && SelectedAbilityState.iCooldown == 0)
        {
            Shooter = SelectedAbilityState.OwnerStateObject;
            Target = kTarget.PrimaryTarget;
 
            SelectedAbilityState.LookupShotBreakdown(Shooter, Target, SelectedAbilityState.GetReference(), kBreakdown);

			HitChance = kBreakdown.ResultTable[eHit_Success];
			MissChance = kBreakdown.ResultTable[eHit_Miss]; 
			CritChance = kBreakdown.ResultTable[eHit_Crit];
			GrazeChance = kBreakdown.ResultTable[eHit_Graze];

			SomeDamageHitChance = Clamp((kBreakdown.bIsMultishot ? kBreakdown.MultiShotHitChance : HitChance + CritChance + GrazeChance), 0, 100);


			//----------------------//
           
		    GrimyHitChance = kBreakdown.ResultTable[eHit_Success];
			GrimyMissChance = kBreakdown.ResultTable[eHit_Miss];
			GrimyCritChance = kBreakdown.ResultTable[eHit_Crit];
            GrimyGrazeChance = kBreakdown.ResultTable[eHit_Graze];

			GrimyFullDamageHitChance = ((kBreakdown.bIsMultishot) ? kBreakdown.MultiShotHitChance : kBreakdown.ResultTable[eHit_Success] + kBreakdown.ResultTable[eHit_Crit]);
		

            //Check for standarshot
            if (X2AbilityToHitCalc_StandardAim(SelectedAbilityState.GetMyTemplate().AbilityToHitCalc) != None && SHOW_AIM_ASSIST_MAIN_HUD)
            {
                HitChance += XCom_Perfect_Information_UITacticalHUD_ShotWings(UITacticalHUD(Screen).m_kShotInfoWings).GetModifiedHitChance(SelectedAbilityState, HitChance);
                GrimyHitChance += XCom_Perfect_Information_UITacticalHUD_ShotWings(UITacticalHUD(Screen).m_kShotInfoWings).GetModifiedHitChance(SelectedAbilityState, HitChance);
            }          
 
            // Start of Grimy Shot Bar Code
 
            if (HitChance > -1 && !kBreakdown.HideShotBreakdown)
            {
				if (SHOW_MISS_CHANCE_MAIN_HUD)
                    SomeDamageHitChance = 100 - SomeDamageHitChance;

				if ( GrimyFullDamageHitChance > 100 )
				{
					GrimyGrazeChance = clamp(GrimyGrazeChance - (GrimyFullDamageHitChance - 100),0,100);
				}
				GrimyCritChance = clamp(GrimyCritChance,0,GrimyHitChance-GrimyGrazeChance);

				// Generate a display for dodge chance
				if ( default.SHOW_DODGE && GrimyGrazeChance > 0 )
				{
					FontString = string(GrimyGrazeChance) $ "%";
					FontString = class'UIUtilities_Text'.static.GetSizedText(FontString,28);
					FontString = class'UIUtilities_Text'.static.GetColoredText(FontString,eUIState_Normal);
					FontString = class'UIUtilities_Text'.static.AddFontInfo(FontString,false,true);
					GrimyTextDodge.SetPosition(default.DODGE_OFFSET_X,default.DODGE_OFFSET_Y);
					GrimyTextDodge.SetText(FontString);
					GrimyTextDodge.Show();

					//FontString = "DODGE"; //VBN disabled because of graze lw2
					FontString = "GRAZE";
					FontString = class'UIUtilities_Text'.static.GetSizedText(FontString,19);
					FontString = class'UIUtilities_Text'.static.GetColoredText(FontString,eUIState_Header);
					GrimyTextDodgeHeader.SetPosition(default.DODGE_OFFSET_X,default.DODGE_OFFSET_Y-22);
					GrimyTextDodgeHeader.SetText(FontString);
					GrimyTextDodgeHeader.Show();
				}


				// Generate a display for Crit Damage
				GrimyCritDmg = GetCritDamage(SelectedAbilityState, Target);
				if ( default.SHOW_CRIT_DMG && GrimyCritDmg > 0 )
				{
					FontString = "+" $ string(GrimyCritDmg);
					FontString = class'UIUtilities_Text'.static.GetSizedText(FontString,28);
					FontString = class'UIUtilities_Text'.static.GetColoredText(FontString,eUIState_Normal);
					FontString = class'UIUtilities_Text'.static.AddFontInfo(FontString,false,true);
					if ( GrimyCritDmg > 9 ) //If the string is too long, shift it left by 15 pixels (~1 digit)
					{
						GrimyTextCrit.SetPosition(default.CRIT_OFFSET_X,default.CRIT_OFFSET_Y);
					}
					else
					{
						GrimyTextCrit.SetPosition(default.CRIT_OFFSET_X+15,default.CRIT_OFFSET_Y);
					}
					GrimyTextCrit.SetText(FontString);
					GrimyTextCrit.Show();

					FontString = "CRIT.DMG";
					FontString = class'UIUtilities_Text'.static.GetSizedText(FontString,19);
					FontString = class'UIUtilities_Text'.static.GetColoredText(FontString,eUIState_Header);
					GrimyTextCritHeader.SetPosition(default.CRIT_OFFSET_X,default.CRIT_OFFSET_Y-22);
					GrimyTextCritHeader.SetText(FontString);
					GrimyTextCritHeader.Show();
				}

				GrimyHitWidth = default.BAR_WIDTH_MULT * ( clamp( GrimyHitChance, 0, 100 ) );
				GrimyFullDamageHitWidth = default.BAR_WIDTH_MULT * ( clamp( GrimyFullDamageHitChance, 0, 100 ) );
				GrimyCritWidth = default.BAR_WIDTH_MULT * GrimyCritChance;
				GrimyGrazeWidth = default.BAR_WIDTH_MULT * GrimyGrazeChance;
				GrimyMissWidth = default.BAR_WIDTH_MULT * ( 100 - GrimyFullDamageHitChance - GrimyGrazeChance);
				
				// Generate the shot breakdown bar
                if ( default.BAR_HEIGHT > 0 )
                {
                    if ( GrimyHitWidth > 0 )
                    {
                        if ( default.AIM_LEFT_OF_CRIT )
                        {
							GrimyBox1.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X,default.BAR_OFFSET_Y);
						}
                        else
                        {
							GrimyBox1.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X + GrimyCritWidth,default.BAR_OFFSET_Y);
						}
						GrimyBox1.SetSize(GrimyHitWidth,default.BAR_HEIGHT);
						GrimyBox1.Show();
					}

                    if ( GrimyGrazeWidth > 0 )
                    {
                        if ( default.AIM_LEFT_OF_CRIT )
                        {
							GrimyBox2.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X + GrimyHitWidth,default.BAR_OFFSET_Y);
						}
                        else
                        {
							GrimyBox2.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X + GrimyCritWidth + GrimyHitWidth,default.BAR_OFFSET_Y);
						}
						GrimyBox2.SetSize(GrimyGrazeWidth,default.BAR_HEIGHT);
						GrimyBox2.Show();
					}

					if ( GrimyCritWidth > 0 )
					{	
                        if ( default.AIM_LEFT_OF_CRIT )
                        {
                            GrimyBox3.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X + GrimyHitWidth + GrimyGrazeWidth,default.BAR_OFFSET_Y);
                        }
                        else
                        {
                            GrimyBox3.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X,default.BAR_OFFSET_Y);
                        }
						GrimyBox3.SetSize(GrimyCritWidth,default.BAR_HEIGHT);
						GrimyBox3.Show();
					}

					if ( GrimyMissWidth > 0 && GrimyMissWidth < 500 )
					{
						GrimyBox4.SetPosition(default.BAR_WIDTH_MULT * (-50) + default.BAR_OFFSET_X + GrimyHitWidth + GrimyCritWidth + GrimyGrazeWidth,default.BAR_OFFSET_Y);
						GrimyBox4.SetSize(GrimyMissWidth,default.BAR_HEIGHT);
						GrimyBox4.Show();
					}
				}

				//AS_SetShotChance(class'UIUtilities_Text'.static.GetColoredText(m_sShotChanceLabel, eUIState_Header), HitChance); VBN
				// AS_SetCriticalChance(class'UIUtilities_Text'.static.GetColoredText(m_sCritChanceLabel, eUIState_Header), CritChance); ; VBN

				AS_SetShotChance(class'UIUtilities_Text'.static.GetColoredText(m_sShotChanceLabel, eUIState_Header), SomeDamageHitChance);
				AS_SetCriticalChance(class'UIUtilities_Text'.static.GetColoredText(kBreakdown.SpecialCritLabel == "" ? m_sCritChanceLabel : kBreakdown.SpecialCritLabel, eUIState_Header), CritChance);
				TacticalHUD.SetReticleAimPercentages(float(SomeDamageHitChance) / 100.0f, float(CritChance) / 100.0f);
            }
            else
            {
                AS_SetShotChance("", -1);
                AS_SetCriticalChance("", -1);
                TacticalHUD.SetReticleAimPercentages(-1, -1);
            }
        }
        else
        {
            AS_SetShotChance("", -1);
            AS_SetCriticalChance("", -1);
        }
        TacticalHUD.m_kShotInfoWings.Show();
 
        //Show preview points, must be negative
        UnitFlag = XComPresentationLayer(Owner.Owner).m_kUnitFlagManager.GetFlagForObjectID(Target.ObjectID);
        if( UnitFlag != none )
        {
            // if ( default.PREVIEW_MINIMUM )
            // {
            //     SetAbilityMinDamagePreview(UnitFlag, SelectedAbilityState, kTarget.PrimaryTarget);
            // }
            // else
            // {
                XComPresentationLayer(Owner.Owner).m_kUnitFlagManager.SetAbilityDamagePreview(UnitFlag, SelectedAbilityState, kTarget.PrimaryTarget);
            // }
        }
 
        //@TODO - jbouscher - ranges need to be implemented in a template friendly way.
        //Hide any current range meshes before we evaluate their visibility state
        if (!ActionUnit.GetPawn().RangeIndicator.HiddenGame)
        {
            ActionUnit.RemoveRanges();
        }
    }
 
    if (`REPLAY.bInTutorial)
    {
        if (SelectedAbilityTemplate != none && `TUTORIAL.IsNextAbility(SelectedAbilityTemplate.DataName) && `TUTORIAL.IsTarget(Target.ObjectID))
        {
            ShowShine();
        }
        else
        {
            HideShine();
        }
    }
	RefreshTooltips();
}
 
// GRIMY - Added this function to calculate crit damage from a weapon.
// It doesn't scan for abilities and ammo types though, those are unfortunately often stored in if conditions
static function int GetCritDamage(XcomGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local XComGameState_Item ItemState;
	local X2Effect_Persistent EffectTemplate;
	local EffectAppliedData TestEffectParams;
	local int CritDamage;
	local WeaponDamageValue WeaponDamage;
	
	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));

	TestEffectParams.AbilityInputContext.AbilityRef = AbilityState.GetReference();
	TestEffectParams.AbilityInputContext.AbilityTemplateName = AbilityState.GetMyTemplateName();
	TestEffectParams.ItemStateObjectRef = AbilityState.SourceWeapon;
	TestEffectParams.AbilityStateObjectRef = AbilityState.GetReference();
	TestEffectParams.SourceStateObjectRef = SourceUnit.GetReference();
	TestEffectParams.PlayerStateObjectRef = SourceUnit.ControllingPlayer;
	TestEffectParams.TargetStateObjectRef = TargetRef;
	TestEffectParams.AbilityResultContext.HitResult = eHit_Crit;

	ItemState = AbilityState.GetSourceWeapon();
	ItemState.GetBaseWeaponDamageValue(ItemState, WeaponDamage);
	CritDamage = WeaponDamage.Crit;
	foreach SourceUnit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		EffectTemplate = EffectState.GetX2Effect();

		CritDamage += EffectTemplate.GetAttackingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, WeaponDamage.Damage);
	}
    return CritDamage;
}
 
// GRIMY - Added this to do a minimum damage preview.
// Recreated the preview function in order to minimize # of files edited, and thus conflicts
static function SetAbilityMinDamagePreview(UIUnitFlag kFlag, XComGameState_Ability AbilityState, StateObjectReference TargetObject)
{
    local XComGameState_Unit FlagUnit;
    local int shieldPoints, AllowedShield;
    local int possibleHPDamage, possibleShieldDamage;
    local WeaponDamageValue MinDamageValue;
    local WeaponDamageValue MaxDamageValue;
 
    if(kFlag == none || AbilityState == none)
    {
        return;
    }
 
    AbilityState.GetDamagePreview(TargetObject, MinDamageValue, MaxDamageValue, AllowedShield);
 
    FlagUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kFlag.StoredObjectID));
    shieldPoints = FlagUnit != none ? int(FlagUnit.GetCurrentStat(eStat_ShieldHP)) : 0;
 
    possibleHPDamage = MinDamageValue.Damage;
    possibleShieldDamage = 0;
 
    // MaxHP contains extra HP points given by shield
    if(shieldPoints > 0 && AllowedShield > 0)
    {
        possibleShieldDamage = min(shieldPoints, MinDamageValue.Damage);
        possibleShieldDamage = min(possibleShieldDamage, AllowedShield);
        possibleHPDamage = MinDamageValue.Damage - possibleShieldDamage;
    }
 
    if (!AbilityState.DamageIgnoresArmor() && FlagUnit != none)
        possibleHPDamage -= max(0,FlagUnit.GetArmorMitigationForUnitFlag() - MinDamageValue.Pierce);
 
    kFlag.SetShieldPointsPreview( possibleShieldDamage );
    kFlag.SetHitPointsPreview( possibleHPDamage );
    kFlag.SetArmorPointsPreview(MinDamageValue.Shred, MinDamageValue.Pierce);
}
 
static function string UpdateHackDescription( X2AbilityTemplate SelectedAbilityTemplate, XComGameState_Ability SelectedAbilityState, AvailableTarget kTarget, string ShotDescription, StateObjectReference Shooter)
{
    local string FontString;
    local XComGameState_InteractiveObject HackObject;
    local XComGameState_Unit HackUnit;
    local X2HackRewardTemplateManager HackManager;
    local array<name> HackRewards;
    local int HackOffense, HackDefense;
    local array<X2HackRewardTemplate> HackRewardTemplates;
    local X2HackRewardTemplate HackRewardInterator;
    local array<int> HackRollMods;
 
    if ( default.PREVIEW_HACKING )
    {
        if ( SelectedAbilityTemplate.DataName == 'IntrusionProtocol' || SelectedAbilityTemplate.DataName == 'IntrusionProtocol_Chest' || SelectedAbilityTemplate.DataName == 'IntrusionProtocol_Workstation' || SelectedAbilityTemplate.DataName == 'IntrusionProtocol_ObjectiveChest' || SelectedAbilityTemplate.DataName == 'SKULLJACKAbility' || SelectedAbilityTemplate.DataName == 'SKULLMINEAbility' )
        {
            HackObject = XComGameState_InteractiveObject(`XCOMHISTORY.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
            HackRewards = HackObject.GetHackRewards(SelectedAbilityTemplate.DataName);
            if ( HackRewards.Length > 0 )
            {
                HackManager = class'X2HackRewardTemplateManager'.static.GetHackRewardTemplateManager();
                HackRewardTemplates.additem(HackManager.FindHackRewardTemplate(HackRewards[0]));
                HackRewardTemplates.additem(HackManager.FindHackRewardTemplate(HackRewards[1]));
                HackRewardTemplates.additem(HackManager.FindHackRewardTemplate(HackRewards[2]));
               
                HackOffense = class'X2AbilityToHitCalc_Hacking'.static.GetHackAttackForUnit(XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Shooter.ObjectID)), SelectedAbilityState);
                HackDefense = class'X2AbilityToHitCalc_Hacking'.static.GetHackDefenseForTarget(HackObject);
               
                HackRollMods = HackObject.GetHackRewardRollMods();
                if ( HackRollMods.length == 0 )
                {
                    foreach HackRewardTemplates(HackRewardInterator)
                    {
                        HackRollMods.AddItem(`SYNC_RAND_STATIC(HackRewardInterator.HackSuccessVariance * 2) - HackRewardInterator.HackSuccessVariance);
                    }
                    HackObject.SetHackRewardRollMods(HackRollMods);
                }
                   
                FontString = ShotDescription;
                FontString = FontString $ "\n" $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[0].GetFriendlyName(),eUIState_Bad);
                FontString = FontString $ " - " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[1].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[1].MinHackSuccess + HackObject.HackRollMods[1])) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                FontString = FontString $ ", " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[2].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[2].MinHackSuccess + HackObject.HackRollMods[2])) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                return FontString;
            }
        }
        else if ( SelectedAbilityTemplate.DataName == 'HaywireProtocol' )
        {
            HackUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
               
            HackOffense = class'X2AbilityToHitCalc_Hacking'.static.GetHackAttackForUnit(XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Shooter.ObjectID)), SelectedAbilityState);
            HackDefense = class'X2AbilityToHitCalc_Hacking'.static.GetHackDefenseForTarget(HackUnit);
 
            HackManager = class'X2HackRewardTemplateManager'.static.GetHackRewardTemplateManager();
           
            if ( HackUnit.GetMyTemplate().bIsTurret )
            {
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('BuffEnemy'));
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('ShutdownTurret'));
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('ControlTurret'));
 
                HackRollMods = HackObject.GetHackRewardRollMods();
                if ( HackRollMods.length == 0 )
                {
                    foreach HackRewardTemplates(HackRewardInterator)
                    {
                        HackRollMods.AddItem(`SYNC_RAND_STATIC(HackRewardInterator.HackSuccessVariance * 2) - HackRewardInterator.HackSuccessVariance);
                    }
                    HackObject.SetHackRewardRollMods(HackRollMods);
                }
 
                FontString = ShotDescription;
                FontString = FontString $ "\n" $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[0].GetFriendlyName(),eUIState_Bad);
                FontString = FontString $ " - " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[1].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[1].MinHackSuccess)) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                FontString = FontString $ ", " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[2].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[2].MinHackSuccess + HackObject.HackRollMods[2])) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                return FontString;
            }
            else
            {
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('BuffEnemy'));
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('ShutdownRobot'));
                HackRewardTemplates.AddItem(HackManager.FindHackRewardTemplate('ControlRobot'));
 
                HackRollMods = HackObject.GetHackRewardRollMods();
                if ( HackRollMods.length == 0 )
                {
                    foreach HackRewardTemplates(HackRewardInterator)
                    {
                        HackRollMods.AddItem(`SYNC_RAND_STATIC(HackRewardInterator.HackSuccessVariance * 2) - HackRewardInterator.HackSuccessVariance);
                    }
                    HackObject.SetHackRewardRollMods(HackRollMods);
                }
 
                FontString = ShotDescription;
                FontString = FontString $ "\n" $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[0].GetFriendlyName(),eUIState_Bad);
                FontString = FontString $ " - " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[1].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[1].MinHackSuccess + HackObject.HackRollMods[1])) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                FontString = FontString $ ", " $ class'UIUtilities_Text'.static.GetColoredText(HackRewardTemplates[2].GetFriendlyName(),eUIState_Good);
                FontString = FontString $ ": " $ class'UIUtilities_Text'.static.GetColoredText( string(Clamp((100.0 - (HackRewardTemplates[2].MinHackSuccess + HackObject.HackRollMods[2])) * HackOffense / HackDefense, 0.0, 100.0)) $ "%", eUIState_Good);
                return FontString;
            }
        }
    }
    return ShotDescription;
}