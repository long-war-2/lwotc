//---------------------------------------------------------------------------------------
//  FILE:    X2LWCharactersModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing character templates, for example to add "sighted"
//           events to new LWOTC enemies so that the tutorial can hook into them.
//---------------------------------------------------------------------------------------
class X2LWCharactersModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config array<name> EXCLUDED_CHARACTERS_FROM_GLOBAL_DIFF_MOD;
var config array<float> DIFFICULTY_HP_MODIFIER;
var config array<float> DIFFICULTY_AIM_MODIFIER;
var config array<float> DIFFICULTY_WILL_MODIFIER;
var config int GLOBAL_FLANKING_CRIT_CHANCE;


static function UpdateCharacters(X2CharacterTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'LWDroneM1':
	case 'LWDroneM2':
		Template.SightedEvents.AddItem('DroneSighted');
		break;
	case 'AdvGrenadierM1':
	case 'AdvGrenadierM2':
	case 'AdvGrenadierM3':
		Template.SightedEvents.AddItem('EngineerSighted');
		break;
	case 'AdvSentryM1':
	case 'AdvSentryM2':
	case 'AdvSentryM3':
		Template.SightedEvents.AddItem('SentrySighted');
		break;
	case 'AdvGunnerM1':
	case 'AdvGunnerM2':
	case 'AdvGunnerM3':
		Template.SightedEvents.AddItem('GunnerSighted');
		break;
	case 'AdvRocketeerM1':
	case 'AdvRocketeerM2':
	case 'AdvRocketeerM3':
		Template.SightedEvents.AddItem('RocketeerSighted');
		break;
	case'ChosenAssassin':
	case'ChosenAssassinM2':
	case'ChosenAssassinM3':
	case'ChosenAssassinM4':
		Template.SightedEvents.AddItem('ChosenSighted');
		Template.SightedEvents.AddItem('AssassinSighted');
		break;
	case'ChosenWarlock':
	case'ChosenWarlockM2':
	case'ChosenWarlockM3':
	case'ChosenWarlockM4':
		Template.SightedEvents.AddItem('ChosenSighted');
		Template.SightedEvents.AddItem('WarlockSighted');
	break;
	case'ChosenHunter':
	case'ChosenHunterM2':
	case'ChosenHunterM3':
	case'ChosenHunterM4':
		Template.SightedEvents.AddItem('ChosenSighted');
		Template.SightedEvents.AddItem('HunterSighted');
	break;
	default:
		break;
	}
	StandarizeLootForUnits(Template,Difficulty);
	DoaGlobalStatModifierByDifficulty(Template,Difficulty);

	Template.CharacterBaseStats[eStat_FlankingCritChance] = default.GLOBAL_FLANKING_CRIT_CHANCE;
}

static function DoaGlobalStatModifierByDifficulty(X2CharacterTemplate Template, int Difficulty)
{
	local X2CharacterTemplate HighestDiffTemplate;
	local array<X2DataTemplate> DiffTemplates;
	local X2CharacterTemplateManager TemplateManager;
	local int i;



	if(default.EXCLUDED_CHARACTERS_FROM_GLOBAL_DIFF_MOD.Find(Template.DataName) != INDEX_NONE || Template.bIsSoldier || Template.bIsCivilian)
	{
		return;
	}

	TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	//Get The highest difficulty template

	TemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DiffTemplates);

	HighestDiffTemplate = X2CharacterTemplate(DiffTemplates[3]);

	for (i = 0; i< DiffTemplates.length; i++)
	{
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_HP] = FCeil(HighestDiffTemplate.CharacterBaseStats[eStat_HP] * default.DIFFICULTY_HP_MODIFIER[i]);
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_Offense] = FCeil(HighestDiffTemplate.CharacterBaseStats[eStat_Offense] + default.DIFFICULTY_AIM_MODIFIER[i]);
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_Will] = FCeil(HighestDiffTemplate.CharacterBaseStats[eStat_Will] + default.DIFFICULTY_Will_MODIFIER[i]);
	
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_ArmorMitigation] = HighestDiffTemplate.CharacterBaseStats[eStat_ArmorMitigation];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_CritChance] = HighestDiffTemplate.CharacterBaseStats[eStat_CritChance];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_Defense] = HighestDiffTemplate.CharacterBaseStats[eStat_Defense];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_Dodge] = HighestDiffTemplate.CharacterBaseStats[eStat_Dodge];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_Mobility] = HighestDiffTemplate.CharacterBaseStats[eStat_Mobility];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_PsiOffense] = HighestDiffTemplate.CharacterBaseStats[eStat_PsiOffense];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_HackDefense] = HighestDiffTemplate.CharacterBaseStats[eStat_HackDefense];
		X2CharacterTemplate(DiffTemplates[i]).CharacterBaseStats[eStat_FlankingCritChance] = default.GLOBAL_FLANKING_CRIT_CHANCE;
	
	}

}

static function StandarizeLootForUnits(X2CharacterTemplate Template, int Difficulty)
{
	local LootReference  LootTimed, LootVulture; 

	LootTimed.ForceLevel = 0;
	LootVulture.ForceLevel = 0;

	switch(Template.DataName)
	{
		case'AdvTrooperM1':
		case'SpectreM1':
		case'AdvPriestM1':
		case'AdvPriestM2':
		case'AdvPurifierM1':
		case'AdvPurifierM2':
		case'AdvShieldBearerM2':
		case'Berserker':
		case'Faceless':
		case'Muton':
		case'Sectoid':
		case'Viper':
		case'AdvMec_M1':
		case'AdvStunLancerM1':
		case'AdvStunLancerM2':
		case'AdvTrooperM2':

		Template.TimedLoot.LootReferences.length = 0;
		Template.VultureLoot.LootReferences.length = 0;

		LootTimed.LootTableName='GenericEarlyAlienLoot_LW';
		LootVulture.LootTableName='GenericEarlyAlienVultureLoot_LW';

		Template.TimedLoot.LootReferences.AddItem(LootTimed);
		Template.VultureLoot.LootReferences.AddItem(LootVulture);
		break;
		case'SpectreM2':
		case'AdvPriestM3':
		case'AdvPurifierM3':
		case'AdvShieldBearerM3':
		case'AdvStunLancerM3':
		case'AdvTrooperM3':
		case'AdvMec_M2':
		case'Sectopod':
		case'Andromedon':
		case'Archon':

			Template.TimedLoot.LootReferences.length = 0;
			Template.VultureLoot.LootReferences.length = 0;

			LootTimed.LootTableName='GenericMidAlienLoot_LW';
			LootVulture.LootTableName='GenericMidAlienVultureLoot_LW';

			Template.TimedLoot.LootReferences.AddItem(LootTimed);
			Template.VultureLoot.LootReferences.AddItem(LootVulture);
		
			break;
	}

}

defaultproperties
{
	CharacterTemplateModFn=UpdateCharacters
}
