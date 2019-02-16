// need to extend this in order to get updates from input re: stick vector (ed: doesn't work)
// basically just gives delta callbacks
// all interpolation is done in robojumper_UISquadSelect
class robojumper_UIMouseGuard_SquadSelect extends UIMouseGuard_RotatePawn;

var vector2d OurStickVector;

var float mouseMoveScalar;

// scroll = 1, drag = delta-x * mouseMoveScalar, stick = delta-x * StickRotationMultiplier
delegate ValueChangeCallback(float fChange);

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	// invisible (but still consuming mouse events) on SquadSelect because there's stuff to look at
	SetAlpha(0);
}

simulated function SetActorPawn(Actor NewPawn, optional Rotator NewRotation)
{
	//`REDSCREEN("robojumper_UIMouseGuard_SquadSelect does not rotate pawns");
}

simulated function OnUpdate()
{
	local Vector2D MouseDelta;
	local float fChange;
	fChange = 0;
	OurStickVector.X = `HQINPUT.m_fRSXAxis;
	if (`ISCONTROLLERACTIVE)
	{
		bRotatingPawn = Abs(OurStickVector.X) > 0.2f;
	}
	if(bRotatingPawn && bCanRotate)
	{
		MouseDelta = Movie.Pres.m_kUIMouseCursor.m_v2MouseFrameDelta;
		if( `ISCONTROLLERACTIVE )
		{
			fChange += 1.0 * OurStickVector.X * StickRotationMultiplier;
		}
		else
		{
			fChange -= 1.0 * MouseDelta.X * mouseMoveScalar;
		}
	}
	
	if(Abs(fChange) > 0)
	{
		ValueChangeCallback(fChange);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	if(bCanRotate)
	{
		switch( cmd )
		{
		case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN:
			if(bMouseIn) RotateInPlace(1);
			return true;
		case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP:
			if(bMouseIn) RotateInPlace(-1);
			return true;
		}
	}

	return super(UIMouseGuard).OnUnrealCommand(cmd, arg);
}

simulated function RotateInPlace(int Dir)
{
	if (ValueChangeCallback != none)
	{
		ValueChangeCallback(Dir);
	}
}

/*simulated function UpdateStickVector(float newX, float newY)
{
	OurStickVector.X = newX;
	bRotatingPawn = newX > 0.2f || newX < -0.2f;
}*/

simulated function StartUpdate()
{
	SetTimer(0.01f, true, nameof(OnUpdate));
}

simulated function ClearUpdate()
{
	ClearTimer(nameof(OnUpdate));
}

simulated function OnReceiveFocus()
{
	super(UIMouseGuard).OnReceiveFocus();
}

simulated function OnLoseFocus()
{
	super(UIMouseGuard).OnLoseFocus();
}
