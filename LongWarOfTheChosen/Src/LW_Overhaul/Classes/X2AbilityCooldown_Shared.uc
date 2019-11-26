class X2AbilityCooldown_Shared extends X2AbilityCooldown; //Based on X2AbilityCooldown_AllInstances

var() array<name> SharingCooldownsWith; //It might not be the most general or safest implementation, but I don't think we need anything more for now

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability MultAbility;
	local XComGameState_Unit UnitState;
	local int i,j;
	

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
				
				for(j = 0;j < SharingCooldownsWith.length; ++j)
				{
					if (MultAbility != none && MultAbility.GetMyTemplateName() == SharingCooldownsWith[j])
					{
						MultAbility = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', MultAbility.ObjectID));
						MultAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);
					}
				}
			}
		}
	}

	ApplyAdditionalCooldown(kAbility, AffectState, AffectWeapon, NewGameState);
}
