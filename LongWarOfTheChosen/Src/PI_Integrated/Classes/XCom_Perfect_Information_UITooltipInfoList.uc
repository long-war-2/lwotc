//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITooltipInfoList
//	Author: tjnome, morionicidiot
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITooltipInfoList extends UITooltipInfoList config(PerfectInformation);

var config bool SHOW_EXTRA_WEAPONSTATS;

simulated function RefreshDisplay(array<UISummary_ItemStat> SummaryItems)
{
	local int i;
	local UIText LabelField, DescriptionField;

	if( SummaryItems.Length == 0 )
	{
		Hide();
		Height = 0;
		OnTextSizeRealized();
		return;
	}

	if( TitleTextField == none )
	{
		TitleTextField = Spawn(class'UIScrollingText', self).InitScrollingText('Title', "", width - PADDING_RIGHT - PADDING_LEFT, PADDING_LEFT);
	}
	TitleTextField.SetHTMLText(class'UIUtilities_Text'.static.StyleText(SummaryItems[0].Label, SummaryItems[0].LabelStyle));
	
	for( i = 1; i < SummaryItems.Length; i++ )
	{
		// Place new items if we need to. 
		if( i > LabelFields.Length)
		{
			LabelField = Spawn(class'UIText', self).InitText(Name("Label"$i));
			LabelField.SetWidth(Width - PADDING_LEFT - PADDING_RIGHT);
			LabelField.SetX(PADDING_LEFT);
			LabelFields.AddItem(LabelField);

			DescriptionField = Spawn(class'UIText', self).InitText(Name("Description"$i));
			DescriptionField.SetWidth(Width - PADDING_LEFT - PADDING_RIGHT);
			DescriptionField.SetX(PADDING_LEFT);
			DescriptionFields.AddItem(DescriptionField);
		}

		//Hijack to add stats changes.
		LabelField = LabelFields[i - 1];
		LabelField.SetHTMLText(class'UIUtilities_Text'.static.StyleText(SummaryItems[i].Label, SummaryItems[i].LabelStyle), OnChildTextRealized);
		LabelField.Show();
		LabelField.AnimateIn();

		DescriptionField = DescriptionFields[i - 1];
		DescriptionField.SetHTMLText(class'UIUtilities_Text'.static.StyleText(SummaryItems[i].Value $ GetExtraWeaponStats(SummaryItems[i].Label), SummaryItems[i].ValueStyle), OnChildTextRealized);
		DescriptionField.Show();
		DescriptionField.AnimateIn();
	}

	// Hide any excess list items if we didn't use them. 
	for( i = SummaryItems.Length; i < LabelFields.Length; i++ )
	{
		LabelFields[i].Hide();
		DescriptionFields[i].Hide();
	}

	OnChildTextRealized();
}

function string GetExtraWeaponStats(string label)
{
	local XGUnit kActiveUnit;
	local XComGameState_Unit kGameStateUnit;
	local XComGameState_Item kPrimaryWeapon;
	local GameRulesCache_VisibilityInfo VisInfo; // Aim Upgrades require VisibilityInfo since the aim benefit changes based on current cover state of the target

	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local int i, tmp;

	if (SHOW_EXTRA_WEAPONSTATS)
	{
		kActiveUnit = XComTacticalController(PC).GetActiveUnit();
		kGameStateUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kActiveUnit.ObjectID));
		kPrimaryWeapon = kGameStateUnit.GetPrimaryWeapon();
		UpgradeTemplates = kPrimaryWeapon.GetMyWeaponUpgradeTemplates();

		for (i = 0; i < UpgradeTemplates.Length; ++i)
		{
			if (UpgradeTemplates[i].GetItemFriendlyName() == label)
			{
				if(UpgradeTemplates[i].AddHitChanceModifierFn != none)
				{
					UpgradeTemplates[i].AddHitChanceModifierFn(UpgradeTemplates[i], VisInfo, tmp);
					return ": +" $ tmp $ "%";
				}

				if (UpgradeTemplates[i].AddCritChanceModifierFn != None)
				{
					UpgradeTemplates[i].AddCritChanceModifierFn(UpgradeTemplates[i], tmp);
					return ": +" $ tmp $ "%";
				}

				if(UpgradeTemplates[i].AdjustClipSizeFn != none)
				{
					UpgradeTemplates[i].AdjustClipSizeFn(UpgradeTemplates[i], kPrimaryWeapon, 0, tmp); // we only want the modifier, so pass 0 for current
					return ": +" $ tmp;
				}
				if (UpgradeTemplates[i].FreeFireChance > 0)
					return ": " $ UpgradeTemplates[i].FreeFireChance $ "%";

				if (UpgradeTemplates[i].NumFreeReloads > 0)
					return ": " $ UpgradeTemplates[i].NumFreeReloads;

				if (UpgradeTemplates[i].BonusDamage.Damage > 0)
					return ": " $ UpgradeTemplates[i].BonusDamage.Damage;

				if (UpgradeTemplates[i].FreeKillChance > 0)
					return ": " $ UpgradeTemplates[i].FreeKillChance $ "%";
			}
		}
	}
	return "";
}