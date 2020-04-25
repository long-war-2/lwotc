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
	local int ControlCount;

	super.UpdateControls();

	if (UITacticalHUD(screen).m_isMenuRaised)
	{
		if (OfficerIcon != none)
			OfficerIcon.Hide();
	}
	else
	{
		// Work out how many "command" controls there are. Base game has 5 + 1
		// for the Chosen + 1 for any command abilities (presumably an unimplemented
		// feature). We add an extra one for the Command Range button.
		ControlCount = 5;
		if (class'XComGameState_Unit'.static.GetActivatedChosen() != none)
			ControlCount++;
		ControlCount += CommandAbilities.Length;
		SetNumActiveControls(ControlCount);

		if (class'LWOfficerUtilities'.static.HasOfficerInSquad())
		{
			if (OfficerIcon != none)
				OfficerIcon.Show();
			else
				AddCommandRangeIcon((!`SecondWaveEnabled('EnableChosen')) ? -300 : -345, 4);
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
