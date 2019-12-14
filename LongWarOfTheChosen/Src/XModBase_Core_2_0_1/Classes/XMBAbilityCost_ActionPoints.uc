class XMBAbilityCost_ActionPoints extends X2AbilityCost_ActionPoints implements(XMBOverrideInterface);

// XModBase version
var int MajorVersion, MinorVersion, PatchVersion;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local XComGameStateHistory History;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect PersistentEffect;
	local XMBEffectInterface XModBaseEffect;
	local LWTuple Tuple;
	local int Result, ChangeResult;

	History = `XCOMHISTORY;

	Result = super.GetPointCost(AbilityState, AbilityOwner);

	foreach AbilityOwner.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		PersistentEffect = EffectState.GetX2Effect();
		XModBaseEffect = XMBEffectInterface(PersistentEffect);
		if (XModBaseEffect != none)
		{
			Tuple = new class'LWTuple';
			Tuple.Id = 'GetActionPointCost';
			Tuple.Data.Length = 4;
			Tuple.Data[0].kind = LWTVObject;
			Tuple.Data[0].o = AbilityOwner;
			Tuple.Data[1].kind = LWTVObject;
			Tuple.Data[1].o = AbilityState;
			Tuple.Data[2].kind = LWTVObject;
			Tuple.Data[2].o = EffectState;
			Tuple.Data[3].kind = LWTVInt;
			Tuple.Data[3].i = Result;
			if (XModBaseEffect.GetExtValue(Tuple))
			{
				ChangeResult = Tuple.Data[3].i;
				`log("Effect" @ EffectState.GetX2Effect().FriendlyName @ "changing action point cost of" @ AbilityState.GetMyTemplateName() $ ":" @ ChangeResult);
				Result = ChangeResult;
			}
		}
	}

	return Result;
}

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local XComGameStateHistory History;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect PersistentEffect;
	local XMBEffectInterface XModBaseEffect;
	local LWTuple Tuple;
	local bool Result, ChangeResult;

	History = `XCOMHISTORY;

	Result = super.ConsumeAllPoints(AbilityState, AbilityOwner);

	foreach AbilityOwner.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		PersistentEffect = EffectState.GetX2Effect();
		XModBaseEffect = XMBEffectInterface(PersistentEffect);
		if (XModBaseEffect != none)
		{
			Tuple = new class'LWTuple';
			Tuple.Id = 'GetConsumeAllPoints';
			Tuple.Data.Length = 4;
			Tuple.Data[0].kind = LWTVObject;
			Tuple.Data[0].o = AbilityOwner;
			Tuple.Data[1].kind = LWTVObject;
			Tuple.Data[1].o = AbilityState;
			Tuple.Data[2].kind = LWTVObject;
			Tuple.Data[2].o = EffectState;
			Tuple.Data[3].kind = LWTVInt;
			Tuple.Data[3].i = int(Result);
			if (XModBaseEffect.GetExtValue(Tuple))
			{
				ChangeResult = bool(Tuple.Data[3].i);
				`log("Effect" @ EffectState.GetX2Effect().FriendlyName @ "changing turn-endingness of" @ AbilityState.GetMyTemplateName()  $ ":" @ ChangeResult);
				Result = ChangeResult;
			}
		}
	}

	return Result;
}

// XMBOverrideInterface

function class GetOverrideBaseClass() 
{ 
	return class'X2AbilityCost_ActionPoints';
}

function GetOverrideVersion(out int Major, out int Minor, out int Patch)
{
	Major = MajorVersion;
	Minor = MinorVersion;
	Patch = PatchVersion;
}

function bool GetExtValue(LWTuple Data) { return false; }
function bool SetExtValue(LWTuple Data) { return false; }
