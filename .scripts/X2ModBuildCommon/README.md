# X2ModBuildCommon
An improved XCOM 2 mod build system. The following (in no praticular order) are its features/improvements over the default one:

* Path rewriting for script errors/warnings so that they no longer point to the temporary copies of files in SDK/Developement/Src
* Automated including of compile-time dependencies (including CHL) so that you no longer need to pollute your SrcOrig with them
* Caching of `ModShaderCache` and invoking the shader precompiler only when the mod content files have changed
* Proper cancelling of the build mid-way (instead of waiting until it completes)
* Configurable mod workshop ID
* Automated including of SDK's content packages (for those which are missing in the cooked game) so that you don't need to store them in your project
* Full HL building: final release compiling and cooking of native script packages
* Scriptable hooks in the build process
* Conversion of localization file(s) encoding (UTF8 in the project for correct git merging and UTF16 for correct game loading)
* Mod asset cooking (experimental)
* Correct removal of files from the steamapps/XCOM2/WOTC/XComGame/Mods (built mod) when they are deleted from the project
* Mod-defined global macros (without explicit `include`s and without messing with your `SrcOrig`)
* Most features are configurable!

# Getting started
Foreword: the build system was designed to be flexible in how you want to set it up. This section describes
the most common/basic setup that should work for 95% of mods out there. If you want to customize it, read the next section

## Getting the files
First, create a `.scripts` folder in the root of your mod project (next to the `.XCOM_sln` file) - from now on referred
to as `[modRoot]`. The next step depends on whether you are using git or not. Git is preferable but the build system
will work just fine without it.

### Your mod uses git
Open a command line prompt (cmd or powershell, does not matter) in the `[modRoot]`. Ensure that
your working tree is clean and run the following command:

```
git subtree add --prefix .scripts/X2ModBuildCommon https://github.com/X2CommunityCore/X2ModBuildCommon v1.1.0 --squash
```

### Your mod does not use git
Download the source code of this repository from the latest release on the [Releases page](https://github.com/X2CommunityCore/X2ModBuildCommon/releases/latest).
Unzip it and place so that `build_common.ps1` resides at `[modRoot]\.scripts\X2ModBuildCommon\build_common.ps1`.

## Ignoring the `BuildCache`
The build system will create a `[modRoot]\BuildCache` folder which is used for various file-based operations (such
as recompiling the `ModShaderCache` only when mod's content has changed). This folder is fully managed by the build
system and normally you should never open it. It is also safe to delete at any time (e.g. if you want to
force a full rebuild).

As such, this folder is not meant to be shared with other developers working on the project or stored in
backups/previous versions (e.g. when using a VCS) - this can lead to incorrect behaviour.

If you are using git, you should add it (`BuildCache/`) to your `.gitignore`

## Setting up the build entrypoint
Create `[modRoot]\.scripts\build.ps1` with the following content:

```ps1
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

$builder = [BuildProject]::new("YourProjectName", $srcDirectory, $sdkPath, $gamePath)

switch ($config)
{
    "debug" {
        $builder.EnableDebug()
    }
    "default" {
        # Nothing special
    }
    "" { ThrowFailure "Missing build configuration" }
    default { ThrowFailure "Unknown build configuration $config" }
}

$builder.InvokeBuild()
```

Replace `YourProjectName` with the internal mod name (e.g. the name of your `.XCOM_sln` file without the extension)

## IDE integration
At this point your mod is actually ready for building but invoking the powershell script with all the arguments each time manually
is not convinient. Instead, we would like it to be invoked automatically when we press the build button in our IDE

### ModBuddy
Close Modbuddy (or at least the solution) if you have it open. Open your `.x2proj` (in something like notepad++) and find the follwing line:

```xml
<Import Project="$(MSBuildLocalExtensionPath)\XCOM2.targets" />
```

Replace it with following:

```xml
  <PropertyGroup>
    <SolutionRoot>$(MSBuildProjectDirectory)\..\</SolutionRoot>
    <ScriptsDir>$(SolutionRoot).scripts\</ScriptsDir>
    <BuildCommonRoot>$(ScriptsDir)X2ModBuildCommon\</BuildCommonRoot>
  </PropertyGroup>
  <Import Project="$(BuildCommonRoot)XCOM2.targets" />
```

Note that the build tool does not care about most of the `.x2proj` file and will
copy and compile files not referenced by the project file without issuing warnings.
Consider using a tool like [Xymanek/X2ProjectGenerator](https://github.com/Xymanek/X2ProjectGenerator)
to automatically ensure the file list in ModBuddy accurately lists the files part of the project.


### VSCode

> FIXME(#1): Rename variables to remove HL references?

First, you need to tell Visual Studio code where to find the game and SDK (similar to the first-time ModBuddy setup).
To do that, open the "Settings (JSON)" file by using the "Ctrl+Shift+P" shortcut and running "Preferences: Open Settings (JSON)"
or by clicking "File->Preferences->Settings" and clicking the "Open Settings (JSON)" button on the tab bar. Add the following
two entries, adjusting paths as necessary.

```json
    "xcom.highlander.sdkroot": "d:\\Steam\\SteamApps\\common\\XCOM 2 War of the Chosen SDK",
    "xcom.highlander.gameroot": "d:\\Steam\\SteamApps\\common\\XCOM 2\\XCom2-WarOfTheChosen"
```

VS Code may tell you that the configuration settings are unknown. This is acceptable and can be ignored.

Next up, you have to tell VS code about your build tasks. Create a folder `.vscode` next to the `.scripts` folder,
and within it create a `tasks.json` file with the following content (replacing `MY_MOD_NAME` with the mod project
name in the "Clean" task):

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build",
            "type": "shell",
            "command": "powershell.exe –NonInteractive –ExecutionPolicy Unrestricted -file '${workspaceRoot}\\.scripts\\build.ps1' -srcDirectory '${workspaceRoot}' -sdkPath '${config:xcom.highlander.sdkroot}' -gamePath '${config:xcom.highlander.gameroot}' -config 'default'",
            "group": "build",
            "problemMatcher": []
        },
        {
            "label": "Build debug",
            "type": "shell",
            "command": "powershell.exe –NonInteractive –ExecutionPolicy Unrestricted -file '${workspaceRoot}\\.scripts\\build.ps1' -srcDirectory '${workspaceRoot}' -sdkPath '${config:xcom.highlander.sdkroot}' -gamePath '${config:xcom.highlander.gameroot}' -config 'debug'",
            "group": "build",
            "problemMatcher": []
        },
        {
            "label": "Clean",
            "type": "shell",
            "command": "powershell.exe –NonInteractive –ExecutionPolicy Unrestricted -file '${workspaceRoot}\\.scripts\\clean.ps1' -modName 'MY_MOD_NAME' -srcDirectory '${workspaceRoot}' -sdkPath '${config:xcom.highlander.sdkroot}' -gamePath '${config:xcom.highlander.gameroot}'",
            "group": "build",
            "problemMatcher": []
        }
    ]
}
```

Note that the `-config 'debug'` or `-config 'default'` build configurations correspond to
the build configurations in the `build.ps1` entry point created earlier. You can easily add
existing build tasks with custom configurations by modifying `build.ps1` and configuring the
`$builder` (see just below!)

> FIXME(microsoft/vscode#24865): Add problem matchers when they can be shared between tasks.

## Ready!
You can now successfully build your mod from your IDE using X2ModBuildCommon. Keep reading on to find about what you can configure.

## Updating
The build system is desinged to be version-pinned against your mod - you can continue using the old version as long as it suits your needs, even if a new one is released. If you would like to get the new features/improvements/bugfixes of the new version, the update procedure is simple. 

If you don't use git, simply download the new version and overwrite the old files inside the `X2ModBuildCommon` folder.

If you use git, run the same command as before, replacing `add` with `pull`:

```
git subtree pull --prefix .scripts/X2ModBuildCommon https://github.com/X2CommunityCore/X2ModBuildCommon v1.1.0 --squash
```

# Configuration options

All the following examples are modifications that could be made to your `build.ps1`.

## ThrowFailure

> FIXME: `ThrowFailure` vs `FailureMessage`?

Throw a failure. Example usage:

```ps1
switch ($config) {
  # ...
  "" { ThrowFailure "Missing build configuration" }
}
```

## SetWorkshopID

Override the workshop ID from the x2proj file. Example usage:

```ps1
# make sure beta builds are never uploaded to the stable workshop page
if ($config -eq "stable") {
  $builder.SetWorkshopID(1234567890)
}
else {
  $builder.SetWorkshopID(6789012345)
}
```

## EnableFinalRelease

Pass the `-final_release` flag to the compiler for base-game script packages and the Highlander cooker.
Can only be used for Highlander-style mods that modify native packages. Example usage:

```ps1
switch ($config) {
  # ...
  "final_release" {
    $builder.EnableFinalRelease()
  }
  "stable" {
    $builder.EnableFinalRelease()
  }
}
```

## EnableDebug

Pass the `-debug` flag to all script compiler invocations. Incompatible with `EnableFinalRelease`, and will skip
Highlander cooking process (accordingly you have to use `-noseekfreeloading` when launching the game). Example usage:

```ps1
switch ($config) {
  # ...
  "debug" {
    $builder.EnableDebug()
  }
}
```

## AddPreMakeHook

Add a callback to be executed after all script sources have been added to `Src` but before the compiler is run.
Example usage:

```ps1
# Checks if a certain automatically generated file actually compiles, but only with the "compiletest" configuration
if ($compiletest) {
    $builder.AddPreMakeHook({
        Write-Host "Including CHL_Event_Compiletest"
        # n.b. this copies from the `target` directory where it is generated into, see tasks.json
        Copy-Item "..\target\CHL_Event_Compiletest.uc" "$sdkPath\Development\Src\X2WOTCCommunityHighlander\Classes\" -Force -WarningAction SilentlyContinue
    })
}
```

The Highlander also uses it to embed the current git commit hash in some source files.

## IncludeSrc

Add dependencies' source files to `Src`. This removes the step where mods whose sources you want to have available
have to be copied to `SrcOrig`. Example usage (from Covert Infiltration):

```
$builder.IncludeSrc("$srcDirectory\X2WOTCCommunityHighlander\X2WOTCCommunityHighlander\Src")
$builder.IncludeSrc("$srcDirectory\X2WOTCCommunityHighlander\Components\DLC2CommunityHighlander\DLC2CommunityHighlander\Src")
$builder.IncludeSrc("$srcDirectory\SquadSelectAnyTime\SquadSelectAtAnyTime\Src")
```

## AddToClean

Deletes certain built mods from `SDK/XComGame/Mods`. Usually necessary for dependencies since their script compiler configuration
files can cause the script compiler to choke. Covert Infiltration does this:

```ps1
$builder.AddToClean("SquadSelectAtAnyTime")
```

## Content options

You can provide a "content options" file that will determine some additional content-related steps. This file should be checked
in to your VSC (e.g. tracked by git) and must reside next to your `.x2proj` (note that the file will not be included in the
final built mod). If using Modbuddy, you can add the file to the project for easier editing. 

Assuming the file is named `ContentOptions.json`:

```ps1
$builder.SetContentOptionsJsonFilename("ContentOptions.json")
```

Four options are avaliable: `missingUncooked`, `sfStandalone`, `sfMaps`, `sfCollectionMaps`. Omitting an option (or the file entirely)
is treated the same as setting it to an empty array

### Including missing uncooked

In case your mod depends on some assets that were not shipped in a seek free package, you can automatically include it with your mod.
Example from Covert Infiltration:

```json
{
    "missingUncooked": [
        "CIN_TroopTransport.upk",
        "PCP_Archetypes_XPACK.upk"
    ]
}
```

**IMPORTANT**: you need to be on the `full_content` branch of the SDK for this to work.

### Asset cooking

The rest of the options are for the mod assets cooking. Because it is such a complex process, the package and map configuration is
described in a separate file. See [Asset Cooking](https://github.com/X2CommunityCore/X2ModBuildCommon/wiki/Asset-cooking) for details.

# Additional features

## extra_globals

This isn't a configuration option, but mods can create an `extra_globals.uci` file in the
`Src` folder to have the build tool append its contents to `Globals.uci`. This allows mods
to use custom macros.

Moreover, the `extra_globals.uci` files of any dependencies added via `IncludeSrc` will be merged into `Globals.uci` too. This allows dependency mods to safely use custom macros 
without causing compilation problems for dependent mods.

## Localization Encoding

Any files in the `Localization` folder will have its encoding rewritten from UTF-8 to UTF-16. This allows tracking
localization files in the git-compatible UTF-8 text encoding even though the game only supports ASCII and UTF-16.

# ModBuddy project customization

You can customize your `.x2proj` using the following properties:

Property | Default value | Notes
-------- | ------------- | -----
`SolutionRoot` | None (**required**) | The path to folder which houses your `.XCOM_sln` file
`ScriptsDir` | None | Required if you don't set `BuildEntryPs1`. Ignored otherwise
`BuildCommonRoot` | None (**required**) | The path to folder which houses the `InvokePowershellBuild.cs` file
`BuildEntryFileName` | `build.ps1` | Required if you don't set `BuildEntryPs1`. Ignored otherwise
`BuildEntryPs1` | `$(ScriptsDir)$(BuildEntryFileName)` |
`BuildEntryConfig` | `default` or `debug` | Will be passed to your build entrypoint. Default is derived from `$(Configuration)` (build configuration dropdown)

Hint: if you want to add other build configurations, you can let the `default` and `debug` ones be handeled
by the provided `XCOM2.targets`. Example from CHL:

```xml
  <PropertyGroup>
    <SolutionRoot>$(MSBuildProjectDirectory)\..\</SolutionRoot>
    <ScriptsDir>$(SolutionRoot).scripts\</ScriptsDir>
    <BuildCommonRoot>$(ScriptsDir)X2ModBuildCommon\</BuildCommonRoot>

    <!-- Default and debug are handeled by the .targets automatically -->
    <BuildEntryConfig Condition=" '$(Configuration)' == 'Final release' ">final_release</BuildEntryConfig>
    <BuildEntryConfig Condition=" '$(Configuration)' == 'Compiletest' ">compiletest</BuildEntryConfig>
    <BuildEntryConfig Condition=" '$(Configuration)' == 'Workshop stable version' ">stable</BuildEntryConfig>
  </PropertyGroup>
```

# Things to watch out for

Note that you can always check the issue tracker: https://github.com/X2CommunityCore/X2ModBuildCommon/issues?q=is%3Aissue+is%3Aopen+label%3Abug

## Deleting content files

If you **delete** content files (e.g. moved to a different mod or just completely removed) the current caching logic (e.g. for the
shader cache) might not recognize it. As such, it's recommended that you simply delete the `BuildCache` folder in such cases.
