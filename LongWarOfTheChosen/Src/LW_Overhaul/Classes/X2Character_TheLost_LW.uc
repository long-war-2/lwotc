//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_TheLost_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Defines all Long War lost-specific Characters
//---------------------------------------------------------------------------------------
class X2Character_TheLost_LW extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP10_LW', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP11_LW', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP12_LW', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP13_LW', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP14_LW', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP15_LW', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP16_LW', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP18_LW', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP21_LW', 'TheLostBruteTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP23_LW', 'TheLostBruteTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP25_LW', 'TheLostBruteTier4_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP2_LW', 'TheLostGrapplerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP3_LW', 'TheLostGrapplerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP4_LW', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP5_LW', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP6_LW', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP7_LW', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP8_LW', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP9_LW', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP10_LW', 'TheLostGrapplerTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP11_LW', 'TheLostGrapplerTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('TheLostGrapplerHP12_LW', 'TheLostGrapplerTier4_Loadout'));

    return Templates;
}

static function X2CharacterTemplate CreateTemplate_TheLostGrappler(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = class'X2Character_DefaultCharacters'.static.CreateTemplate_TheLost(LostName, LoadoutName);
	CharTemplate.CharacterGroupName = 'TheLost';
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Howler");
	CharTemplate.AIOrderPriority = 100;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostBrute(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = class'X2Character_DefaultCharacters'.static.CreateTemplate_TheLost(LostName, LoadoutName);
	CharTemplate.CharacterGroupName = 'TheLost';
	CharTemplate.SightedNarrativeMoments.Length = 0;
	CharTemplate.Abilities.AddItem('WallBreaking');
	CharTemplate.strPawnArchetypes.Length = 0;
	if (class'Helpers_LW'.default.bWorldWarLostActive)
	{
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Brute.Archetypes.ARC_GameUnit_TheLost_CXBrute"); //Brute Lost
	}
	else
	{
		CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Howler");
	}

	return CharTemplate;
}
