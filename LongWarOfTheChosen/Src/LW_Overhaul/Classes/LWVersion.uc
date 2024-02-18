//---------------------------------------------------------------------------------------
//  FILE:    LWVersion
//  AUTHOR:  tracktwo / LWS
//
//  PURPOSE: Version utilities. See also the 'GetLWVersion' event hook with a listener
//           defined in XComGameState_LWListenerManager.
//--------------------------------------------------------------------------------------- 

class LWVersion extends Object;

// Configurable Major/Minor versions. Set in LW_Overhaul.ini
var int MajorVersion;
var int MinorVersion;
var int PatchVersion;
var string Classifier;

// "Short" version number (minus the classifier)
function static String GetShortVersionString()
{
    return default.MajorVersion $ "." $ default.MinorVersion $ "." $ default.PatchVersion;
}

// Version number in string format.
function static String GetVersionString()
{
    return default.MajorVersion $ "." $ default.MinorVersion $ "." $ default.PatchVersion $ (default.Classifier != "" ? (" " $ default.Classifier) : "");
}

// Version number in comparable numeric format. Number in decimal is MMmmBBBBBB where:
// "M" is major version, in hundreds of millions position
// "m" is minor version, in millions position
// "B" is build number, in ones position
//
// Allows for approx. 2 digits of major and minor versions and 999,999 builds before overflowing.
//
// Optional params take individual components of the version
//
// Note: build number currently disabled and is always 0.
function static int GetVersionNumber(optional out int Major, optional out int Minor, optional out int Build)
{
    Major = default.MajorVersion;
    Minor = default.MinorVersion;
    Build = 0; //class'LWBuildNumber'.const.BuildNumber;
    return (default.MajorVersion * 100000000) + (default.MinorVersion * 1000000) + 0; //class'LWBuildNumber'.const.BuildNumber;
}

defaultproperties
{
    MajorVersion = 1;
    MinorVersion = 1;
    PatchVersion = 1;
    Classifier = "Beta v18"

}
