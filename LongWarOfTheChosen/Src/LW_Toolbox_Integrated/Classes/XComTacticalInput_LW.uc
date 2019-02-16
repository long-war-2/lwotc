//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XComTacticalInput_LW extends XComTacticalInput dependson(X2GameRuleset) config(LW_Toolbox) deprecated;

//

//state InReplayPlayback
//{
	//function bool Key_Q( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	//function bool Key_E( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	////function bool DPad_Right( int ActionMask )
	////{
		////if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			////XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		////return false;
	////}
////
	////function bool DPad_Left( int ActionMask )
	////{
		////if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			////XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		////return false;
	////}
//}
//
//state UsingTargetingMethod
//{
	//function bool Key_E( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0)
		//{
			//XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//}
		//return true;
	//}
//
	//function bool Key_Q( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0)
		//{
			//XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//}
		//return true;
	//}
	////function bool DPad_Right( int ActionMask )
	////{
		////if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0)
		////{
			////XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		////}
		////return true;
	////}
////
	////function bool DPad_Left( int ActionMask )
	////{
		////if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) != 0)
		////{
			////XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		////}
		////return true;
	////}
//}
//
//state Multiplayer_Inactive
//{
	//function bool Key_E( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	//function bool Key_Q( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	//function bool DPad_Right( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	//function bool DPad_Left( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
//}
//
//state ActiveUnit_Moving
//{
	//function bool Key_E( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(-class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
	//function bool Key_Q( int ActionMask )
	//{
		//if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
			//XComTacticalController(Outer).YawCamera(class'XComGameState_LWToolboxOptions'.static.GetRotationAngle());
		//return false;
	//}
//}