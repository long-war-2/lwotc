//---------------------------------------------------------------------------------------
//	FILE:		UIMouseGuard_LW.uc
//	AUTHOR:		KDM
//	PURPOSE:	Custom mouse guard used to reduce flicker on the strategy map for controller users
//
//	IMPORTANT DISCOVERIES : When a UIScreen has bConsumeMouseEvents set to true, a mouse guard screen is automatically
//	created and 'buddied' with it upon a screen stack push. This mouse guard screen is invisible when
//	'buddied' to a 3D screen; however, when 'buddied' to a 2D screen, it animates in as a faded black.
//	It is important to note that bConsumeMouseEvents needs to be set right after spawning, as it is dealt
//	with by the screen stack before the screen has InitScreen() called. If you set bConsumeMouseEvents
//	during InitScreen() you can get freezing situations.
//---------------------------------------------------------------------------------------

class UIMouseGuard_LW extends UIMouseGuard;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super(UIScreen).InitScreen(InitController, InitMovie, InitName);

	// KDM : Normal Firaxis code sets the alpha to 0 whenever we are dealing with a 3D screen
	if (bIsIn3D)
	{
		SetAlpha(0);
	}
	else
	{
		// KDM : IMPORTANT By default, Long War 2's UIResistanceManagement_LW and UIOutpostManagement screens have
		// bConsumeMouseEvents set to true; this results in mouse guards being attached to them.
		// Now, when a mouse guard is attached to a 2D screen, an animated overlay appears behind the screen;
		// unfortunately, this creates a slight illumination flicker on the strategy map when the Resistance overview
		// screen loses focus and Haven screen receives focus. It is important to note that this is not a problem for
		// mouse and keyboard users since they can't bring up the Resistance overview screen on the strategy map as it has been
		// disabled. A simple solution, therefore, is to keep the mouse guard when a controller is active (to minimize
		// coding changes) but just remove its visibility.
		//
		// NOTE : For a bit more information see IMPORTANT DISCOVERIES above.

		// PAL: The Resistance Overview screen can once again be opened from the strategy
		// map, so removing the ISCONTROLLERACTIVE check.
		SetAlpha(0);
	}
}
