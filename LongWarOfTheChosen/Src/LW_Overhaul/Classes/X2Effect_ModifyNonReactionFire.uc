//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_ModifyNonReactionFire
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up Scope effect
//--------------------------------------------------------------------------------------- 

class X2Effect_ModifyNonReactionFire extends X2Effect_Persistent config(LW_Overhaul);

var int To_Hit_Modifier;
var int Upgrade_Empower_Bonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item				SourceWeapon;
    local ShotModifierInfo					ShotInfo;
	local X2AbilityToHitCalc_StandardAim	StandardToHit;
	local XComGameState_HeadquartersXCom 	XComHQ;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
        StandardToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardToHit != none)
		{
			if (!StandardToHit.bReactionFire)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = To_Hit_Modifier;
				XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
				ShotInfo.Value += (XComHQ.bEmpoweredUpgrades ? Upgrade_Empower_Bonus : 0);
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}