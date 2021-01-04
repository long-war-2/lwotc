//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LoneWolf
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up aim and defense bonuses for LW
//--------------------------------------------------------------------------------------- 

class X2Effect_LoneWolf extends X2Effect_Persistent config (LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config int LONEWOLF_AIM_PER_TILE;
var config int LONEWOLF_DEF_PER_TILE;
var config int LONEWOLF_AIM_BONUS;
var config int LONEWOLF_DEF_BONUS;
var config int LONEWOLF_CRIT_BONUS;
var config int LONEWOLF_MIN_DIST_TILES;

function int NearestAllyBeyondRange(XComGameState_Unit LWUnit)
{
	local XComGameState_Unit TestAlly;
	local XComUnitPawn	TestAllyPawn;
	local XGUnit TestAllyVisualizer;
	local int NearestAllyTiles;

	NearestAllyTiles = default.LONEWOLF_MIN_DIST_TILES + 1;

	foreach `XCOMHISTORY.IterateByClassType (class'XComGameState_Unit', TestAlly)
	{
		if (LWUnit == none || TestAlly == none) { continue; }
		if (LWUnit == TestAlly) { continue; }

		TestAllyVisualizer = XGUnit(TestAlly.GetVisualizer());
		if (TestAllyVisualizer == none) { continue; }

		TestAllyPawn = TestAllyVisualizer.GetPawn();
		if (TestAllyPawn == none) { continue; }
		if (TestAlly.IsAlive() &&
			!TestAlly.GetMytemplate().bIsCosmetic)
		{
			if (!TestAlly.bRemovedFromPlay)
			{
				if (!TestAlly.IsBleedingOut())
				{
					if (LWUnit.GetTeam() == TestAlly.GetTeam())
					{
						NearestAllyTiles = Min(NearestAllyTiles, LWUnit.TileDistanceBetween(TestAlly));
					}
				}
			}
		}
	}

	return NearestAllyTiles;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ShotInfo;
	local int NearestAllyTiles, AimBonus;

	NearestAllyTiles = NearestAllyBeyondRange(Attacker);
	AimBonus = Max(default.LONEWOLF_AIM_BONUS - (default.LONEWOLF_MIN_DIST_TILES + 1 - NearestAllyTiles) * default.LONEWOLF_AIM_PER_TILE, 0);
	if (AimBonus > 0)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
		{
			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = AimBonus;
			ShotModifiers.AddItem(ShotInfo);
			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = default.LONEWOLF_CRIT_BONUS;
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local int NearestAllyTiles, DefenseBonus;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.isPanicked())
		return;

	NearestAllyTiles = NearestAllyBeyondRange(Target);
	DefenseBonus = Max(default.LONEWOLF_DEF_BONUS - (default.LONEWOLF_MIN_DIST_TILES + 1 - NearestAllyTiles) * default.LONEWOLF_DEF_PER_TILE, 0);
	if (DefenseBonus > 0)
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -DefenseBonus;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="LoneWolf"
}
