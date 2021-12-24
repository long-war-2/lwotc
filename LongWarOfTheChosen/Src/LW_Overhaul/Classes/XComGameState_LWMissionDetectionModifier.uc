//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWMissionDetectionModifier.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: 
//---------------------------------------------------------------------------------------
class XComGameState_LWMissionDetectionModifier extends XComGameState_BaseObject;

var protected name							        m_TemplateName;
var protected X2LWMissionDetectionModifierTemplate  m_Template;

var StateObjectReference OwnerOutpostRef;
var TDateTime ExpirationDateTime;

//#############################################################################################
//----------------   REQUIRED FROM BASEOBJECT   -----------------------------------------------
//#############################################################################################

static function X2StrategyElementTemplateManager GetMyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

function name GetMyTemplateName()
{
	return m_TemplateName;
}

function X2LWMissionDetectionModifierTemplate GetMyTemplate()
{
	if (m_Template == none)
	{
		m_Template = X2LWMissionDetectionModifierTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

event OnCreation(optional X2DataTemplate InitTemplate)
{
	m_Template = X2LWMissionDetectionModifierTemplate(InitTemplate);
	m_TemplateName = InitTemplate.DataName;
}

function PostCreateInit(XComGameState NewGameState, StateObjectReference OutpostRef)
{
    OwnerOutpostRef = OutpostRef;

	if (GetMyTemplate().ModifierDurationHours > 0)
	{
		class'X2StrategyGameRulesetDataStructures'.static.CopyDateTime(class'XComGameState_GeoscapeEntity'.static.GetCurrentTime(), ExpirationDateTime);
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(ExpirationDateTime, GetMyTemplate().ModifierDurationHours);
	}
}
