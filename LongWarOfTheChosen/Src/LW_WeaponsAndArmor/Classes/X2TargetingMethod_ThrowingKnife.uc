//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_ThrowingKnife.uc
//  AUTHOR:  Musashi (copied by Peter Ledbrook)
//  PURPOSE: This is a copy of the throwing-knife targeting method from
//           Musashi_CK_TargetingMethod_ThrowKnife.uc in Musashi's Combat Knives mod.
//---------------------------------------------------------------------------------------

class X2TargetingMethod_ThrowingKnife extends X2TargetingMethod_OverTheShoulder;

var protected XComPrecomputedPath GrenadePath;
var protected transient XComEmitter ExplosionEmitter;
var protected XGWeapon WeaponVisualizer;

static function bool UseGrenadePath() { return true; }

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameState_Item WeaponItem;
	local X2WeaponTemplate WeaponTemplate;

	super.Init(InAction, NewTargetIndex);

	// determine our targeting range
	WeaponItem = Ability.GetSourceWeapon();

	// show the grenade path
	WeaponTemplate = X2WeaponTemplate(WeaponItem.GetMyTemplate());
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = true;

	GrenadePath = XComTacticalGRI( class'Engine'.static.GetCurrentWorldInfo().GRI ).GetPrecomputedPath();	
	GrenadePath.SetupPath(WeaponVisualizer.GetEntity(), FiringUnit.GetTeam(), WeaponTemplate.WeaponPrecomputedPathData);
	GrenadePath.UpdateTrajectory();
}

static function name GetProjectileTimingStyle()
{
	if( UseGrenadePath() )
	{
		return default.ProjectileTimingStyle;
	}

	return '';
}

function Canceled()
{
	super.Canceled();

	ExplosionEmitter.Destroy();
	GrenadePath.ClearPathGraphics();
	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = false;
	ClearTargetedActors();
}

defaultproperties
{
	ProjectileTimingStyle="Timing_Grenade"
}