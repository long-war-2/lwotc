//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_LWBlasterLauncher.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Custom targeting method with scatter for LW Blaster Launcher in Gauntlet_BM
//---------------------------------------------------------------------------------------
class X2TargetingMethod_LWBlasterLauncher extends X2TargetingMethod_BlasterLauncher;

var UIScrollingTextField ScatterAmountText;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local UITacticalHUD TacticalHUD;

	super.Init(InAction, NewTargetIndex);

	TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
	ScatterAmountText = TacticalHUD.Spawn(class'UIScrollingTextField', TacticalHUD);
	ScatterAmountText.bAnimateOnInit = false;
	ScatterAmountText.InitScrollingText('AverageScatterText_LW', "", 400, 0, 0);
	ScatterAmountText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("± 1.4 Tiles", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
	ScatterAmountText.ShowShadow(0);
	ScatterAmountText.Show();
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	local vector ScatteredTargetLoc;
	local X2WeaponTemplate WeaponTemplate;
	local int MaxIterCount, Iter;
	local float OrigPathLength, NewPathLength, PathDelta, MaxPathDelta;

	WeaponTemplate = X2WeaponTemplate(Ability.GetSourceWeapon().GetMyTemplate());
	OrigPathLength = GrenadePath.akKeyframes[GrenadePath.iNumKeyframes - 1].fTime - GrenadePath.akKeyframes[0].fTime;
	`LOG("BlasterLauncher Scatter: OrigPathLength=" $ OrigPathLength);

	PathDelta = 99999999.0;
	MaxPathDelta = 0.5;
	MaxIterCount = 50;

	while(PathDelta > MaxPathDelta && Iter < MaxIterCount)
	{	
		//get a random target location
		ScatteredTargetLoc = NewTargetLocation;
		ScatteredTargetLoc = class'X2Ability_LW_TechnicalAbilitySet'.static.GetScatterAmount(UnitState, ScatteredTargetLoc);

		//compute the path to that location
		GrenadePath.SetWeaponAndTargetLocation(WeaponVisualizer.GetEntity(), FiringUnit.GetTeam(), ScatteredTargetLoc, WeaponTemplate.WeaponPrecomputedPathData);

		NewPathLength = GrenadePath.akKeyframes[GrenadePath.iNumKeyframes - 1].fTime - GrenadePath.akKeyframes[0].fTime;
		PathDelta = Abs(OrigPathLength - NewPathLength);
		`LOG("BlasterLauncher Scatter: NewPathLength=" $ NewPathLength $ ", PathDelta=" $ PathDelta);

		Iter++;
	}

	//check to see if we found a valid path to a scattered location
	if(PathDelta > MaxPathDelta) 
	{
		//failure, reset to original position
		GrenadePath.SetWeaponAndTargetLocation(WeaponVisualizer.GetEntity(), FiringUnit.GetTeam(), NewTargetLocation, WeaponTemplate.WeaponPrecomputedPathData);
		`REDSCREEN("X2TargetingMethod_LWBlasterLauncher -- failed to find valid scatter location after " $ MaxIterCount $ " iterations.");
		TargetLocations.Length = 0;
		TargetLocations.AddItem(NewTargetLocation);
	}
	else
	{
		NewTargetLocation = ScatteredTargetLoc;
		TargetLocations.Length = 0;
		TargetLocations.AddItem(ScatteredTargetLoc);
	}
	
	GrenadePath.bUseOverrideTargetLocation = false;
}

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local array<TTile> Tiles;
	local vector2d vMouseCursorPos;
	local float ExpectedScatter;

	NewTargetLocation = GrenadePath.GetEndPosition();

	if( NewTargetLocation != CachedTargetLocation )
	{		
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);

		//update expected scatter amount display
		// Make the "tooltip" not rely on the  existance of the mouse pointer, use the target location instead.
		vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(NewTargetLocation);
		ScatterAmountText.SetPosition((vMouseCursorPos.X+1)*960 + 2, (1-vMouseCursorPos.Y)*540 + 14); // this follows cursor
		ExpectedScatter = class'X2Ability_LW_TechnicalAbilitySet'.static.GetExpectedScatter(UnitState, NewTargetLocation);
		ScatterAmountText.SetHTMLText(class'UIUtilities_LW'.static.GetHTMLAverageScatterText(ExpectedScatter));
	}

	super(X2TargetingMethod).Update(DeltaTime);
}

function Canceled()
{
	super.Canceled();
	ScatterAmountText.Hide();
	ScatterAmountText.Remove();
}