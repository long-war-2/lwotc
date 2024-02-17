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
	local int Difficulty, LabelsLength, EnemyUnits, i;
	local array<X2CharacterTemplate> Dummy;
	local XComGameState_MissionSite DummyMissionSite;
	local X2CharacterTemplate CharTemplate;

	local array<X2CharacterTemplate> TemplatesThatWillSpawn_ADVT, TemplatesThatWillSpawn_LOST, TemplatesThatWillSpawn_FAC1, TemplatesThatWillSpawn_FAC2, TemplatesThatWillSpawn_CIVS;
	local int NumUnits_ADVT, NumUnits_LOST, NumUnits_FAC1, NumUnits_FAC2, NumUnits_CIVS;

	if(class'Helpers_LW'.default.bUseTrueDifficultyCalc)
	{
		if(AlertModifier == 0)
		{
			//MissionState.GetShadowChamberMissionInfo (EnemyUnits, Dummy);

			GetShadowChamberMissionInfo(MissionState, true, 
										TemplatesThatWillSpawn_ADVT, NumUnits_ADVT,
										TemplatesThatWillSpawn_LOST, NumUnits_LOST,
										TemplatesThatWillSpawn_FAC1, NumUnits_FAC1,
										TemplatesThatWillSpawn_FAC2, NumUnits_FAC2,
										TemplatesThatWillSpawn_CIVS, NumUnits_CIVS );

			`LWTrace("Schedule Selected for Dummy Mission:" @MissionState.SelectedMissionData.SelectedMissionScheduleName);
			`LWTrace("Modified Alert check. Alert Modifier:" @AlertModifier @ ". Enemy Count: " @NumUnits_ADVT);
			i=0;
			/*foreach TemplatesThatWillSpawn_ADVT (CharTemplate)
			{
				if(CharTemplate != None)
				{
					i++;
					`LWTrace("Unit" @i @"Found:" @CharTemplate.strCharacterName);
				}
			}
			*/
		}
		else
		{

			DummyMissionSite = new class'XComGameState_MissionSite'(MissionState);
			DummyMissionSite.Source = 'LWInfilListDummyMission';
			DummyMissionSite.CacheSelectedMissionData(MissionState.SelectedMissionData.ForceLevel, max(1, MissionState.SelectedMissionData.AlertLevel + AlertModifier));
			//DummyMissionSite.GetShadowChamberMissionInfo (EnemyUnits, Dummy);

			GetShadowChamberMissionInfo(DummyMissionSite, true, 
										TemplatesThatWillSpawn_ADVT, NumUnits_ADVT,
										TemplatesThatWillSpawn_LOST, NumUnits_LOST,
										TemplatesThatWillSpawn_FAC1, NumUnits_FAC1,
										TemplatesThatWillSpawn_FAC2, NumUnits_FAC2,
										TemplatesThatWillSpawn_CIVS, NumUnits_CIVS );

			`LWTrace("Schedule Selected for Dummy Mission:" @DummyMissionSite.SelectedMissionData.SelectedMissionScheduleName);
			`LWTrace("Modified Alert check. Alert Modifier:" @AlertModifier @ ". Enemy Count: " @NumUnits_ADVT);
			i=0;
		/*	foreach TemplatesThatWillSpawn_ADVT (CharTemplate)
			{
				if(CharTemplate != None)
				{
					i++;
					`LWTrace("Unit" @i @"Found:" @CharTemplate.strCharacterName);
				}
			} */
		}
			Difficulty = Max (1, ((NumUnits_ADVT-4) / 3));
	}
	else
	{
		// Old behavior if true difficulty calc is disabled
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
	if (NumUnits_ADVT <= 0)
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

// Borrowed from RustyDios - Full Shadow Report - for debug logging:

static function GetShadowChamberMissionInfo(XComGameState_MissionSite MissionSite, bool bIsFullCount, 
										out array<X2CharacterTemplate> TemplatesThatWillSpawn_ADVT, out int NumUnits_ADVT,
										out array<X2CharacterTemplate> TemplatesThatWillSpawn_LOST, out int NumUnits_LOST,
										out array<X2CharacterTemplate> TemplatesThatWillSpawn_FAC1, out int NumUnits_FAC1,
										out array<X2CharacterTemplate> TemplatesThatWillSpawn_FAC2, out int NumUnits_FAC2,
										out array<X2CharacterTemplate> TemplatesThatWillSpawn_CIVS, out int NumUnits_CIVS )
{
	local X2CharacterTemplateManager CharTemplateManager;
	local X2CharacterTemplate SelectedTemplate;

	local int EncounterIndex, CharacterIndex;
	local Name CharTemplateName;

	//RESET COUNTS AND ARRAYS
	NumUnits_ADVT = 0;	NumUnits_LOST = 0;	NumUnits_FAC1 = 0;	NumUnits_FAC2 = 0;	NumUnits_CIVS = 0;

	TemplatesThatWillSpawn_ADVT.Length = 0;	TemplatesThatWillSpawn_LOST.Length = 0;	
	TemplatesThatWillSpawn_FAC1.Length = 0;	TemplatesThatWillSpawn_FAC2.Length = 0;	TemplatesThatWillSpawn_CIVS.Length = 0;

	//IF NOT USING THE NEW FULL COUNT DISPLAY AND NUMBERS JUST REVERT TO BASEGAME FUNCTION, FIRST UNIT OF EACH GROUP TYPE

	//ELSE CONTINUE ON USING THIS MODS MODIFIED FUNCTION COPY
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	//CREATE NEW SPAWNED INFO LISTS BY TEMPLATE AND POD
	for( EncounterIndex = 0; EncounterIndex < MissionSite.SelectedMissionData.SelectedEncounters.Length; EncounterIndex++ )
	{
		//EncounterSpawnInfo = PodSpawnInfo struct from XComAISpawnManager ...
		`LWTrace("Encounter" @EncounterIndex@" Name:" @MissionSite.SelectedMissionData.SelectedEncounters[EncounterIndex].SelectedEncounterName);

		for( CharacterIndex = 0; CharacterIndex < MissionSite.SelectedMissionData.SelectedEncounters[EncounterIndex].EncounterSpawnInfo.SelectedCharacterTemplateNames.Length; CharacterIndex++ )
		{
			CharTemplateName = MissionSite.SelectedMissionData.SelectedEncounters[EncounterIndex].EncounterSpawnInfo.SelectedCharacterTemplateNames[CharacterIndex];
			SelectedTemplate = CharTemplateManager.FindCharacterTemplate(CharTemplateName);

			if (SelectedTemplate != none)
			{
				//ADD UNIT TO OUTPUT COUNTS
				if(SelectedTemplate.bIsCivilian)
				{
					continue; //SKIP THESE UNIT TYPES
				}
				else
				{
					`LWTrace("Unit" @CharacterIndex @":"@SelectedTemplate.dataname@"; group name:" @ SelectedTemplate.CharacterGroupName);
					if( SelectedTemplate.CharacterGroupName != '' )
					{
						`LWTrace("Added to list");
						TemplatesThatWillSpawn_ADVT.AddItem(SelectedTemplate);
						NumUnits_ADVT++;	

					}//end group none check
				}

			}//end template none check

		}//end character for loop

	}//end encounter for loop
}
