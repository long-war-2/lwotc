class UIUtilities_LW extends Object;

var localized string m_sAverageScatterText1;
var localized string m_sAverageScatterText2;

static function vector2d GetMouseCoords()
{
	local PlayerController PC;
	local PlayerInput kInput;
	local vector2d vMouseCursorPos;

	foreach `XWORLDINFO.AllControllers(class'PlayerController',PC)
	{
		if ( PC.IsLocalPlayerController() )
		{
			break;
		}
	}
	kInput = PC.PlayerInput;

	XComTacticalInput(kInput).GetMouseCoordinates(vMouseCursorPos);
	return vMouseCursorPos;
}

static function string GetHTMLAverageScatterValueText(float value, optional int places = 2)
{
	local string FloatString, TempString;
	local int i;
	local float TempFloat, TestFloat;

	TempFloat = value;
	for (i=0; i< places; i++)
	{
		TempFloat *= 10.0;
	}
	TempFloat = Round(TempFloat);
	for (i=0; i< places; i++)
	{
		TempFloat /= 10.0;
	}

	TempString = string(TempFloat);
	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
	{
		FloatString = Left(TempString, i);
		TestFloat = float(FloatString);
		if (TempFloat ~= TestFloat)
		{
			break;
		}
	}

	if (Right(FloatString, 1) == ".")
	{
		FloatString $= "0";
	}

	return class'UIUtilities_Text'.static.GetColoredText(FloatString $ " / ", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}

static function string GetHTMLMaximumScatterValueText(float value, optional int places = 2)
{
	local string FloatString, TempString;
	local int i;
	local float TempFloat, TestFloat;

	TempFloat = value;
	for (i=0; i< places; i++)
	{
		TempFloat *= 10.0;
	}
	TempFloat = Round(TempFloat);
	for (i=0; i< places; i++)
	{
		TempFloat /= 10.0;
	}

	TempString = string(TempFloat);
	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
	{
		FloatString = Left(TempString, i);
		TestFloat = float(FloatString);
		if (TempFloat ~= TestFloat)
		{
			break;
		}
	}

	if (Right(FloatString, 1) == ".")
	{
		FloatString $= "0";
	}

	return class'UIUtilities_Text'.static.GetColoredText(FloatString, eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}

static function string GetHTMLTilesText1()
{
	return class'UIUtilities_Text'.static.GetColoredText(default.m_sAverageScatterText1, eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}
static function string GetHTMLTilesText2()
{
	return class'UIUtilities_Text'.static.GetColoredText(default.m_sAverageScatterText2, eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}