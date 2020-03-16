class X2Effect_Sustain_LW extends X2Effect_Sustain;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local X2EventManager EventMan;
	local UnitValue SustainValue;
	local int Index, PercentChance, RandRoll;
    local UnitValue OverKillDamage;
	if( !UnitState.IsAbleToAct(true) )
	{
		// Stunned units may not go into Sustain
		return false;
	}

	if (UnitState.GetUnitValue(default.SustainUsed, SustainValue))
	{
		if (SustainValue.fValue > 0)
			return false;
    }
        
    UnitState.GetUnitValue('OverKillDamage', OverKillDamage);

	Index = default.SUSTAINTRIGGERUNITCHECK_ARRAY.Find('UnitType', UnitState.GetMyTemplateName());

	// If the Unit Type is not in the array, then it always triggers sustain
	if (Index != INDEX_NONE)
	{
		PercentChance = 100 - (default.SUSTAINTRIGGERUNITCHECK_ARRAY[Index].PercentChance * OverKillDamage.fValue);

		RandRoll = `SYNC_RAND(100);
		if (RandRoll >= PercentChance)
		{
			// RandRoll is greater or equal to the percent chance, so sustain failed
			return false;
		}
	}

	UnitState.SetUnitFloatValue(default.SustainUsed, 1, eCleanup_BeginTactical);
	UnitState.SetCurrentStat(eStat_HP, 1);
	EventMan = `XEVENTMGR;
	EventMan.TriggerEvent(default.SustainEvent, UnitState, UnitState, NewGameState);
	return true;
}

function bool PreBleedoutCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return PreDeathCheck(NewGameState, UnitState, EffectState);
}
