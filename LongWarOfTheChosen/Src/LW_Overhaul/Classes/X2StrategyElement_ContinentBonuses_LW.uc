class X2StrategyElement_ContinentBonuses_LW extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> bonuses;

	`LWTrace("  >> X2StrategyElement_ContinentBonuses_LW.CreateTemplates()");
	
	bonuses.AddItem(CreateWiredTemplate());

    return bonuses;
}

static function X2DataTemplate CreateWiredTemplate()
{
    local X2GameplayMutatorTemplate Template;

    `CREATE_X2TEMPLATE(class'X2GameplayMutatorTemplate', Template, 'ContinentBonus_Wired');

    Template.Category = "ContinentBonus";
    Template.OnActivatedFn = ActivateWired;
    Template.OnDeactivatedFn = DeactivateWired;
    return Template;
}

static function ActivateWired(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate)
{
   // local XComGameState_HeadquartersXCom XCOMHQ;

    bReactivate = false;
    //XCOMHQ = GetNewXComHQState(NewGameState);
    //XCOMHQ.bReuseUpgrades = true;
}

static function DeactivateWired(XComGameState NewGameState, StateObjectReference InRef)
{
    //local XComGameState_HeadquartersXCom XCOMHQ;

    //XCOMHQ = GetNewXComHQState(NewGameState);
    //XCOMHQ.bReuseUpgrades = false;
}