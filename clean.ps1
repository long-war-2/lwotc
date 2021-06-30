Param(
    [string] $modName, # mod folder name
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

if ($null -eq $modName -or $modName -eq "") {
    throw "`$modName empty???"
}

Write-Host "Deleting all cached build artifacts..."

$files = @(
    "$sdkPath\XComGame\lastBuildDetails.json",
    "$sdkPath\XComGame\Script\*.u",
    "$sdkPath\XComGame\ScriptFinalRelease\*.u",
    "$sdkPath\XComGame\Content\LocalShaderCache-PC-D3D-SM4.upk"
)

$folders = @(
    "$srcDirectory\BuildCache",
    "$sdkPath\Development\Src\*",
    "$sdkPath\XComGame\Mods\*",
    "$gamePath\XComGame\Mods\$modName"
)

$files | ForEach-Object {
    Write-Host "Removing file(s) $($_)"
    Remove-Item -Force $_ -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

$folders | ForEach-Object {
    Write-Host "Removing folders(s) $($_)"
    Remove-Item -Recurse -Force $_ -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

Write-Host "Cleaned."
