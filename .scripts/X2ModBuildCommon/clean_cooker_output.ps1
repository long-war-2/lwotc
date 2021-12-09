function CleanModAssetCookerOutput (
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $modNameCanonical,
    [string[]] $sourceAssetsPaths # Intended for ContentForCook and CollectionMaps, but any folder that has .upk or .umap files will work
) {
    # TODO: duplicates the logic in build_common.ps1
    $actualTfcSuffix = "_$($modNameCanonical)_DLCTFC_XPACK_"
    $cookerOutputPath = [io.path]::combine($sdkPath, 'XComGame', 'Published', 'CookedPCConsole')

    if (!(Test-Path $cookerOutputPath)) {
        Write-Host "No Published\CookedPCConsole directory - nothing to clean"
        return
    }

    $modMaps = @()
    $modPackages = @()

    foreach ($assetPath in $sourceAssetsPaths) {
        Write-Host "Asset path: $assetPath"

        if (!(Test-Path $assetPath)) { continue }

        $pathMaps = @(Get-ChildItem -Path $assetPath -Filter '*.umap' -Recurse -Force | Select-Object -ExpandProperty BaseName)
        $pathPackages = @(Get-ChildItem -Path $assetPath -Filter '*.upk' -Recurse -Force | Select-Object -ExpandProperty BaseName)

        Write-Host "Path maps: $pathMaps"
        Write-Host "Path packages: $pathPackages"

        $modMaps += $pathMaps
        $modPackages += $pathPackages
    }

    Write-Host "Removing SeekFree maps: $modMaps"
    $modMaps | ForEach-Object { Remove-Item -Force -LiteralPath "$cookerOutputPath\$_.upk" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue }

    Write-Host "Removing SeekFree standalone packages: $modPackages"
    $modPackages | ForEach-Object { Remove-Item -Force -LiteralPath "$cookerOutputPath\$($_)_SF.upk" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue }

    Write-Host "Removing TFCs: $actualTfcSuffix"
    Remove-Item -Force "$cookerOutputPath\*$actualTfcSuffix.tfc" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    
    Write-Host "Removing GuidCache"
    Remove-Item -Force "$cookerOutputPath\GuidCache_$modNameCanonical.upk" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

function TryCleanHlCookerOutput (
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $modSrcPath # the path to [mod root]/[mod project]/Src
) {
    $nativeScriptPackagesNames = @("XComGame", "Core", "Engine", "GFxUI", "AkAudio", "GameFramework", "UnrealEd", "GFxUIEditor", "IpDrv", "OnlineSubsystemPC", "OnlineSubsystemLive", "OnlineSubsystemSteamworks", "OnlineSubsystemPSN")
    $cookerOutputPath = [io.path]::combine($sdkPath, 'XComGame', 'Published', 'CookedPCConsole')

    if (!(Test-Path $cookerOutputPath)) {
        Write-Host "No Published\CookedPCConsole directory - nothing to clean"
        return
    }

    #################################
    ### Check if this is a HL mod ###
    #################################

    $modPackages = Get-ChildItem $modSrcPath -Directory | Select-Object -ExpandProperty "Name"
    $anyNative = $false

    foreach ($name in $modPackages) 
    {
        if ($nativeScriptPackagesNames.Contains($name)) {
            $anyNative = $true
            break
        }
    }

    if (!$anyNative) {
        Write-Host $modPackages
        Write-Host "Not a highlander mod - skipping cleaning HL cooker output"
        return
    }

    #########################################
    ### Prepare a list of files to delete ###
    #########################################

    $filesToRemove = @()

    # Native script packages
    foreach ($package in $nativeScriptPackagesNames) {
        $filesToRemove += "$package.upk"
        $filesToRemove += "$package.upk.uncompressed_size"
    }

    # Startup (unlocalized)
    $filesToRemove += "Startup.upk"
    $filesToRemove += "Startup.upk.uncompressed_size"

    # Startup (localized)
    $gameLangs = @("INT", "FRA", "ITA", "DEU", "RUS", "POL", "KOR", "ESN")
    foreach ($lang in $gameLangs) {
        $filesToRemove += "Startup_LOC_$lang.upk"
        $filesToRemove += "Startup_LOC_$lang.upk.uncompressed_size"
    }

    # TFC files
    $tfcGroups = @("CharTextures", "Lighting", "Textures", "World")
    foreach ($tfcGroup in $tfcGroups) {
        # Unsuffixed
        $filesToRemove += "$tfcGroup.tfc"
        $filesToRemove += "$tfcGroup-a.tfc"

        # Suffixed
        $filesToRemove += "${tfcGroup}_XPACK_.tfc"
        $filesToRemove += "$tfcGroup-a_XPACK_.tfc"

        # TLE
        $filesToRemove += "${tfcGroup}_TLE_DLCTFC_XPACK_.tfc"
        $filesToRemove += "$tfcGroup-a_TLE_DLCTFC_XPACK_.tfc"
    }

    # Singletons
    $filesToRemove += "GuidCache.upk"
    $filesToRemove += "GlobalPersistentCookerData.upk"
    $filesToRemove += "PersistentCookerShaderData.bin"

    ######################
    ### Actual removal ###
    ######################

    Write-Host "Removing HL cooker output files from $cookerOutputPath"

    foreach ($file in $filesToRemove) {
        Write-Host "  .\$file"
        Remove-Item -Force "$cookerOutputPath\$file" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    }
}
