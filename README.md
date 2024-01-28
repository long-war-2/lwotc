# Long War of the Chosen (LWOTC)

This is a port of [Pavonis Interactive](https://www.pavonisinteractive.com/)'s
Long War 2 (LW2) overhaul mod for XCOM 2 to the War of the Chosen (WOTC)
expansion and update it for WOTC's new features.

## Installing and playing the mod

Long War of the Chosen is primarily distributed through Steam Workshop, in a few varieties:

### Main release
[The main release](https://steamcommunity.com/sharedfiles/filedetails/?id=2683996590) stays unchanging for longer periods of time, mostly receiving bugfixes and localization updates. More experimental changes enter this item only after they've been adequately tested. This version is recommended if you're just starting or are otherwise unsure about which to choose.

### Beta release
[The beta release](https://steamcommunity.com/sharedfiles/filedetails/?id=2663990965) receives more rapid and experimental updates, to be evaluated by the community. This version is recommended if you want to actively provide feedback or otherwise want the most cutting edge changes. However, note that this version can introduce more frequent and more serious bugs than the main.

### 1.0 archive release
[The 1.0 archive release](https://steamcommunity.com/sharedfiles/filedetails/?id=3114647033) is only recommended if you have a campaign started before the release of 1.1 and are worried that its changes cause instability or imbalance.

## Contributing translations

If you would like to contribute to translations for LWOTC, then check out the
[wiki page](https://github.com/long-war-2/lwotc/wiki/Contributing#localization-translating-text-in-the-game)
that explains how it works.

## Building and running the mod

If you want to contribute changes to code or assets, then you will need to
build the mod so that you can test them. Before you can do that, you need to
set some things up:

 1. Make sure you have the WOTC SDK `full_content` branch installed - see the
    [xcom2mods wiki](https://www.reddit.com/r/xcom2mods/wiki/index#wiki_setting_up_tools_for_modding)
    for details on how to do that (plus lots of other useful information)

 2. [Fork this repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
    and then clone your fork locally, which you can do via [Git for Windows](https://gitforwindows.org/)
    (a command-line tool), [GitHub Desktop](https://desktop.github.com/), or some other
    git client tool

 3. Once you have cloned the repository, you may need to pull the code for the embedded
    highlander. If the *X2WOTCCommunityHighlander* directory is empty, then use the
    command line from the project's root directory (the one containing this README.md):
    ```
        > git submodule update --init
    ```
    or whatever is the equivalent with the git client tool you are using.

 4. Download the LWOTC media assets (video, graphics and sound) from
    [this Google Drive link](https://drive.google.com/file/d/1wyjctso0NuHeHJp3DdQdPIlZ482st9ZY/view?usp=sharing)
    and unpack the resulting zip file into this project's *LongWarOfTheChosen* directory. It should merge the contents of the *Content* and *ContentForCook* directories.

 5. Set up the following environment variables:
    * `XCOM2SDKPATH` — typically &lt;path to Steam&gt;\steamapps\common\XCOM 2 War Of The Chosen SDK
    * `XCOM2GAMEPATH` — typically &lt;path to Steam&gt;\steamapps\common\XCOM 2\XCom2-WarOfTheChosen
    Don't put these paths in quotes.
	
 6. Open a new command prompt after setting those environment variables and run
    the following from the LWOTC project directory:
    ```
    > build-lwotc.bat -config default
    ```
    (You can specify `-config debug` to compile with debug info)
 
 7. You should also build the Community Highlander, which you can do by opening
    the solution file in X2WOTCCommunityHighlander in Mod Buddy and using that
    to build the project, or you can open the LWOTC project directory in VS Code
    and use the "Terminal > Run Task..." menu option and select "Build CHL
    (final release)" and then "Build DLC2 CHL" once the previous task has finished.

Once the highlander and LWOTC are built, you will be able to select them as local
mods in Alternative Mod Launcher and run Long War of the Chosen.

## Contributing

Contributions are welcome. If you just want to raise issues, please do so [on GitHub](https://github.com/long-war-2/lwotc/issues),
preferably including a save file if possible.

If you wish to contribute to development — and this project will rely heavily on such contributions — then please
look through the issues and if you want tackle one, just leave a comment along the lines of "I'll take this one".
If you find you can't complete the issue in a reasonable time, please add another comment that says you're relinquishing
the issue.

All contributions are welcome, but bug fixes are _extremely_ welcome!

## Acknowledgements

 * Track Two, who has provided a huge amount of advice and insight that saved me lots of time
   and ensured certain bugs got fixed at all.
 * The folks behind X2WOTCCommunityHighlander.
 * All the folks in XCOM 2 modders' Discord who have answered my questions.
 * All the authors of the mods that are integrated into this port:
   - robojumper's Squad Select
   - Detailed Soldier List
 * The Long War 2 team for producing the mod in the first place!
