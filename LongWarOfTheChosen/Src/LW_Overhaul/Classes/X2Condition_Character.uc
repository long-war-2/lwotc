//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Character.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Condition based on units' character templates
//---------------------------------------------------------------------------------------
class X2Condition_Character extends X2Condition;

// Use *either* an inclusion list or an exclusion list, not both. If
// both are provided, the inclusion list takes precedence and the
// exclusion list is basically ignored.
var array<name> IncludeCharacterTemplates;
var array<name> ExcludeCharacterTemplates;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
	{
		return 'AA_NotAUnit';
	}

	if (IncludeCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{
		return 'AA_Success';
	}

	if (ExcludeCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{
		return 'AA_UnitIsWrongType';
	}

	if (IncludeCharacterTemplates.Length > 0)
	{
		return 'AA_UnitIsWrongType';
	}
	else
	{
		// Assume the exclusion list is not empty, but there was no match,
		// so this character template is fine.
		return 'AA_Success';
	}
}
