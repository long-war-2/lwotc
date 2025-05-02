//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_SharpshooterAim_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes Aim Confer Bonus crit in addition to bonus aim.
//---------------------------------------------------------------------------------------
class X2Effect_SharpshooterAim_LW extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EventMan.RegisterForEvent(EffectObj, 'AbilityActivated', class'XComGameState_Effect'.static.SharpshooterAimListener, ELD_OnStateSubmitted, , UnitState);
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo_Hit;
	local ShotModifierInfo ShotInfo_Crit;
	if (!bMelee)
	{
		ShotInfo_Hit.ModType = eHit_Success;
		ShotInfo_Hit.Reason = FriendlyName;
		ShotInfo_Hit.Value = class'X2Ability_SharpshooterAbilitySet'.default.SHARPSHOOTERAIM_BONUS;
		ShotModifiers.AddItem(ShotInfo_Hit);

		ShotInfo_Crit.ModType = eHit_Crit;
		ShotInfo_Crit.Reason = FriendlyName;
		ShotInfo_Crit.Value = class'X2Ability_PerkPackAbilitySet'.default.SHARPSHOOTERAIM_CRITBONUS;
		ShotModifiers.AddItem(ShotInfo_Crit);
	}
}

static function X2Effect_SharpshooterAim_LW SharpshooterAimEffect()
{
    local X2Effect_SharpshooterAim_LW   AimEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    AimEffect = new class'X2Effect_SharpshooterAim_LW';
    AimEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
    AimEffect.SetDisplayInfo(ePerkBuff_Bonus,
        class'X2Ability_SharpshooterAbilitySet'.default.SharpshooterAimBonusName,
        class'X2Ability_SharpshooterAbilitySet'.default.SharpshooterAimBonusDesc,
        "img:///UILibrary_PerkIcons.UIPerk_aim");

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('SharpshooterAim');
    AimEffect.TargetConditions.AddItem(AbilityCondition);

    return AimEffect;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Refresh           //  if you keep using hunker down, just extend the lifetime of the effect
	EffectName = "SharpshooterAimBonus"
}