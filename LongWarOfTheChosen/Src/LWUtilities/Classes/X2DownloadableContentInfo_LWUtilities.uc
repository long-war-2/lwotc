//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWSMGPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Officer mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

// This class seems to be required in order for classes in other submods to
// "see" LW_Helpers. Possibly because LW_Helpers has some `config` variables.
// This class *isn't* required for LWUtilities_Ranks to be seen.
class X2DownloadableContentInfo_LWUtilities extends X2DownloadableContentInfo;	
