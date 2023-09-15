//---------------------------------------------------------------------------------------
//  FILE:    X2LWCharactersModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing character templates, for example to add "sighted"
//           events to new LWOTC enemies so that the tutorial can hook into them.
//---------------------------------------------------------------------------------------
class X2LWCharactersModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

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
}

defaultproperties
{
	CharacterTemplateModFn=UpdateCharacters
}
