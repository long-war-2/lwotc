//---------------------------------------------------------------------------------------
//  FILE:    UIUtilities_Text_LW.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Utilities & generic localized text for UI
//--------------------------------------------------------------------------------------- 

class UIUtilities_Text_LW extends object;

// KDM : I am keeping these constants in sync with values from UIUtilities_Text for consistancy.
const BODY_FONT_SIZE_2D = 22;
const TITLE_FONT_SIZE_2D = 32;
const BODY_FONT_SIZE_3D = 26;
const TITLE_FONT_SIZE_3D = 32;
const BODY_FONT_TYPE = "$NormalFont";
const TITLE_FONT_TYPE = "$TitleFont";

var localized string m_strHelp;

// KDM : This is equivalent to UIUtilities_Text --> AddFontInfo(); the only difference is that it allows you to modify the font's colour.
static function string AddFontInfoWithColor(string txt, bool is3DScreen, optional bool isTitleFont, optional bool forceBodyFontSize, 
	optional int specifyFontSize = 0, optional int ColorState = -1)
{
	local int fontSize, fontSize2D, fontSize3D;
	local string fontColor, fontFace;
	
	if (txt == "")
	{
		return txt;
	}

	fontFace = isTitleFont ? TITLE_FONT_TYPE : BODY_FONT_TYPE;
	
	switch(ColorState)
	{
		case eUIState_Disabled:		
			fontColor = class'UIUtilities_Colors'.const.DISABLED_HTML_COLOR;	
			break;
		case eUIState_Good:			
			fontColor = class'UIUtilities_Colors'.const.GOOD_HTML_COLOR;		
			break;
		case eUIState_Bad:			
			fontColor = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;		
			break;
		case eUIState_Warning:		
			fontColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;	
			break;
		case eUIState_Warning2:		
			fontColor = class'UIUtilities_Colors'.const.WARNING2_HTML_COLOR;	
			break;
		case eUIState_Highlight:    
			fontColor = class'UIUtilities_Colors'.const.HILITE_HTML_COLOR;		
			break;
		case eUIState_Cash:         
			fontColor = class'UIUtilities_Colors'.const.CASH_HTML_COLOR;		
			break;
		case eUIState_Header:       
			fontColor = class'UIUtilities_Colors'.const.HEADER_HTML_COLOR;     
			break;
		case eUIState_Psyonic:      
			fontColor = class'UIUtilities_Colors'.const.PSIONIC_HTML_COLOR;    
			break;
		case eUIState_Normal:       
			fontColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;     
			break;
		case eUIState_Faded:        
			fontColor = class'UIUtilities_Colors'.const.FADED_HTML_COLOR;      
			break;
		default:                    
			fontColor = class'UIUtilities_Colors'.const.BLACK_HTML_COLOR;      
			break;
	}

	if (specifyFontSize == 0)
	{
		fontSize2D = isTitleFont ? (forceBodyFontSize ? BODY_FONT_SIZE_2D : TITLE_FONT_SIZE_2D) : BODY_FONT_SIZE_2D;
		fontSize3D = isTitleFont ? (forceBodyFontSize ? BODY_FONT_SIZE_3D : TITLE_FONT_SIZE_3D) : BODY_FONT_SIZE_3D;

		fontSize = is3DScreen ? fontSize3D : fontSize2D;
	}
	else 
	{
		fontSize = specifyFontSize;
	}
	
	return "<font size='" $ fontSize $ "' face='" $ fontFace $ "' color='#" $ fontColor $ "'>" $ txt $ "</font>";
}

static function String GetDifficultyString(XComGameState_MissionSite MissionState, optional int AlertModifier = 0)
{
	local string Text, nums;
	local int Difficulty, LabelsLength, EnemyUnits;
	local array<X2CharacterTemplate> Dummy;
	local XComGameState_MissionSite DummyMissionSite;

	if(class'Helpers_LW'.default.bUseTrueDifficultyCalc)
	{
		if(AlertModifier == 0)
		{
			MissionState.GetShadowChamberMissionInfo (EnemyUnits, Dummy);
			`LWTrace("Schedule Selected for Dummy Mission:" @MissionState.SelectedMissionData.SelectedMissionScheduleName);
			`LWTrace("Modified Alert check. Alert Modifier:" @AlertModifier @ ". Enemy Count: " @EnemyUnits);
		}
		else
		{

			DummyMissionSite = new class'XComGameState_MissionSite'(MissionState);
			DummyMissionSite.Source = 'LWInfilListDummyMission';
			DummyMissionSite.CacheSelectedMissionData(MissionState.SelectedMissionData.ForceLevel, MissionState.SelectedMissionData.AlertLevel + AlertModifier);
			DummyMissionSite.GetShadowChamberMissionInfo (EnemyUnits, Dummy);
			`LWTrace("Schedule Selected for Dummy Mission:" @DummyMissionSite.SelectedMissionData.SelectedMissionScheduleName);
			`LWTrace("Modified Alert check. Alert Modifier:" @AlertModifier @ ". Enemy Count: " @EnemyUnits);
		}
			Difficulty = Max (1, ((EnemyUnits-4) / 3));
	}
	else
	{
		MissionState.GetShadowChamberMissionInfo (EnemyUnits, Dummy);
		Difficulty = Max (1, ((EnemyUnits + (AlertModifier * 1.5)-4) / 3));
	}

	LabelsLength = class'X2StrategyGameRulesetDataStructures'.default.MissionDifficultyLabels.Length;
	if(Difficulty >= LabelsLength - 1)
	{
		nums = " (" $ ((LabelsLength * 3) + 1) $ "+)";
		Text = class'X2StrategyGameRulesetDataStructures'.default.MissionDifficultyLabels[LabelsLength - 1] $ nums;
	}
	else
	{
		nums = " (" $ ((Difficulty * 3) + 4) $ "-" $ ((Difficulty * 3) + 6) $ ")";

		Text = class'X2StrategyGameRulesetDataStructures'.default.MissionDifficultyLabels[Difficulty] $ nums;
	}
	if (EnemyUnits <= 0)
	{
		Text = class'X2StrategyGameRulesetDataStructures'.default.MissionDifficultyLabels[0] $ " (???)";
	}

	return Caps(Text);
}

// Strips up to 50 html tags and what's between them from a string
// This doesn't actually work yet (discovered the bug it was trying to fix was caused by a mod), but leaving it here in case we need to come back and fix it later
static function string StripHTML (String InputString)
{
	local string WorkingString, StripString;
	local int StartPoint, EndPoint, Passes;

	WorkingString = InputString;
	Passes = 0;
	while (InStr (WorkingString, "<") != -1)
	{
		StartPoint = InStr (WorkingString, "<");
		EndPoint = InStr (WorkingString, ">");
		if (StartPoint > -1 && EndPoint > -1)
		{
			StripString = Mid (WorkingString, StartPoint, EndPoint);
			WorkingString = Repl (WorkingString, StripString, "", false);
		}
		Passes += 1;
		if (Passes > 50)
			break;
	}

	return WorkingString;
}