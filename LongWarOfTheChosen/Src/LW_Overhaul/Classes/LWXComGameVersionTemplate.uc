//---------------------------------------------------------------------------------------
//  FILE:    LWXComGameVersionTemplate.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Version information for the LW2 XComGame replacement.
//
//  This is implemented as a template to allow mods to detect whether the LW2 XComGame replacement
//  is installed, independent of LW2 itself. It's a template to avoid needing to compile against any
//  new sources to get mods to build (which would then crash the game if it tried to access a function
//  or variable that wasn't installed anyway). Can be queried by:
//
//  1) Query the StrategyElementTemplateManager for a template named 'LWXComGameVersion'. If you get back
//     a non-none result the XcomGame replacement is installed (or someone is lying and added the template without
//     the actual XComGame replacement...)
//  2) If you need more fine-grained info, such as the particular version, then once you get back a non-none
//     result you can cast it to class 'LWXComGameVersionTemplate' to get the version number through the API below.
//
//  Don't directly look up the template and cast it without checking if you got a non-none result or the game will
//  probably crash when the replacement XComGame isn't present.
//
//  Supports major, minor, and build versions, but build is currently unimplemented.
//---------------------------------------------------------------------------------------
class LWXComGameVersionTemplate extends X2StrategyElementTemplate;

var int MajorVersion;
var int MinorVersion;

// "Short" version number (minus the build)
function String GetShortVersionString()
{
    return default.MajorVersion $ "." $ default.MinorVersion;
}

// Version number in string format.
function String GetVersionString()
{
    return default.MajorVersion $ "." $ default.MinorVersion $ "." $ "0"; // Build number not implemented
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
function int GetVersionNumber(optional out int Major, optional out int Minor, optional out int Build)
{
    Major = default.MajorVersion;
    Minor = default.MinorVersion;
    Build = 0; // Build number not implemented
    return (default.MajorVersion * 100000000) + (default.MinorVersion * 1000000) + 0; // Build number not implemented
}

defaultproperties
{
    MajorVersion = 1;
    MinorVersion = 5;
}
