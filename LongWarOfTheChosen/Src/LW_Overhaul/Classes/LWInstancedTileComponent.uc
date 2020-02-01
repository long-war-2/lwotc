class LWInstancedTileComponent extends X2TargetingMethod;

function CustomInit()
{
    AOEMeshActor = `XWORLDINFO.Spawn(class'LWInstancedMeshActor');
}
 
function SetMesh(StaticMesh Mesh)
{
    AOEMeshActor.InstancedMeshComponent.SetStaticMesh(Mesh);
}

// X2TargetingMethod requires that Ability is set. Do it with this function.
function SetMockParameters(XComGameState_Ability AbilityState)
{
	Ability = AbilityState;
}

function SetTiles(const out array<TTile> Tiles)
{
    DrawAOETiles(Tiles);
}
 
function Dispose()
{
    AOEMeshActor.Destroy();
}

function SetVisible(bool Visible)
{
	AOEMeshActor.SetVisible(Visible);
}