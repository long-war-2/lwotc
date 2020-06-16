//---------------------------------------------------------------------------------------
//  FILE:   X2TargetingMethod_ConditionalBlasterLauncher.uc
//  AUTHOR:  InternetExploder
//  PURPOSE: Hybrid targeting method using Blaster Launcher pathing when conditions are met.
//---------------------------------------------------------------------------------------

class X2TargetingMethod_ConditionalBlasterLauncher extends X2TargetingMethod_Grenade config(GameData);

var config bool bUseBlasterLauncherTargeting;

var protected XGWeapon WeaponVisualizer;

var protected bool bBlasterLauncherTargetingEnabled;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameState_Item WeaponItem;

	super.Init(InAction, NewTargetIndex);
	
	WeaponItem = Ability.GetSourceWeapon();

	// check whether the source weapon is a beam grenade launcher and whether blaster launcher targeting is enabled via configuration
	if ((WeaponItem.GetMyTemplateName() == 'GrenadeLauncher_BM') && default.bUseBlasterLauncherTargeting)
	{
		// set up blaster launcher pathing visuals
		WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());
		XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = true;
		GrenadePath.m_bBlasterBomb = true;
		bBlasterLauncherTargetingEnabled = true;
	}
}

function Canceled()
{
	super.Canceled();

	GrenadePath.m_bBlasterBomb = false;
	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = false;
}

simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = Cursor.GetCursorFeetLocation();
	Radius = Ability.GetAbilityRadius();

	if ((ExplosionEmitter != none) && (Center != ExplosionEmitter.Location))
	{
		ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitter.SetDrawScale(Radius / 48.0f);
		ExplosionEmitter.SetRotation(rot(0,0,1));

		if (!ExplosionEmitter.ParticleSystemComponent.bIsActive)
		{
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
}

// this is where some magic happens; by mixing timing style and
// ordnance type we can get both targeting modes in one class
// (weird, but works for some reason)
defaultproperties
{
	ProjectileTimingStyle="Timing_BlasterLauncher"
	OrdnanceTypeName="Ordnance_Grenade"
}