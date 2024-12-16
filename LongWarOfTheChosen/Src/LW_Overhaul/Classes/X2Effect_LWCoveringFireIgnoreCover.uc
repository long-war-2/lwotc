// Modified version of Iridar's code to buff Covering Fire.

class X2Effect_LWCoveringFireIgnoreCover extends X2Effect_Persistent config(LW_SoldierSkills);

var config int LOW_COVER_AIM_MOD;
var config int HIGH_COVER_AIM_MOD;

var config array<name> AllowedAbilities;
var bool bForThreatAssessment;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{	
	local ShotModifierInfo				ModInfo;
	local GameRulesCache_VisibilityInfo VisInfo;

	if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
		return;

	if (Target.CanTakeCover() && `TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
	{
		switch (VisInfo.TargetCover)
		{
			case CT_MidLevel:
				ModInfo.ModType = eHit_Success;
				ModInfo.Reason = FriendlyName;
				ModInfo.Value = default.LOW_COVER_AIM_MOD;
				ShotModifiers.AddItem(ModInfo);
				break;
			case CT_Standing:
				ModInfo.ModType = eHit_Success;
				ModInfo.Reason = FriendlyName;
				ModInfo.Value = default.HIGH_COVER_AIM_MOD;
				ShotModifiers.AddItem(ModInfo);
				break;
			default:
				break;
		}
	}
}

// If applied by Threat Assessment, remove the effect after it applied once.
function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Effect	AppliedEffectState;
	local XComGameStateHistory	History;
	local StateObjectReference	EffectRef;

	if (!bForThreatAssessment)
		return false;

	// Special handle Pistol Return Fire, which is triggered by Threat Assessment applied to Sharpshooters
	// We don't want PistolReturnFire in AllowedAbilities, because PistolReturnFire is already set to ignore cover defense elsewhere.
	if (AllowedAbilities.Find(AbilityContext.InputContext.AbilityTemplateName) == INDEX_NONE && 
		AbilityContext.InputContext.AbilityTemplateName != 'PistolReturnFire') 
		return false;

	// don't remove it if we still have more Overwatch to do.
	if(SourceUnit.ReserveActionPoints.Length > 0)
		return false;

	// Remove any instances of Threat Assessment applied by the same ability (aid protocol) as this effect
	History = `XCOMHISTORY;
	foreach SourceUnit.AffectedByEffects(EffectRef)
	{
		AppliedEffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (AppliedEffectState == none || AppliedEffectState.bRemoved)
			continue;

		// X2Effect_ThreatAssessment is just X2Effect_CoveringFire that grants overwatch AP
		if (X2Effect_ThreatAssessment(AppliedEffectState.GetX2Effect()) == none)
			continue;

		if (AppliedEffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID != EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)
			continue;

		AppliedEffectState.RemoveEffect(NewGameState, NewGameState, true);
	}

	EffectState.RemoveEffect(NewGameState, NewGameState, true);

	return false;
}

function bool UniqueToHitModifiers() 
{
	return true; 
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "IRI_X2Effect_SP_CoveringFireIgnoreCover_Effect"
}