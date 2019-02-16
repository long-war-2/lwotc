//---------------------------------------------------------------------------------------
//  FILE:    LWHelpTemplate.uc
//  AUTHOR:  amineri / Pavonis Interactive
//	PURPOSE: Generic Help Template for NavHelp Help Button data
//---------------------------------------------------------------------------------------

class LWHelpTemplate extends X2StrategyElementTemplate;

enum ENavHelp_Side
{
	eNavHelp_Left,
	eNavHelp_Center,
	eNavHelp_Right,
};

var localized string m_strHelpTitle;
var localized string m_strHelpText;
var localized string m_strHelpButtonTooltip;

static function AddHelpButton_Nav(name HelpTemplateName, optional ENavHelp_Side Side = eNavHelp_Left)
{
	local int i;            // needed for enum hackery
	local string strIcon;   // needed for enum hackery
	local UINavigationHelp NavHelp;
    local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local XComHQPresentationLayer HQPres;
	local LWHelpTemplate HelpTemplate;

	HQPres = `HQPRES;
	// This is only useful in the strategy game. 
	if(`HQPres == none)
		return;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
	if(NavHelp == none)
		return;

    StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	HelpTemplate = LWHelpTemplate(StrategyTemplateMgr.FindStrategyElementTemplate(HelpTemplateName));
	if(HelpTemplate == none)
		return;

	if( HQPres.Get2DMovie().IsMouseActive() )
	{
		NavHelp.SetButtonType("XComButtonIconPC");
		i = eButtonIconPC_Details;
		strIcon = string(i);
		switch (Side)
		{
			case eNavHelp_Center:
				NavHelp.AddCenterHelp(strIcon, "", HelpTemplate.OnHelp, false, HelpTemplate.m_strHelpButtonTooltip);
				break;
			case eNavHelp_Right:
				NavHelp.AddRightHelp(strIcon, "", HelpTemplate.OnHelp, false, HelpTemplate.m_strHelpButtonTooltip,  class'UIUtilities'.const.ANCHOR_BOTTOM_CENTER);
				break;
			case eNavHelp_Left:
			default:
				NavHelp.AddLeftHelp(strIcon, "", HelpTemplate.OnHelp, false, HelpTemplate.m_strHelpButtonTooltip);
				break;
		}
		NavHelp.SetButtonType("");
	}
}

static function UIButtonIconPC AddHelpButton_Std(name HelpTemplateName, UIPanel Owner, optional float X, optional float Y)
{
    local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local XComPresentationLayerBase Pres;
	local LWHelpTemplate HelpTemplate;
	local UIButtonIconPC ButtonIcon;

	Pres = `PRESBASE;
	// Requires access to presentationlayer
	if(Pres == none)
		return none;

    StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	HelpTemplate = LWHelpTemplate(StrategyTemplateMgr.FindStrategyElementTemplate(HelpTemplateName));
	if(HelpTemplate == none)
		return none;

	if( Pres.Get2DMovie().IsMouseActive() )
	{
		ButtonIcon = UIButtonIconPC(Owner.GetChildByName(HelpTemplateName, false));
		if (ButtonIcon == none)
		{
			ButtonIcon = Pres.Spawn(class'UIButtonIconPC', Owner);
			ButtonIcon.InitButton(HelpTemplateName, HelpTemplate.OnHelpButton);
		}

		ButtonIcon.SetPosition(X, Y);
	}

	return ButtonIcon;
}

simulated function OnHelpButton(UIButtonIconPC Button)
{
	OnHelp();
}

simulated function OnHelp()
{
	local XComPresentationLayerBase Pres;
    local TDialogueBoxData DialogData;

	Pres = `PRESBASE;
    DialogData.eType = eDialog_Normal;
    DialogData.strTitle = m_strHelpTitle;
    DialogData.strText = `XEXPAND.ExpandString(m_strHelpText);
    DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericOK;
    Pres.UIRaiseDialog(DialogData);
}
