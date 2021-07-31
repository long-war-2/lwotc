class X2Effect_SwitchToRobot_LW extends X2Effect_SwitchToRobot;


function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    
    if(SourceUnit != none)
    {   
        switch(SourceUnit.GetMyTemplateName)
        {
            case 'Andromedon':
                return 'AndromedonRobot';
            case 'AndromedonM2':
                return 'AndromedonRobotM2';
            case 'AndromedonM3':
                return 'AndromedonRobotM3';
        }

    }

	return 'Not Found';
}
defaultproperties
{
}