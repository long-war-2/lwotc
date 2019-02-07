//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_MassMindspin.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Specialized targeting that doesn't warn about hitting friendly targets
//---------------------------------------------------------------------------------------

class X2TargetingMethod_MassMindspin extends X2TargetingMethod_Cone config(LW_AlienPack);

function bool VerifyTargetableFromIndividualMethod(delegate<ConfirmAbilityCallback> fnCallback)
{
	return true;
}

function Init(AvailableAction InAction, int NewTargetIndex)
{
	super.Init(InAction, NewTargetIndex);

	//override and use the offensive meshes, because we're forcing Offensive otherwise false to avoid getting false positives against friendly units
	AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile", class'StaticMesh')));
	ConeActor.MeshLocation = "UI_3D.Targeting.ConeRange";
	ConeActor.InitConeMesh(ConeLength / class'XComWorldData'.const.WORLD_StepSize, ConeWidth / class'XComWorldData'.const.WORLD_StepSize);
	ConeActor.SetLocation(FiringLocation);
}

function CheckForFriendlyUnit(const out array<Actor> list)
{
	return;
}

function bool GetAbilityIsOffensive()
{
	return false;
}