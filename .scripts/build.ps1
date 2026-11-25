Param(
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath, # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
    [string] $config # build configuration
)

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$common = Join-Path -Path $ScriptDirectory "X2ModBuildCommon\build_common.ps1"
Write-Host "Sourcing $common"
. ($common)

$builder = [BuildProject]::new("LongWarOfTheChosen", $srcDirectory, $sdkPath, $gamePath)

switch ($config)
{
    "debug" {
        $builder.EnableDebug()
    }
    "default" {
        # Nothing special
    }
    "compiletest" {
        # Handled at the end: compiles the scripts only
    }
    "" { ThrowFailure "Missing build configuration" }
    default { ThrowFailure "Unknown build configuration $config" }
}

$builder.AddPreMakeHook({
    Write-Host "Updating build date..."
    $date = Get-Date
    $file = "${sdkPath}\Development\Src\LW_Overhaul\Classes\X2DownloadableContentInfo_LongWarOfTheChosen.uc"
    $content = [System.IO.File]::ReadAllText($file).Replace("<BUILD_DATE>", $date.tostring("d MMMM yyyy", [CultureInfo]'en-US'))
    [System.IO.File]::WriteAllText($file, $content)
    Write-Host "Build date added."
})

# $builder.IncludeSrc("$srcDirectory\X2WOTCCommunityHighlander\X2WOTCCommunityHighlander\Src")
$builder.IncludeSrc("$srcDirectory\BetterSecondWaveSupport\Src")
$builder.AddToClean("BetterSecondWaveSupport")
$builder.SetContentOptionsJsonFilename("ContentOptions.json")

if ($config -eq "compiletest") {
    # The first half of InvokeBuild(): stops after compiling, so there is no shader precompile,
    # no asset cooking, and nothing is copied to the game's Mods folder.
    # These steps are copied from X2ModBuildCommon's InvokeBuild() so that vendored library stays unedited.
    # If X2ModBuildCommon is updated, check this list still matches. The alternative is a compile-only
    # flag inside X2ModBuildCommon that makes InvokeBuild() return after compiling.
    $builder._ConfirmPaths()
    $builder._SetupUtils()
    $builder._LoadContentOptions()
    $builder._PerformStep({ ($_)._CleanAdditional() }, "Cleaning", "Cleaned", "additional mods")
    $builder._PerformStep({ ($_)._CopyModToSdk() }, "Mirroring", "Mirrored", "mod to SDK")
    $builder._PerformStep({ ($_)._ConvertLocalization() }, "Converting", "Converted", "Localization UTF-8 -> UTF-16")
    $builder._PerformStep({ ($_)._CopyToSrc() }, "Populating", "Populated", "Development\Src folder")
    $builder._PerformStep({ ($_)._RunPreMakeHooks() }, "Running", "Ran", "Pre-Make hooks")
    $builder._PerformStep({ ($_)._CheckCleanCompiled() }, "Verifying", "Verified", "compiled script packages")
    $builder._PerformStep({ ($_)._RunMakeBase() }, "Compiling", "Compiled", "base-game script packages")
    $builder._PerformStep({ ($_)._RunMakeMod() }, "Compiling", "Compiled", "mod script packages")
    $builder._RecordCoreTimestamp()
    Write-Host "*** SUCCESS! Scripts compiled (not cooked or installed) ***" -ForegroundColor Green
} else {
    $builder.InvokeBuild()
}
