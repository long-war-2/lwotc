class XGAIBehavior_Civilian_LW extends XGAIBehavior_Civilian;

function BTRunCompletePreExecute()
{
	local AvailableAction YellAction;
	local int TargetIndex;
	//super.BTRunCompletePreExecute();
    
    // LWS Add: Configurable disabling of civilian yell
    if (!class'Helpers_LW'.default.EnableCivilianYellOnPreMove)
        return;

	if( !m_kPlayer.bCiviliansTargetedByAliens )
	{
		// Yell before moving.
		YellAction = FindAbilityByName('Yell');
		if( YellAction.AbilityObjectRef.ObjectID > 0 && YellAction.AvailableCode == 'AA_Success' )
		{
			if( YellAction.AvailableTargets.Length == 0 )
			{
				TargetIndex = INDEX_NONE;
			}
			class'XComGameStateContext_Ability'.static.ActivateAbility(YellAction, TargetIndex);
		}
	}
}