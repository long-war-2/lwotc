//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_TheLost_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Defines all Long War lost-specific Characters
//---------------------------------------------------------------------------------------
class X2Character_TheLost_LW extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP10', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP11', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP12', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP13', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP14', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP15', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP16', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP18', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP21', 'TheLostBruteTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP23', 'TheLostBruteTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('LW_TheLostBruteHP25', 'TheLostBruteTier4_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP2', 'TheLostGrapplerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP3', 'TheLostGrapplerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP4', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP5', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP6', 'TheLostGrapplerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP7', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP8', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP9', 'TheLostGrapplerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP10', 'TheLostGrapplerTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP11', 'TheLostGrapplerTier4_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostGrappler('LW_TheLostGrapplerHP12', 'TheLostGrapplerTier4_Loadout'));

    return Templates;
}

static function X2CharacterTemplate CreateTemplate_TheLostGrappler(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = class'X2Character_DefaultCharacters'.static.CreateTemplate_TheLost(LostName, LoadoutName);
	
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Howler");
	CharTemplate.AIOrderPriority = 100;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostBrute(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = class'X2Character_DefaultCharacters'.static.CreateTemplate_TheLost(LostName, LoadoutName);
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("LW_Lost_Brute.Archetypes.ARC_GameUnit_TheLost_CXBrute"); //Brute Lost
	CharTemplate.SightedNarrativeMoments.Length = 0;
	CharTemplate.Abilities.AddItem('WallBreaking');

	return CharTemplate;
}
