//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_AbilityTooltip
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_AbilityTooltip extends UITacticalHUD_AbilityTooltip;

simulated function UIPanel InitAbility(optional name InitName, 
										 optional name InitLibID,
										 optional int InitX = 0, //Necessary for anchoring
										 optional int InitY = 0, //Necessary for anchoring
										 optional int InitWidth = 0)
{
	InitPanel(InitName, InitLibID);

	Hide();

	SetPosition(InitX, InitY);
	InitAnchorX = X; 
	InitAnchorY = Y; 

	if( InitWidth != 0 )
		width = InitWidth;

	//---------------------

	BG = Spawn(class'UIPanel', self).InitPanel('BGBoxSimplAbilities', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple).SetPosition(0, 0).SetSize(width, height);

	BG.SetAlpha(85); // Setting transparency

	// --------------------

	Title = Spawn(class'UIScrollingText', self).InitScrollingText('Title', "", width - PADDING_LEFT - PADDING_RIGHT, PADDING_LEFT, ,true); 

	Line = class'UIUtilities_Controls'.static.CreateDividerLineBeneathControl( Title );

	Keybinding = Spawn(class'UIText', self).InitText('Keybinding');
	Keybinding.SetWidth(width - PADDING_RIGHT); 

	// --------------------

	AbilityArea = Spawn(class'UIPanel', self); 
	AbilityArea.InitPanel('AbilityArea');
	AbilityArea.SetPosition(PADDING_LEFT, Line.Y + ActionsPadding);
	AbilityArea.width = width - PADDING_LEFT - PADDING_RIGHT;
	AbilityArea.height = height - AbilityArea.Y - PADDING_BOTTOM; //This defines the initialwindow, not the actual contents' height. 

	Actions = Spawn(class'UIText', AbilityArea).InitText('Actions');
	Actions.SetWidth(AbilityArea.width); 
	Actions.SetY(ActionsPadding); 

	EndTurn = Spawn(class'UIText', AbilityArea).InitText('EndTurn');
	EndTurn.SetWidth(AbilityArea.width); 
	EndTurn.SetY(ActionsPadding);

	Desc = Spawn(class'UIText', AbilityArea).InitText('Desc');
	Desc.SetWidth(AbilityArea.width); 
	Desc.SetY(Actions.Y + 26);
	Desc.onTextSizeRealized = onTextSizeRealized; 

	Cooldown = Spawn(class'UIText', AbilityArea).InitText('Cooldown');
	Cooldown.SetWidth(AbilityArea.width); 
	//Y loc set in the update data.

	Effect = Spawn(class'UIText', AbilityArea).InitText('Effect');
	Effect.SetWidth(AbilityArea.width); 
	//Y loc set in the update data.

	AbilityMask = Spawn(class'UIMask', self).InitMask('AbilityMask', AbilityArea).FitMask(AbilityArea);

	//--------------------------
	
	return self; 
}

simulated function RefreshData()
{
	local XGUnit				kActiveUnit;
	local XComGameState_Ability	kGameStateAbility;
	local XComGameState_Unit	kGameStateUnit;
	local int					iTargetIndex; 
	local array<string>			Path; 

	if( XComTacticalController(PC) == None )
	{	
		Data = DEBUG_GetUISummary_Ability();
		RefreshDisplay();	
		return; 
	}

	// Only update if new unit
	kActiveUnit = XComTacticalController(PC).GetActiveUnit();

	if( kActiveUnit == none )
	{
		HideTooltip();
		return; 
	} 
	else if( kActiveUnit != none )
	{
		kGameStateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kActiveUnit.ObjectID));
	}

	Path = SplitString( currentPath, "." );	
	iTargetIndex = int(GetRightMost(Path[5]));
	kGameStateAbility = UITacticalHUD(Movie.Stack.GetScreen(class'UITacticalHUD')).m_kAbilityHUD.GetAbilityAtIndex(iTargetIndex);
	
	if( kGameStateAbility == none )
	{
		HideTooltip();
		return; 
	}

	Data = GetSummaryAbility(kGameStateAbility, kGameStateUnit);
	RefreshDisplay();	
}

simulated function RefreshSizeAndScroll()
{
	local int iCalcNewHeight;
	local int MaxAbilityHeight;
	
	AbilityArea.ClearScroll();

	if (Data.bEndsTurn)
		Desc.SetY(Actions.Y + 26);
	else
		Desc.SetY(ActionsPadding);
	
	if (Data.CooldownTime > 0)
		AbilityArea.height = Desc.Y + Desc.height + Cooldown.Height; 
	else 
		AbilityArea.height = Desc.Y + Desc.height + PADDING_BOTTOM;

	iCalcNewHeight = AbilityArea.Y + AbilityArea.height; 
	MaxAbilityHeight = MAX_HEIGHT - AbilityArea.Y;

	if(iCalcNewHeight != height)
	{
		height = iCalcNewHeight;  
		if( height > MAX_HEIGHT )
			height = MAX_HEIGHT; 

		Cooldown.SetY(Desc.Y + Desc.height);
		Effect.SetY(Cooldown.Y);
	}

	if(AbilityArea.height < MaxAbilityHeight)
		AbilityMask.SetSize(AbilityArea.width, AbilityArea.height); 
	else
		AbilityMask.SetSize(AbilityArea.width, MaxAbilityHeight - PADDING_BOTTOM); 

	AbilityArea.AnimateScroll(AbilityArea.height, AbilityMask.height);

	BG.SetSize(width, height);
	SetY( InitAnchorY - height );
}

simulated function UISummary_Ability GetSummaryAbility(XComGameState_Ability kGameStateAbility, XComGameState_Unit kGameStateUnit)
{
	local UISummary_Ability AbilityData;
	local X2AbilityTemplate Template;

	// First, get all of the template-relevant data in here. 
	Template = kGameStateAbility.GetMyTemplate();
	if (Template != None)
	{
		AbilityData = Template.GetUISummary_Ability(); 		
	}

	// Now, fill in the instance data. 
	AbilityData.Name = kGameStateAbility.GetMyFriendlyName();
	if (Template.bUseLaunchedGrenadeEffects || Template.bUseThrownGrenadeEffects)
		AbilityData.Description = kGameStateAbility.GetMyHelpText(kGameStateUnit);
	else if (Template.HasLongDescription())
		AbilityData.Description = Template.GetMyLongDescription(kGameStateAbility, kGameStateUnit);
	else
		AbilityData.Description = Template.GetMyHelpText(kGameStateAbility, kGameStateUnit);
	
	if (AbilityData.Description == "")
		AbilityData.Description = "MISSING ALL HELP TEXT";

	//TODO: @gameplay fill in somma dat data. 
	// Since this was never done. I'm doing it! -tjnome!
	AbilityData.CooldownTime = 0;
	if (kGameStateAbility.GetMyTemplate().AbilityCooldown != none)
		AbilityData.CooldownTime = kGameStateAbility.GetMyTemplate().AbilityCooldown.iNumTurns; // Cooldown from AbilityCooldown
	
	//AbilityData.ActionCost = kGameStateAbility.GetMyTemplate().AbilityCosts.Length; // Ability Cost
	AbilityData.ActionCost = 0;

	AbilityData.bEndsTurn = kGameStateAbility.GetMyTemplate().WillEndTurn(kGameStateAbility, kGameStateUnit); // Will End Turn

	AbilityData.EffectLabel = ""; //TODO "Reflex" etc.

	AbilityData.KeybindingLabel = "<KEY>"; //TODO

	return AbilityData; 
}