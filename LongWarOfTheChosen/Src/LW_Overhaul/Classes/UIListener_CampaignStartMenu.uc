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
		ShellDifficulty.m_TutorialMechaItem.Checkbox.SetChecked(false);
		ShellDifficulty.m_TutorialMechaItem.SetDisabled(true, strDisabledTutorialTooltip);

		// Disables Advanced Option for Precision Explosives
		// Hard-coding the index should be fine because Firaxis already relies on these indexes being hard-coded
		UIMechaListItem(ShellDifficulty.m_SecondWaveList.GetItem(7)).Checkbox.SetChecked(false);
		UIMechaListItem(ShellDifficulty.m_SecondWaveList.GetItem(7)).SetDisabled(true, strDisabledPrecisionExplosivesTooltip);
	}

	if (UIShellNarrativeContent(Screen) != none)
	{
		ShellNarrativeContent = UIShellNarrativeContent(Screen);
		ShellNarrativeContent.m_XpacknarrativeMechaItem.Checkbox.SetChecked(false);
		ShellNarrativeContent.m_XpacknarrativeMechaItem.SetDisabled(true, strDisabledNarrativeContentTooltip);
	}
}