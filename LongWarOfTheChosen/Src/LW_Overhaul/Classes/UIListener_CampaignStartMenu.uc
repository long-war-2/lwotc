class UIListener_CampaignStartMenu extends UIScreenListener;

var localized string strDisabledTutorialTooltip;
var localized string strDisabledNarrativeContentTooltip;
var localized string strDisabledPrecisionExplosivesTooltip;

event OnInit(UIScreen Screen)
{
	local UIShellDifficulty ShellDifficulty;
	local UIShellNarrativeContent ShellNarrativeContent;

	if (UIShellDifficulty(Screen) != none)
	{
		ShellDifficulty = UIShellDifficulty(Screen);
		ShellDifficulty.m_bShowedFirstTimeTutorialNotice = true;
		ShellDifficulty.m_TutorialMechaItem.Checkbox.SetChecked(false);
		ShellDifficulty.UpdateTutorial(ShellDifficulty.m_TutorialMechaItem.Checkbox);

		// Disable the checkbox - must be after UpdateTutorial() above as that will set it to enabled
		// (thanks to Covert Infiltration for this suggestion with `UpdateTutorial()`)
		ShellDifficulty.m_TutorialMechaItem.SetDisabled(true, strDisabledTutorialTooltip);
	}

	if (UIShellNarrativeContent(Screen) != none)
	{
		ShellNarrativeContent = UIShellNarrativeContent(Screen);
		ShellNarrativeContent.m_bShowedXpackNarrtiveNotice = true;
		ShellNarrativeContent.m_XpacknarrativeMechaItem.Checkbox.SetChecked(false);
		ShellNarrativeContent.m_XpacknarrativeMechaItem.SetDisabled(true, strDisabledNarrativeContentTooltip);
	}
}
