//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_BuffsTooltip
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_BuffsTooltip extends UITacticalHUD_BuffsTooltip;

simulated function UIPanel InitBonusesAndPenalties(optional name InitName, optional name InitLibID, optional bool bIsBonusPanel, optional bool bIsSoldier, optional float InitX = 0, optional float InitY = 0, optional bool bShowOnRight)
{
	InitPanel(InitName, InitLibID);

	Hide();
	SetPosition(InitX, InitY);
	AnchorX = InitX; 
	AnchorY = InitY; 
	ShowOnRightSide = bShowOnRight;

	ShowBonusHeader = bIsBonusPanel;
	IsSoldierVersion = bIsSoldier;
	
	BGBox = Spawn(class'UIPanel', self).InitPanel('BGBoxSimple', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple);
	BGBox.SetWidth(width); // Height set in size callback
	BGBox.SetAlpha(85);	// Setting transparency

	// --------------------------------------------- 
	Header = Spawn(class'UIPanel', self).InitPanel('HeaderArea').SetPosition(PADDING_LEFT,0);
	Header.SetHeight(headerHeight);

	if( bIsBonusPanel )
		HeaderIcon = Spawn(class'UIPanel', Header).InitPanel('BonusIcon', class'UIUtilities_Controls'.const.MC_BonusIcon).SetSize(20,20);
	else
		HeaderIcon = Spawn(class'UIPanel', Header).InitPanel('PenaltyIcon', class'UIUtilities_Controls'.const.MC_PenaltyIcon).SetSize(20,20);
	
	HeaderIcon.SetY(8);

	Title = Spawn(class'UIText', Header).InitText('Title');
	Title.SetPosition(30, 2); 
	Title.SetWidth(width - PADDING_LEFT - HeaderIcon.width); 
	//Title.SetAlpha( class'UIUtilities_Text'.static.GetStyle(eUITextStyle_Tooltip_StatLabel).Alpha );
		
	// --------------------------------------------- 
	
	ItemList = Spawn(class'UIEffectList', self);
	ItemList.InitEffectList('ItemList',
		, 
		PADDING_LEFT, 
		PADDING_TOP + headerHeight, 
		width-PADDING_LEFT-PADDING_RIGHT, 
		Height-PADDING_TOP-PADDING_BOTTOM - headerHeight,
		Height-PADDING_TOP-PADDING_BOTTOM - headerHeight,
		MaxHeight,
		OnEffectListSizeRealized);

	ItemListMask = Spawn(class'UIMask', self).InitMask('Mask', ItemList).FitMask(ItemList); 

	// --------------------------------------------- 

	return self; 
}

simulated function RefreshData()
{
	local XGUnit						kActiveUnit;
	local XComGameState_Unit			kGameStateUnit;
	local int							iTargetIndex; 
	local array<string>					Path;
	local array<UISummary_UnitEffect>	Effects;

	//Trigger on the correct hover item 
	if( XComTacticalController(PC) != None )
	{	
		if(IsSoldierVersion)
		{
			kActiveUnit = XComTacticalController(PC).GetActiveUnit();
		}
		else
		{
			Path = SplitString( currentPath, "." );	
			iTargetIndex = int(Split( Path[5], "icon", true));
			kActiveUnit = XGUnit(XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kEnemyTargets.GetEnemyAtIcon(iTargetIndex));
		}
	}

	// Only update if new unit
	if( kActiveUnit == none )
	{
		if( XComTacticalController(PC) != None )
		{
			HideTooltip();
			return;
		}
	} 
	else if( kActiveUnit != none )
	{
		kGameStateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kActiveUnit.ObjectID));
	}

	if(ShowBonusHeader)
	{
		Effects = GetUnitEffectsByCategory(kGameStateUnit, ePerkBuff_Bonus);
		Title.SetHTMLText(class'UIUtilities_Text'.static.StyleText( class'XLocalizedData'.default.BonusesHeader, eUITextStyle_Tooltip_StatLabel) );
	}
	else
	{
		Effects = GetUnitEffectsByCategory(kGameStateUnit, ePerkBuff_Penalty);
		Title.SetHTMLText(class'UIUtilities_Text'.static.StyleText( class'XLocalizedData'.default.PenaltiesHeader, eUITextStyle_Tooltip_StatLabel) );
	}

	if( Effects.length == 0 )
	{
		if( XComTacticalController(PC) != None )
			HideTooltip();
		else
			ItemList.RefreshData( DEBUG_GetData() );
		return; 
	}

	ItemList.RefreshData(Effects);
	OnEffectListSizeRealized();
}


simulated function array<UISummary_UnitEffect> GetUnitEffectsByCategory(XComGameState_Unit kGameStateUnit, EPerkBuffCategory Category)
{
	local UISummary_UnitEffect Item, EmptyItem;  
	local array<UISummary_UnitEffect> List; 
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent Persist;
	local XComGameStateHistory History;
	local StateObjectReference EffectRef;

	History = `XCOMHISTORY;

	foreach kGameStateUnit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			Persist = EffectState.GetX2Effect();
			if (Persist != none && Persist.bDisplayInUI && Persist.BuffCategory == Category && Persist.IsEffectCurrentlyRelevant(EffectState, kGameStateUnit))
			{
				Item = EmptyItem;
				FillUnitEffect(kGameStateUnit, EffectState, Persist, false, Item);
				List.AddItem(Item);
			}
		}
	}
	foreach kGameStateUnit.AppliedEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			Persist = EffectState.GetX2Effect();
			if (Persist != none && Persist.bSourceDisplayInUI && Persist.SourceBuffCategory == Category && Persist.IsEffectCurrentlyRelevant(EffectState, kGameStateUnit))
			{
				Item = EmptyItem;
				FillUnitEffect(kGameStateUnit, EffectState, Persist, true, Item);
				List.AddItem(Item);
			}
		}
	}
	if (Category == ePerkBuff_Penalty)
	{
		if (kGameStateUnit.GetRupturedValue() > 0)
		{
			Item = EmptyItem;
			Item.AbilitySourceName = 'eAbilitySource_Standard';
			Item.Icon = class 'X2StatusEffects'.default.RuptureIcon;
			Item.Name = class'X2StatusEffects'.default.RupturedFriendlyName;
			Item.Description = class'X2StatusEffects'.default.RupturedFriendlyDesc;
			List.AddItem(Item);
		}
	}

	return List; 
}
simulated function FillUnitEffect(const XComGameState_Unit kGameStateUnit, const XComGameState_Effect EffectState, const X2Effect_Persistent Persist, const bool bSource, out UISummary_UnitEffect Summary)
{
	local X2AbilityTag AbilityTag;

	AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
	AbilityTag.ParseObj = EffectState;

	if (bSource)
	{
		Summary.Name = Persist.SourceFriendlyName;
		Summary.Description = `XEXPAND.ExpandString(Persist.SourceFriendlyDescription $ "\n" $ CooldownDescription(EffectState, Persist));
		//Summary.Description = `XEXPAND.ExpandString(Persist.SourceFriendlyDescription);
		Summary.Icon = Persist.SourceIconLabel;

		if (Persist.bInfiniteDuration)
			Summary.Cooldown = 0;
		else
			Summary.Cooldown = EffectState.iTurnsRemaining;

		Summary.Charges = 0; //TODO @jbouscher @bsteiner
		Summary.AbilitySourceName = Persist.AbilitySourceName;
	}
	else
	{
		Summary.Name = Persist.FriendlyName;
		Summary.Description = `XEXPAND.ExpandString(Persist.FriendlyDescription $ "\n" $ CooldownDescription(EffectState, Persist));
		//Summary.Description = `XEXPAND.ExpandString(Persist.FriendlyDescription);
		Summary.Icon = Persist.IconImage;

		if (Persist.bInfiniteDuration) 
		{
			if (kGameStateUnit.StunnedActionPoints > 0)
				Summary.Cooldown = (class'X2CharacterTemplateManager'.default.StandardActionsPerTurn / kGameStateUnit.StunnedActionPoints);
			else if(kGameStateUnit.StunnedThisTurn > 0 && kGameStateUnit.StunnedActionPoints == 0)
				Summary.Cooldown = -1;
		}
		else
			Summary.Cooldown = EffectState.iTurnsRemaining;

		Summary.Charges = 0; //TODO @jbouscher @bsteiner
		Summary.AbilitySourceName = Persist.AbilitySourceName;
	}

	AbilityTag.ParseObj = None;
}

simulated function string CooldownDescription (const XComGameState_Effect EffectState, const X2Effect_Persistent Persist) 
{
	local XComGameState_Player PlayerState;

	// Adds information if the effect is Persistent of not
	if (Persist.bInfiniteDuration)
		return "Persistent effect";

	// Add information if the turn counter ticks on alien and players turn. 
	//Should probably 2x turns to get a real counter in this case
	if (Persist.bIgnorePlayerCheckOnTick)
		return "Effect ticks on alien and players turn";

	if (Persist.WatchRule == eGameRule_UseActionPoint)
		return "Effect removed after action";
	
	PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.PlayerStateObjectRef.ObjectID));
	return (WatchRule(Persist) @ GetTeam(PlayerState) @ "turn");
	
}

// Get information if it ends on aliens or players turn.
static final function string GetTeam(const XComGameState_Player PlayerState)
{
	switch (PlayerState.GetTeam())
	{
		case eTeam_XCom:
			return "Player's";
			break;
		case eTeam_Alien:
			return "Aliens";
			break;
		case eTeam_Neutral:
			return "Civilians";
			break;
		default:
			return "Player's";
			break;
	}
}

// Get information from WatchRule if the effects on on start/after action/after turn ended.
static final function string WatchRule(const X2Effect_Persistent Persist)
{
	switch (Persist.WatchRule)
	{
		case eGameRule_PlayerTurnBegin:
			return "Ends on the start of";
			break;
		case eGameRule_PlayerTurnEnd:
			return "Ends on the end of";
			break;
		default:
			return "Ends on the start of";
			break;
	}
}