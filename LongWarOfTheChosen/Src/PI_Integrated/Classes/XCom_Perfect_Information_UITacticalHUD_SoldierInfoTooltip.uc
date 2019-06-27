//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_SoldierInfoTooltip
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_SoldierInfoTooltip extends UITacticalHUD_SoldierInfoTooltip config(PerfectInformation);

var localized string KILLS_LABEL;
var localized string ASSIST_LABEL;
var localized string FLANKING_CRIT_LABEL;

struct UnitStats_SoldierInfo
{
	var int CurrentHP, MaxHP;
	var int BaseAim, CurrentAim;
	var int BaseCrit, CurrentCrit;
	var int BaseDodge, CurrentDodge;
	var int BaseDefense, CurrentDefense;
	var int BaseArmor, CurrentArmor;
	var int BaseArmorPiercing, CurrentArmorPiercing;
	var int BaseMobility, CurrentMobility;
	var int BaseHacking, CurrentHacking;
	var int BaseHackingDefense, CurrentHackingDefense;
	var int BaseWill, CurrentWill;
	var int BasePsiOffense, CurrentPsiOffense;
	var string UnitName; 
	var int Xp;
	var float XpShares;
	var float SquadXpShares;
	var float EarnedPool;

	structdefaultproperties
	{
		UnitName="";
	}
};

simulated function UIPanel InitSoldierStats(optional name InitName, optional name InitLibID)
{
	InitPanel(InitName, InitLibID);

	if (`CHEATMGR != none && `CHEATMGR.bDebugXp)
	{
		StatsHeight = default.StatsHeight + 100;
		PADDING_BETWEEN_PANELS = default.PADDING_BETWEEN_PANELS + 100;
	}

	width = StatsWidth; 
	height = StatsHeight + PADDING_BETWEEN_PANELS; 

	Hide();

	// -------------------------

	BodyArea = Spawn(class'UIPanel', self); 
	BodyArea.InitPanel('BodyArea').SetPosition(0, 0);
	BodyArea.width = StatsWidth;
	BodyArea.height = StatsHeight;
	BodyArea.SetAlpha(85); // Setting transparency

	Spawn(class'UIPanel', BodyArea).InitPanel('BGBoxSimple', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple).SetSize(StatsWidth, StatsHeight);
	
	
	StatList = Spawn(class'UIStatList', BodyArea);
	StatList.InitStatList('StatList',, PADDING_LEFT, PADDING_TOP, StatsWidth-PADDING_RIGHT, BodyArea.height-PADDING_BOTTOM, class'UIStatList'.default.PADDING_LEFT, class'UIStatList'.default.PADDING_RIGHT/2);

	BodyMask = Spawn(class'UIMask', BodyArea).InitMask('Mask', StatList).FitMask(StatList); 

	return self; 
}

simulated function ShowTooltip()
{
	local int ScrollHeight;

	//Trigger only on the correct hover item 
	if( class'XCom_Perfect_Information_UITacticalHUD_BuffsTooltip'.static.IsPathBonusOrPenaltyMC(currentPath) ) return;

	RefreshData();
	
	ScrollHeight = (StatList.height > StatList.height ) ? StatList.height : StatList.height; 
	BodyArea.AnimateScroll( ScrollHeight, BodyMask.height);

	super.ShowTooltip();
}


simulated function HideTooltip( optional bool bAnimateIfPossible = false )
{
	super.HideTooltip(bAnimateIfPossible);
	BodyArea.ClearScroll();
}

simulated function RefreshData()
{
	local XGUnit				kActiveUnit;
	local XComGameState_Unit	kGameStateUnit;
	
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
	
	StatList.RefreshData( GetSoldierStats(kGameStateUnit) );
}

simulated function array<UISummary_ItemStat> GetSoldierStats(XComGameState_Unit kGameStateUnit)
{
	local array<UISummary_ItemStat> Stats; 
	local UISummary_ItemStat Item; 
	local UnitStats_SoldierInfo Summary;
	local XComGameState_Unit BackInTimeGameStateUnit;
	local int NewKills, CurrentKills, NewAssist, CurrentAssist;

	Summary = GetUnitStats(kGameStateUnit);

	BackInTimeGameStateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kGameStateUnit.ObjectID, , 1));

	//Hack!

	//Title.SetHTMLText( class'UIUtilities_Text'.static.StyleText(Summary.UnitName, eUITextStyle_Tooltip_Title) );

	Item.Label = class'XLocalizedData'.default.HealthLabel;
	Item.Value = class'UIUtilities_Colors'.static.ColorString(Summary.CurrentHP $"/" $Summary.MaxHP, ColorHP(Summary.CurrentHP, Summary.MaxHP)); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.AimLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseAim, Summary.CurrentAim); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.CritLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseCrit, Summary.CurrentCrit); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.DodgeLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseDodge, Summary.CurrentDodge); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.DefenseLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseDefense, Summary.CurrentDefense);  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.ArmorLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseArmor, Summary.CurrentArmor);  
	Stats.AddItem(Item);

	// Need to calculate Newkills and CurrentKills on Mission. Easier to read with good values.
	NewKills = (kGameStateUnit.GetNumKills() - BackInTimeGameStateUnit.GetNumKills());
	CurrentKills = (kGameStateUnit.GetNumKills() - NewKills);

	Item.Label = KILLS_LABEL;
	if (NewKills > 0)
		Item.Value = CurrentKills $ ColorForSingelPositiveStat(" (+" $ NewKills $ ")");
	else 
		Item.Value = CurrentKills $ ColorForSingelPositiveStat(" (" $ NewKills $ ")");
	Stats.AddItem(Item);

	// Need to calculate NewAssist and CurrentAssist on Mission. Easier to read with good values.
	NewAssist = (kGameStateUnit.GetNumKillsFromAssists() - BackInTimeGameStateUnit.GetNumKillsFromAssists());
	CurrentAssist = (kGameStateUnit.GetNumKillsFromAssists() - NewAssist);

	Item.Label = ASSIST_LABEL;
	if (NewAssist > 0)
		Item.Value = CurrentAssist $ ColorForSingelPositiveStat(" (+" $ NewAssist $ ")");
	else 
		Item.Value = CurrentAssist $ ColorForSingelPositiveStat(" (" $ NewAssist $ ")");
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.PierceLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseArmorPiercing, Summary.CurrentArmorPiercing);  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.MobilityLabel;
	Item.Value = ColorAndStringForStats(Summary.BaseMobility, Summary.CurrentMobility); 
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.TechLabel; 
	Item.Value = ColorAndStringForStats(Summary.BaseHacking, Summary.CurrentHacking);  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.TechLabel $ " " $ class'XLocalizedData'.default.DefenseLabel; 
	Item.Value = ColorAndStringForStats(Summary.BaseHackingDefense, Summary.CurrentHackingDefense);  
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.WillLabel; 
	Item.Value = ColorAndStringForStats(Summary.BaseWill, Summary.CurrentWill);
	Stats.AddItem(Item);

	Item.Label = class'XLocalizedData'.default.PsiOffenseLabel; 
	Item.Value = ColorAndStringForStats(Summary.BasePsiOffense, Summary.CurrentPsiOffense); 
	Stats.AddItem(Item);

	return Stats;
}

simulated function UnitStats_SoldierInfo GetUnitStats(XComGameState_Unit kGameStateUnit)
{
	//local XComGameState_XpManager XpMan;
	local UnitStats_SoldierInfo Summary; 
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local X2Effect_Persistent EffectTemplate;

	// HP
	Summary.CurrentHP = kGameStateUnit.GetCurrentStat(eStat_HP);
	Summary.MaxHP = kGameStateUnit.GetMaxStat(eStat_HP);
	// AIM
	Summary.BaseAim = kGameStateUnit.GetBaseStat(eStat_Offense);
	Summary.CurrentAim = kGameStateUnit.GetCurrentStat(eStat_Offense);
	// CRIT
	Summary.BaseCrit = kGameStateUnit.GetBaseStat(eStat_CritChance);
	Summary.CurrentCrit = kGameStateUnit.GetCurrentStat(eStat_CritChance);
	// DODGE
	Summary.BaseDodge = kGameStateUnit.GetBaseStat(eStat_Dodge);
	Summary.CurrentDodge = kGameStateUnit.GetCurrentStat(eStat_Dodge);
	// DEFENSE
	Summary.BaseDefense = kGameStateUnit.GetBaseStat(eStat_Defense);
	Summary.CurrentDefense = kGameStateUnit.GetCurrentStat(eStat_Defense);
	// ARMOR
	Summary.BaseArmor = kGameStateUnit.GetBaseStat(eStat_ArmorMitigation);
	Summary.CurrentArmor = kGameStateUnit.GetCurrentStat(eStat_ArmorMitigation);
	// ARMOR PIERCING 
	Summary.BaseArmorPiercing = kGameStateUnit.GetBaseStat(eStat_ArmorPiercing);
	Summary.CurrentArmorPiercing = kGameStateUnit.GetCurrentStat(eStat_ArmorPiercing);
	// MOBILITY
	Summary.BaseMobility = kGameStateUnit.GetBaseStat(eStat_Mobility);
	Summary.CurrentMobility = kGameStateUnit.GetCurrentStat(eStat_Mobility);
	// HACKING
	Summary.BaseHacking = kGameStateUnit.GetBaseStat(eStat_Hacking);
	Summary.CurrentHacking = kGameStateUnit.GetCurrentStat(eStat_Hacking);
	// HACKING DEFENSE
	Summary.BaseHackingDefense = kGameStateUnit.GetBaseStat(eStat_HackDefense);
	Summary.CurrentHackingDefense = kGameStateUnit.GetCurrentStat(eStat_HackDefense);
	// WILL
	Summary.BaseWill = kGameStateUnit.GetBaseStat(eStat_Will);
	Summary.CurrentWill = kGameStateUnit.GetCurrentStat(eStat_Will);
	// PSIOffense
	Summary.BasePsiOffense = kGameStateUnit.GetBaseStat(eStat_PsiOffense);
	Summary.CurrentPsiOffense = kGameStateUnit.GetCurrentStat(eStat_PsiOffense);

	History = `XCOMHISTORY;
	foreach kGameStateUnit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			EffectTemplate = EffectState.GetX2Effect();
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_Offense, Summary.CurrentAim);
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_Hacking, Summary.CurrentHacking);
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_Defense, Summary.CurrentDefense);
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_Will, Summary.CurrentWill);
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_Dodge, Summary.CurrentDodge);
			EffectTemplate.ModifyUISummaryUnitStats(EffectState, kGameStateUnit, eStat_PsiOffense, Summary.CurrentPsiOffense);
		}
	}
	return Summary; 
}


function string ColorForSingelPositiveStat(string text)
{
	
	return (class'UIUtilities_Colors'.static.ColorString(text, MakeColor(83,180,94,0)));
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
	StatsHeight=325;
	StatsWidth=255;

	PADDING_LEFT	= 0;
	PADDING_RIGHT	= 0;
	PADDING_TOP		= 10;
	PADDING_BOTTOM	= 10;
	PADDING_BETWEEN_PANELS = 10;
}
