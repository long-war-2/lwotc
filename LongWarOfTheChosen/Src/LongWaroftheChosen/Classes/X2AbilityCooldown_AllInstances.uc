class X2AbilityCooldown_AllInstances extends X2AbilityCooldown;

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability MultAbility;
	local XComGameState_Unit UnitState;
	local int i;

	// For debug only
	if(`CHEATMGR != None && `CHEATMGR.strAIForcedAbility ~= string(kAbility.GetMyTemplateName()))
		iNumTurns = 0;

	if(bDoNotApplyOnHit)
	{
		AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
		if(AbilityContext != None && AbilityContext.IsResultContextHit())
			return;
	}
	
	kAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState); // apply to ability triggering it
	UnitState = XComGameState_Unit(AffectState);
	if(UnitState != none)
	{
		for (i = 0; i < UnitState.Abilities.length; ++i)
		{
			if (UnitState.Abilities[i].ObjectID != kAbility.ObjectID)
			{
				MultAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(UnitState.Abilities[i].ObjectID));
				if (MultAbility != none && MultAbility.GetMyTemplateName() == kAbility.GetMyTemplateName())
				{
					MultAbility = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', MultAbility.ObjectID));
					NewGameState.AddStateObject(MultAbility);
					MultAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);
				}
			}
		}
	}

	ApplyAdditionalCooldown(kAbility, AffectState, AffectWeapon, NewGameState);
}
