Param(
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
)

Set-StrictMode -Version 3.0

$modNameCanonical = "LongWarOfTheChosen"
$modSrcLocRoot = "$srcDirectory\$modNameCanonical\Localization"
$stagingPath = "$sdkPath\XComGame\Mods\$modNameCanonical\Localization"
$installPath = "$gamePath\XComGame\Mods\$modNameCanonical\Localization"

Write-Host "Copying localization files to staging..."
Robocopy.exe "$modSrcLocRoot" "$stagingPath" *.* "/S" "/NFL" "/NDL" "/NS" "/NC" "/E" "/DCOPY:DA" "/COPY:DAT" "/PURGE" "/MIR" "/NP" "/R:1000000" "/W:30"

Write-Host "Converting to UTF-16 LE..."
Get-ChildItem "$stagingPath" -Recurse -File | 
Foreach-Object {
    $content = Get-Content $_.FullName -Encoding UTF8
    $content | Out-File $_.FullName -Encoding Unicode
}

Write-Host "Copying converted files to the installed mod..."
Robocopy.exe "$stagingPath" "$installPath" *.* "/S" "/NFL" "/NDL" "/NS" "/NC" "/E" "/DCOPY:DA" "/COPY:DAT" "/PURGE" "/MIR" "/NP" "/R:1000000" "/W:30"

Write-Host "Done."
