//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyKismetVariable.uc
//  AUTHOR:  David Burchanowski  --  8/22/2016
//  PURPOSE: Allows sitreps to modify named kismet variables on the kismet canvas at mission start
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyKismetVariable extends X2SitRepEffectTemplate
	native(Core);

// list of kismet variables to modify.
// these need to be strings, as the script compiler has stricter rules about name characters than the editor does
var array<string> VariableNames;

// these values will modify int kismet variables
var int ValueAdjustment;
var int MinValue;
var int MaxValue;

// these values will modify bool kismet variables
var bool ForceTrue;
var bool ForceFalse;

// uses the values in this template to modify the values on the kismet canvas
native function ModifyKismetVariablesInternal(XComGameState NewGameState);

// applies all sitrep modifications to the kismet canvas and saves thier state data out to the provided game state
static function ModifyKismetVariables()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData BattleData;
	local X2SitRepEffect_ModifyKismetVariable SitRepEffectTemplate;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', false));
	if(BattleData != none) // just in case we don't have one in shipping for some reason
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2SitRepEffect_ModifyKismetVariable::ModifyKismetVariables");
		foreach class'X2SitRepTemplateManager'.static.IterateEffects(class'X2SitRepEffect_ModifyKismetVariable', SitRepEffectTemplate, BattleData.ActiveSitReps)
		{
			SitRepEffectTemplate.ModifyKismetVariablesInternal(NewGameState);
		}

		if(NewGameState.GetNumGameStateObjects() > 0)
		{
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			History.CleanupPendingGameState(NewGameState);
		}
	}
}

defaultproperties
{
	MinValue=-100000
	MaxValue=100000
}
