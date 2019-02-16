//---------------------------------------------------------------------------------------
//  FILE:    UITacticalHUD_MouseControls_LWOfficerPack.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Overrides mouse controls in order to add button to toggle officer command range preview
//
//--------------------------------------------------------------------------------------- 

class UITacticalHUD_MouseControls_LWOfficerPack extends UITacticalHUD_MouseControls;

var localized string strCommandRangeToggleTooltip;

var LWCommandRange_Actor CRActor, CRTemplate;
var UIICon OfficerIcon;
var bool CRToggleOn;

simulated function UpdateControls()
{
	local string key, label;
	local PlayerInput kInput;
	local XComKeybindingData kKeyData;
	local int i;
	local TacticalBindableCommands command;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	
	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	kInput = PC.PlayerInput;
	kKeyData = Movie.Pres.m_kKeybindingData;

	AS_SetHoverHelp("");

	if(UITacticalHUD(screen).m_isMenuRaised)
	{
		SetNumActiveControls(1);

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eGBC_Cancel, eKC_General);
		SetButtonItem( m_optCancelShot,     m_strCancelShot,       key != "" ? key : m_strNoKeyBoundString,    ButtonItems[0].UIState );

		if (OfficerIcon != none)
			OfficerIcon.Hide();
	}
	else
	{
		SetNumActiveControls(5 + CommandAbilities.Length);  // add "phantom" control to leave space for Command Range icon

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eTBC_EndTurn);
		SetButtonItem( m_optEndTurn,        m_strEndTurn,       key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optEndTurn].UIState );

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eTBC_PrevUnit);
		SetButtonItem( m_optPrevSoldier,    m_strPrevSoldier,   key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optPrevSoldier].UIState );

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eTBC_NextUnit);
		SetButtonItem( m_optNextSoldier,    m_strNextSoldier,   key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optNextSoldier].UIState );

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eTBC_CamRotateLeft);
		label = kKeyData.GetTacticalBindableActionLabel(eTBC_CamRotateLeft);
		SetButtonItem( m_optRotateCameraLeft,    label,   key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optRotateCameraLeft].UIState );

		key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, eTBC_CamRotateRight);
		label = kKeyData.GetTacticalBindableActionLabel(eTBC_CamRotateRight);
		SetButtonItem( m_optRotateCameraRight,    label,   key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optRotateCameraRight].UIState );

		for(i = 0; i < CommandAbilities.Length; i++)
		{
			command = TacticalBindableCommands(eTBC_CommandAbility1 + i);
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(CommandAbilities[i].AbilityObjectRef.ObjectID));
			key = kKeyData.GetPrimaryOrSecondaryKeyStringForAction(kInput, command);
			label = Caps(AbilityState.GetMyFriendlyName());
			SetButtonItem( m_optCallSkyranger + i,    label,   key != "" ? key : m_strNoKeyBoundString,    ButtonItems[m_optCallSkyranger + i].UIState, BattleData.IsAbilityObjectiveHighlighted(AbilityState.GetMyTemplate()));
		}

		if (class'LWOfficerUtilities'.static.HasOfficerInSquad())
		{
			if (OfficerIcon != none)
				OfficerIcon.Show();
			else
				AddCommandRangeIcon(-300, 4);
				//AddCommandRangeIcon(-300, 200);  // For tooltip testing. Puts icon more in the middle of the screen.
		}
	}
}

function AddCommandRangeIcon(float newX, float newY)
{
	OfficerIcon = Spawn(class'UIIcon', self).InitIcon('abilityIcon2MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 36); //,,OnClickedCallback);
	OfficerIcon.ProcessMouseEvents(OnChildMouseEvent);
	OfficerIcon.bDisableSelectionBrackets = true;
	OfficerIcon.EnableMouseAutomaticColor( class'UIUtilities_Colors'.const.GOOD_HTML_COLOR, class'UIUtilities_Colors'.const.BLACK_HTML_COLOR );

	//`Log("LW CommandRange Icon: Setting Tooltip=" @ strCommandRangeToggleTooltip);

	OfficerIcon.SetToolTipText(class'UIUtilities_Text'.static.GetSizedText(Caps(strCommandRangeToggleTooltip), 18), "" , 26, 0, true, class'UIUtilities'.const.ANCHOR_TOP_RIGHT, false, 0.0);
	//OfficerIcon.SetToolTipText(class'UIUtilities_Text'.static.GetSizedText(Caps("Really, Really, Really, Really, Really, Really, Really long string"), 18), "" , 26, 0, true, class'UIUtilities'.const.ANCHOR_TOP_RIGHT, false, 0.0);

	OfficerIcon.OriginTopRight();
	OfficerIcon.AnchorTopRight();
	OfficerIcon.SetPosition(newX, newY); // TODO: see if can figure out how to calculate position based on other elements
	OfficerIcon.Show();
}

simulated function OnChildMouseEvent(UIPanel ChildControl, int cmd)
{

	if (ChildControl == OfficerIcon)  
	{
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			OnClickedCallback();
			//Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
			//if (CRToggleOn)
				//PlaySound( SoundCue'SoundUI.GhostArmorOffCue', true , true );
			//else
				//PlaySound( SoundCue'SoundUI.GhostArmorOnCue', true , true );
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
		{
			OfficerIcon.OnReceiveFocus();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			OfficerIcon.OnLoseFocus();
		}
	}
}

simulated function OnClickedCallback()
{
	local int idx;
	local XComGameState_Unit UnitState;

	if (CRActor == none)
	{
		CRActor = Spawn(class'LWCommandRange_Actor', self, 'CommandRange');
		CRActor.Init();

		// now spawn the CommandRange Actor, passing in the Archetype reference as the template
		//CRActor = Spawn(class'LWCommandRange_Actor', self, 'CommandRange',,,CRTemplate);  // NOT WORKING BECAUSE ARCHETYPE ISN"T WORKING PROPERLY IN UNREALED
	}
	if (CRToggleOn)
	{
		CRToggleOn = false;
		CRActor.RemoveEffects();
		PlaySound( SoundCue'SoundUI.GhostArmorOffCue', true , true );
		//`RedScreen("Toggling CR Off");
	} else {
		CRToggleOn = true;
		for(idx = 0; idx < `XCOMHQ.Squad.Length; idx++)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.Squad[idx].ObjectID));
			if (class'LWOfficerUtilities'.static.IsOfficer(UnitState) && class'LWOfficerUtilities'.static.IsHighestRankOfficerInSquad(UnitState))
			{
				CRActor.AddBoundariesFromOfficer(UnitState);
			}
		}
		CRActor.DrawBoundaries();
		PlaySound( SoundCue'SoundUI.GhostArmorOnCue', true , true );
		//PlaySound( SoundCue'SoundUI.EventNotificationCue', true, true);
		//`RedScreen("Toggling CR On");
	}
}
