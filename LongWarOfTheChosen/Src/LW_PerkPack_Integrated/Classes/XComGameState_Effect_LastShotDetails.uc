//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_LastShotDetails.uc
//  AUTHOR:  John Lumpkin / Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, storing the details from
//			last shot from the soldier, which can be checked as conditions for perk effects.
//			Used for HyperReactivePupils, 
//---------------------------------------------------------------------------------------

class XComGameState_Effect_LastShotDetails extends XComGameState_Effect config (LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config array<name> SHOTFIRED_ABILITYNAMES;

var bool				b_AnyShotTaken;
var bool				b_LastShotHit;
var XComGameState_Unit	LastShotTarget;
var int					LSTObjID;

static function EventListenerReturn RecordShot(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState								NewGameState;
	local XComGameState_Effect_LastShotDetails		ThisEffect;		
	local XComGameState_Ability						ActivatedAbilityState;
    local XComGameStateContext_Ability				ActivatedAbilityStateContext;
	local XComGameState_Unit						TargetUnit;

	ThisEffect = XComGameState_Effect_LastShotDetails(CallbackData);
	if (ThisEffect == None)
	{
		`REDSCREEN("Wrong callback data passed to XComGameState_Effect_LastShotDetails.RecordShot()");
		return ELR_NoInterrupt;
	}

	ActivatedAbilityState = XComGameState_Ability(EventData);
	if (ActivatedAbilityState != none)
	{
		if (default.SHOTFIRED_ABILITYNAMES.Find(ActivatedAbilityState.GetMyTemplateName()) != -1)
		{
			ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());	
			TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ActivatedAbilityStateContext.InputContext.PrimaryTarget.ObjectID));
			If (TargetUnit != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Gather Shot Details");
				ThisEffect = XComGameState_Effect_LastShotDetails(NewGameState.ModifyStateObject(ThisEffect.Class, ThisEffect.ObjectID));
				ThisEffect.b_AnyShotTaken = true;
				ThisEffect.LastShotTarget = TargetUnit;
				ThisEffect.LSTObjID = TargetUnit.ObjectID;
				`PPTRACE("Record Shot Target:" @ TargetUnit.GetMyTemplateName());
				ThisEffect.b_LastShotHit = !ActivatedAbilityStateContext.IsResultContextMiss();
				`TACTICALRULES.SubmitGameState(NewGameState);    
			}
		}
	}	
	return ELR_NoInterrupt;
}

defaultproperties
{
	bTacticalTransient=true;
}
