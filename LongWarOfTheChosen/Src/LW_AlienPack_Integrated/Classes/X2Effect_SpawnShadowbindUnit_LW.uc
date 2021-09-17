class X2Effect_SpawnShadowbindUnit_LW extends X2Effect_SpawnShadowbindUnit;


function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    
    if(SourceUnit != none)
    {   
        switch(SourceUnit.GetMyTemplateName)
        {
            case 'Spectre':
                return 'ShadowbindUnit';
            case 'SpectreM2':
                return 'ShadowbindUnitM2';
            case 'SpectreM3':
                return 'ShadowbindUnitM3';
        }

    }

	return 'Not Found';
}