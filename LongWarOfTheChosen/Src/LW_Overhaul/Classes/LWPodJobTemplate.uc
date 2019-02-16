//---------------------------------------------------------------------------------------
//  FILE:    LWPodJobTemplate.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Template class for managing pod jobs. Allows new jobs to be defined and added
//           to the system.
//---------------------------------------------------------------------------------------
class LWPodJobTemplate extends X2StrategyElementTemplate
    config(LW_PodManager);

var delegate<CreateInstanceFn> CreateInstance;
var delegate<GetNewDestinationFn> GetNewDestination;

delegate XComGameState_LWPodJob CreateInstanceFn(XComGameState NewGameState);
delegate Vector GetNewDestinationFn(XComGameState_LWPodJob Job, XComGameState NewGameState);

