//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_SecondWave
//  AUTHOR:  Grobobobo
//  PURPOSE: Adds a check for Second Waves being enabled
//---------------------------------------------------------------------------------------

class X2Condition_SecondWave extends X2Condition;

var array<name> RequireSecondWavesDisabled;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local name SecondWave;
    foreach RequireSecondWavesDisabled(SecondWave)
    {
        if(`SecondWaveEnabled(SecondWave))
        {
            return 'AA_AbilityUnavailable';
        }

    }
	return 'AA_Success';
}

