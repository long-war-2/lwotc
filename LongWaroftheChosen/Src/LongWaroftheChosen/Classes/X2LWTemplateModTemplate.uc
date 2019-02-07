//---------------------------------------------------------------------------------------
//  FILE:    X2LWTemplateModTemplate.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: "Meta" templates to allow modification to existing templates on game launch.
//---------------------------------------------------------------------------------------

class X2LWTemplateModTemplate extends X2StrategyElementTemplate;

var Delegate<CharacterTemplateMod> CharacterTemplateModFn;
var Delegate<ItemTemplateMod> ItemTemplateModFn;
var Delegate<StrategyElementTemplateMod> StrategyElementTemplateModFn;
var Delegate<AbilityTemplateMod> AbilityTemplateModFn;
var Delegate<MissionNarrativeTemplateMod> MissionNarrativeTemplateModFn;
var Delegate<SoldierClassTemplateMod> SoldierClassTemplateModFn;
var Delegate<HackRewardTemplateMod> HackRewardTemplateModFn;

// Uncomment these when we need them.

/*
var Delegate<AmbientNarrativeCriteriaTemplateMod> AmbientNarrativeCriteriaTemplateModFn;
var Delegate<BodyPartTemplateMod> BodyPartTemplateModFn;
var Delegate<EncyclopediaTemplateMod> EncyclopediaTemplateModFn;
var Delegate<MissionNarrativeTemplateMod> MissionNarrativeTemplateModFn;
var Delegate<MissionTemplateMod> MissionTemplateModFn;

*/

delegate CharacterTemplateMod(X2CharacterTemplate Template, int Difficulty);
delegate ItemTemplateMod(X2ItemTemplate Template, int Difficulty);
delegate StrategyElementTemplateMod(X2StrategyElementTemplate Template, int Difficulty);
delegate AbilityTemplateMod(X2AbilityTemplate Template, int Difficulty);
delegate MissionNarrativeTemplateMod(X2MissionNarrativeTemplate Template);
delegate SoldierClassTemplateMod(X2SoldierClassTemplate Template, int Difficulty);
delegate HackRewardTemplateMod(X2HackRewardTemplate Template, int Difficulty);