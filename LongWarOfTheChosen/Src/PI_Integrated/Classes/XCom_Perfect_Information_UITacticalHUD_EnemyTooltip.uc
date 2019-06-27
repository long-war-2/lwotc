//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_EnemyTooltip
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_EnemyTooltip extends UITacticalHUD_EnemyTooltip config(PerfectInformation);

var int StatsWidth;

//var private UIAbilityList AbilityList;
var public UIMask BodyMask;

var localized string PrimaryBase, PrimarySpread, PrimaryPlusOne;


simulated function UIPanel InitEnemyStats(optional name InitName, optional name InitLibID)
{
	InitPanel(InitName, InitLibID);

	height = StatsHeight + PaddingBetweenBoxes;

	Hide();

	// --------------------

	BodyArea = Spawn(class'UIPanel', self);
	BodyArea.InitPanel('BodyArea').SetPosition(0, 0);
	BodyArea.width = StatsWidth;
	BodyArea.height = StatsHeight;
	BodyArea.SetAlpha(85); // Setting transparency

	Spawn(class'UIPanel', BodyArea).InitPanel('BGBoxSimple', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple).SetSize(BodyArea.width, BodyArea.height);

	Title = Spawn(class'UIText', BodyArea).InitText('Title');
	Title.SetPosition(PADDING_LEFT + 10, PADDING_TOP);
	Title.SetSize(width - PADDING_LEFT - PADDING_RIGHT + 10, 32);

	Line = class'UIUtilities_Controls'.static.CreateDividerLineBeneathControl(Title);

	StatList = Spawn(class'UIStatList', BodyArea);
	StatList.InitStatList('StatList',, PADDING_LEFT, PADDING_TOP + 36, BodyArea.width-PADDING_RIGHT, BodyArea.height-PADDING_BOTTOM, class'UIStatList'.default.PADDING_LEFT, class'UIStatList'.default.PADDING_RIGHT/2);

	BodyMask = Spawn(class'UIMask', BodyArea).InitMask('Mask', StatList).FitMask(StatList);

	//Re-enabling EnemyToolTip
	return self; 
}

simulated function ShowTooltip()
{
	local int ScrollHeight;

	if (RefreshData())
	{
		ScrollHeight = (StatList.height > StatList.height ) ? StatList.height : StatList.height; 
		BodyArea.AnimateScroll( ScrollHeight, BodyMask.height);

		//AbilityList.Show(); 
		super.ShowTooltip();
	}
}


simulated function HideTooltip( optional bool bAnimateIfPossible = false )
{
	super.HideTooltip(bAnimateIfPossible);
	BodyArea.ClearScroll();
}

simulated function bool RefreshData()
{
	local XGUnit				ActiveUnit;
	local XComGameState_Unit	GameStateUnit;
	local int					iTargetIndex;
	local array<string>			Path;

	if( XComTacticalController(PC) == None )
	{
		//StatList.RefreshData( DEBUG_GetStats() );
		//AbilityList.RefreshData( DEBUG_GetUISummary_Abilities() );
		return true;
	}
	
	Path = SplitString(currentPath, ".");
	iTargetIndex = int(Split(Path[5], "icon", true));
	ActiveUnit = XGUnit(XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kEnemyTargets.GetEnemyAtIcon(iTargetIndex));

	if( ActiveUnit == none )
	{
		HideTooltip();
		return false; 
	} 
	else if( ActiveUnit != none )
	{
		GameStateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ActiveUnit.ObjectID));
	}
	
	StatList.RefreshData( GetEnemyStats(GameStateUnit) );
	//AbilityList.RefreshData( GameStateUnit.GetUISummary_Abilities() );

	return true;
}

simulated function array<UISummary_ItemStat> GetEnemyStats( XComGameState_Unit kGameStateUnit )
{
	local array<UISummary_ItemStat> Stats; 
	local UISummary_ItemStat Item; 
	local EUISummary_UnitStats Summary;

	Summary = kGameStateUnit.GetUISummary_UnitStats();

	//Hack!

	Title.SetHTMLText( class'UIUtilities_Text'.static.StyleText(Summary.UnitName, eUITextStyle_Tooltip_Title) );

	Item.Label = default.PrimaryBase;
	Item.Value = string(X2WeaponTemplate(kGameStateUnit.GetPrimaryWeapon().GetMyTemplate()).BaseDamage.Damage);
	Stats.AddItem(Item); 

	Item.Label = default.PrimarySpread;
	Item.Value = string(X2WeaponTemplate(kGameStateUnit.GetPrimaryWeapon().GetMyTemplate()).BaseDamage.Spread);
	Stats.AddItem(Item); 

	Item.Label = default.PrimaryPlusOne;
	Item.Value = string(X2WeaponTemplate(kGameStateUnit.GetPrimaryWeapon().GetMyTemplate()).BaseDamage.PlusOne);
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.HealthLabel;
	Item.Value = class'UIUtilities_Colors'.static.ColorString(Summary.CurrentHP $"/" $Summary.MaxHP, ColorHP(Summary.CurrentHP, Summary.MaxHP)); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.DefenseLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Defense), kGameStateUnit.GetCurrentStat(eStat_Defense));  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.AimLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Offense), kGameStateUnit.GetCurrentStat(eStat_Offense)); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.CritLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_CritChance), kGameStateUnit.GetCurrentStat(eStat_CritChance));
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.DodgeLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Dodge), kGameStateUnit.GetCurrentStat(eStat_Dodge));
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.ArmorLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_ArmorMitigation), kGameStateUnit.GetCurrentStat(eStat_ArmorMitigation));
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.PierceLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_ArmorPiercing), kGameStateUnit.GetCurrentStat(eStat_ArmorPiercing));
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.MobilityLabel;
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Mobility), kGameStateUnit.GetCurrentStat(eStat_Mobility));
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.TechLabel; 
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Hacking), kGameStateUnit.GetCurrentStat(eStat_Hacking)); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.TechLabel $ " " $ class'XLocalizedData'.default.DefenseLabel; 
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_HackDefense), kGameStateUnit.GetCurrentStat(eStat_HackDefense)); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.WillLabel; 
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_Will), kGameStateUnit.GetCurrentStat(eStat_Will));  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.PsiOffenseLabel; 
	Item.Value = ColorAndStringForStats(kGameStateUnit.GetBaseStat(eStat_PsiOffense), kGameStateUnit.GetCurrentStat(eStat_PsiOffense)); 
	Stats.AddItem(Item); 

	return Stats;
}

function string ColorAndStringForStats(int statbase, int statcurrent) 
{
	local Color Tcolor;
	local string CText;

	CText = "(" $ StatChange(statbase, statcurrent) $ ")"; 
	
	if ((statbase - statcurrent) == 0) 
		return string(statbase);

	Tcolor = StatChangeColor(statbase, statcurrent);

	return (statbase $ " " $ class'UIUtilities_Colors'.static.ColorString(CText, Tcolor));
} 

function string StatChange(int statbase, int statcurrent)  
{
	if (statbase > statcurrent) 
		return "-" $ (statbase - statcurrent);

	else
		return "+" $ (statcurrent - statbase);
}

function Color ColorHP(float CurrentHP, float MaxHP) 
{

	if (CurrentHP/MaxHP > 0.66) 
		return MakeColor(83,180,94,0);

	else if (CurrentHP/MaxHP < 0.33) 
		return MakeColor(191,30,46,0);

	else 
		return MakeColor(200,100,0,0);
}

function Color StatChangeColor(Float BaseStat, Float CurrentStat)
{
	if (BaseStat > CurrentStat) 
		return MakeColor(191,30,46,0);

	else 
		return MakeColor(83,180,94,0);

}



//Defaults: ------------------------------------------------------------------------------
defaultproperties
{
	StatsWidth = 255;
	width = 350;
	height = 500; 
	StatsHeight = 390;
	AbilitiesHeight = 300; 
	PaddingBetweenBoxes = 10;
	PaddingForAbilityList = 4;

	PADDING_LEFT	= 0;
	PADDING_RIGHT	= 0;
	PADDING_TOP		= 10;
	PADDING_BOTTOM	= 10;
}