Param(
    [string]$mod, # your mod's name - this shouldn't have spaces or special characters, and it's usually the name of the first directory inside your mod's source dir
    [string]$srcDirectory, # the path that contains your mod's .XCOM_sln
    [string]$sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string]$gamePath, # the path to your XCOM 2 installation ending in "XCOM 2"
    [switch]$forceFullBuild, # force the script to rebuild the base game's scripts, even if they're already built
    [switch]$debug,
    [switch]$final_release
)

function WriteModMetadata([string]$mod, [string]$sdkPath, [int]$publishedId, [string]$title, [string]$description, [string]$writeTo) {
    Set-Content $writeTo "[mod]`npublishedFileId=$publishedId`nTitle=$title`nDescription=$description`nRequiresXPACK=true"
}


function StageDirectory ([string]$directoryName, [string]$srcDirectory, [string]$targetDirectory) {
    Write-Host "Staging mod $directoryName from source ($srcDirectory/$directoryName) to staging ($targetDirectory/$directoryName)..."

    if (Test-Path "$srcDirectory/$directoryName") {
        Copy-Item "$srcDirectory/$directoryName" "$targetDirectory/$directoryName" -Recurse -WarningAction SilentlyContinue
        Write-Host "Staged."
    }
    else {
        Write-Host "Mod doesn't have any $directoryName."
    }
}

function CheckErrorCode([string] $message) {
    if ($LASTEXITCODE -ne 0) {
        $stopwatch.stop();
        $ts = $stopwatch.Elapsed.TotalSeconds;

        Write-Host "Build failed in $ts seconds.";
        FailureMessage  $message;
        
    }
}

#!!!!!!!!!!!! NOTE THESE MAY SOUND THE SAME IF NOT CONFIGURED !!!!!!!!!!!!!!!#
function FailureMessage($message)
{
    [System.Media.SystemSounds]::Asterisk.Play();
    throw $message
}

function SuccessMessage($message)
{
    $stopwatch.stop()
    $ts = $stopwatch.Elapsed.TotalSeconds;

    [System.Media.SystemSounds]::Exclamation.Play();
    Write-Host $message
    Write-Host "$modNameCanonical ready to run in $ts seconds."
}

# Helper for invoking the make cmdlet. Captures stdout/stderr and rewrites error and warning lines to fix up the
# source paths. Since make operates on a copy of the sources copied to the SDK folder, diagnostics print the paths
# to the copies. If you try to jump to these files (e.g. by tying this output to the build commands in your editor)
# you'll be editting the copies, which will then be overwritten the next time you build with the sources in your mod folder
# that haven't been changed.
function Launch-Make([string] $makeCmd, [string] $makeFlags, [string] $sdkPath, [string] $modSrcRoot) {
    # Create a ProcessStartInfo object to hold the details of the make command, its arguments, and set up
    # stdout/stderr redirection.
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $makeCmd
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $makeFlags

    # Create an object to hold the paths we want to rewrite: the path to the SDK 'Development' folder
    # and the 'modSrcRoot' (the directory that holds the .x2proj file). This is needed because the output
    # is read in an action block that is a separate scope and has no access to local vars/parameters of this
    # function.
    $developmentDirectory = Join-Path -Path $sdkPath 'Development'
    $messageData = New-Object psobject -property @{
        developmentDirectory = $developmentDirectory;
        modSrcRoot = $modSrcRoot
    }

    # We need another object for the Exited event to set a flag we can monitor from this function.
    $exitData = New-Object psobject -property @{ exited = $false }

    # An action for handling data written to stdout. The make cmdlet writes all warning and error info to
    # stdout, so we look for it here.
    $outAction = {
        $outTxt = $Event.SourceEventArgs.Data
        # Match warning/error lines
        $messagePattern = "^(.*)[\\/](.*)\(([0-9]*)\) : (.*)$"
        if (($outTxt -Match "Error|Warning") -And ($outTxt -Match $messagePattern)) {
            # And just do a regex replace on the sdk Development directory with the mod src directory.
            # The pattern needs escaping to avoid backslashes in the path being interpreted as regex escapes, etc.
            $pattern = [regex]::Escape($event.MessageData.developmentDirectory)
            # n.b. -Replace is case insensitive
            $replacementTxt = $outtxt -Replace $pattern, $event.MessageData.modSrcRoot
            $outTxt = "$replacementTxt"
        }

        $summPattern = "^(Success|Failure) - ([0-9]+) error\(s\), ([0-9]+) warning\(s\) \(([0-9]+) Unique Errors, ([0-9]+) Unique Warnings\)"
        if (-Not ($outTxt -Match "Warning/Error Summary") -And $outTxt -Match "Warning|Error") {
            if ($outTxt -Match $summPattern) {
                $numErr = $outTxt -Replace $summPattern, '$2'
                $numWarn = $outTxt -Replace $summPattern, '$3'
                if (([int]$numErr) -gt 0) {
                    $clr = "Red"
                } elseif (([int]$numWarn) -gt 0) {
                    $clr = "Yellow"
                } else {
                    $clr = "Green"
                }
            } else {
                if ($outTxt -Match "Error") {
                    $clr = "Red"
                } else {
                    $clr = "Yellow"
                }
            }
            Write-Host $outTxt -ForegroundColor $clr
        } else {
            Write-Host $outTxt
        }
    }

    # An action for handling data written to stderr. The make cmdlet doesn't seem to write anything here,
    # or at least not diagnostics, so we can just pass it through.
    $errAction = {
        $errTxt = $Event.SourceEventArgs.Data
        Write-Host $errTxt
    }

    # Set the exited flag on our exit object on process exit.
    $exitAction = {
        $event.MessageData.exited = $true
    }

    # Create the process and register for the various events we care about.
    $process = New-Object System.Diagnostics.Process
    Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action $outAction -MessageData $messageData | Out-Null
    Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -Action $errAction | Out-Null
    Register-ObjectEvent -InputObject $process -EventName Exited -Action $exitAction -MessageData $exitData | Out-Null
    $process.StartInfo = $pinfo

    # All systems go!
    $process.Start() | Out-Null
    $process.BeginOutputReadLine()
    $process.BeginErrorReadLine()

    # Wait for the process to exit. This is horrible, but using $process.WaitForExit() blocks
    # the powershell thread so we get no output from make echoed to the screen until the process finishes.
    # By polling we get regular output as it goes.
    while (!$exitData.exited) {
        Start-Sleep -m 50
    }

    # Explicitly set LASTEXITCODE from the process exit code so the rest of the script
    # doesn't need to care if we launched the process in the background or via "&".
    $global:LASTEXITCODE = $process.ExitCode
}

# This function verifies that all project files in the mod subdirectories actually exist in the .x2proj file
# AUTHOR: X2WOTCCommunityHighlander

function ValidateProjectFile([string] $modProjectRoot, [string] $modName)
{
    # To simplify relative path building
    $originalExecutionPath = Get-Location
    Set-Location $modProjectRoot

    Write-Host "Checking and cleaning .x2proj file..."
    $projFilepath = "$modProjectRoot\$modName.x2proj"
    if(Test-Path $projFilepath)
    {
        CheckX2ProjIncludes $modProjectRoot $modName $projFilepath
        CleanX2ProjIncludes $modProjectRoot $modName $projFilepath
    }
    else
    {
        FailureMessage("The project file '$projFilepath' doesn't exist!")
    }

    # fuck go back
    Set-Location $originalExecutionPath
}

function CheckX2ProjIncludes([string] $modProjectRoot, [string] $modName, [string] $projFilepath) {
    $missingEntries = New-Object System.Collections.Generic.List[System.Object]
    $patchedFiles = New-Object System.Collections.Generic.List[System.Object]
    $patchedFolders = New-Object System.Collections.Generic.List[System.Object]
    $projContent = Get-Content $projFilepath
    $srcFolders = "Config", "Content", "Localization", "Src"
    # Loop through all files in subdirectories and fail the build if any filenames are missing inside the project file
    Get-ChildItem $modProjectRoot -Directory | Where-Object { $srcFolders -contains $_.Name } | Get-ChildItem -Recurse |
    ForEach-Object {
        $relative = Resolve-Path -relative $_.FullName
        $relative = $relative.Substring(2)
        if((Get-Item $_.FullName) -is [System.IO.DirectoryInfo]) {
            $relative = $relative + "\"
            $isDir = $true
        }

        If (!($projContent | Select-String -Pattern $_.Name)) {
            $missingEntries.Add($relative)
            if($isDir) {
                $patchedFolders.Add($relative)
            } else {
                $patchedFiles.Add($relative);
            }
        }
        $isDir = $false
    }

    if($missingEntries.Count -gt 0)
    {
		# Use XPath (and all the accompanying namespace stuff) so that we can
		# handle appending to empty elements.
        Write-Host ("Entries missing in the .x2proj file: $($missingEntries.Count)")
		
        [xml]$xmlProjContent = Get-Content $projFilepath
		$ns = new-object Xml.XmlNamespaceManager $xmlProjContent.NameTable
		$ns.AddNamespace("msb", "http://schemas.microsoft.com/developer/msbuild/2003")

        $itemGroups = $xmlProjContent.SelectNodes("/msb:Project/msb:ItemGroup", $ns)

        $patchedFolders | ForEach-Object {
            $element = $xmlProjContent.CreateElement("Folder", $ns.LookupNamespace("msb"))
            $element.SetAttribute("Include", $_)
			$itemGroups.Item(0).AppendChild($element) | Out-Null
        }
		
        $patchedFiles | ForEach-Object {
            $element = $xmlProjContent.CreateElement("Content", $ns.LookupNamespace("msb"))
            $element.SetAttribute("Include", $_)
			$itemGroups.Item(1).AppendChild($element) | Out-Null
        }

        # I couldn't prevent a xmlns namespace from being declared, so just hard removing it T_T
        #$xmlProjContent = [xml] $xmlProjContent.OuterXml.Replace(" xmlns=`"`"", "")
        $xmlProjContent.save("$modProjectRoot\$modName.x2proj")

        Write-Host "Patched $modName.x2proj includes successfully!"
    } else {
        Write-Host "No patching required."
    }

}

function CleanX2ProjIncludes([string] $modProjectRoot, [string] $modName, [string] $projFilepath) {
    # TODO
    [xml]$xmlProjContent = Get-Content $projFilepath
    $presentFiles = New-Object System.Collections.Generic.List[System.Object]
    $includesToRemove = New-Object System.Collections.Generic.List[System.Object]
    $entriesToRemove = New-Object System.Collections.Generic.List[System.Object]
    $presentFolders = New-Object System.Collections.Generic.List[System.Object]
    $srcFolders = "Config", "Content", "Localization", "Src"
    Get-ChildItem $modProjectRoot -Directory -Recurse | Where-Object { $srcFolders -contains $_.Name } | Get-ChildItem -Recurse |
    ForEach-Object {
        $relative = Resolve-Path -relative $_.FullName
        $relative = $relative.Substring(2)

        if((Get-Item $_.FullName) -is [System.IO.DirectoryInfo]) {
            $presentFolders.Add($relative + "\");
        } else {
            $presentFiles.Add($relative);
        }
    }

    # check folder includes...
    $srcFolders = "Config\", "Content\", "Localization\", "Src\"
    $folders = $xmlProjContent.Project.ItemGroup[0].ChildNodes
    $folders | ForEach-Object {
        $include = $_.GetAttribute("Include");
        if(!($presentFolders -contains $include -or $srcFolders -contains $include)) {
            $entriesToRemove.Add($_)
            $includesToRemove.Add($include)
        }
    }

     # check file includes...
    $hardCodedExceptions = "ReadMe.txt", "ModPreview.jpg"
    $files = $xmlProjContent.Project.ItemGroup[1].ChildNodes
    $files | ForEach-Object {
        $include = $_.GetAttribute("Include");
        if(!($presentFiles -contains $include -or $hardCodedExceptions -contains $include)) {
            $entriesToRemove.Add($_)
            $includesToRemove.Add($include)
        }
    }

    if($entriesToRemove.Count -gt 0) {
        Write-Host ("Invalid entries in the .x2proj file: $includesToRemove")
        $entriesToRemove | ForEach-Object {
            try {
                $_.ParentNode.RemoveChild($_) | Out-Null
            } catch {
                FailureMessage("Couldn't remove child node!")
            }
            
        }
        
        $xmlProjContent.save("$modProjectRoot\$modName.x2proj")
        Write-Host "Cleaned $modName.x2proj includes successfully!"
    } else {
        Write-Host "No cleaning required."
    }
}

function HaveDirectoryContentsChanged ([string] $srcDirPath, [string] $destDirPath) {
    $srcDir = Get-ChildItem $srcDirPath
    $destDir = Get-ChildItem $destDirPath

    # quick check, obviously if there's more files in one location, there's been a change
    # also the code below doesn't check to see if a file has been removed
    if($srcDir.Length -ne $destDir.Length) {
        return $true
    }

    # cp'd directly from stackoverflow
    $DiffFound = Get-ChildItem $srcDirPath | Where-Object {
        ($_ | Get-FileHash).Hash -ne (Get-FileHash (Join-Path $destDirPath $_.Name)).Hash
    } 

    return $DiffFound
}

# list of all native script packages
[System.String[]]$nativescriptpackages = "XComGame", "Core", "Engine", "GFxUI", "AkAudio", "GameFramework", "UnrealEd", "GFxUIEditor", "IpDrv", "OnlineSubsystemPC", "OnlineSubsystemLive", "OnlineSubsystemSteamworks", "OnlineSubsystemPSN"

# alias params for clarity in the script (we don't want the person invoking this script to have to type the name -modNameCanonical)
$modNameCanonical = $mod
# we're going to ask that people specify the folder that has their .XCOM_sln in it as the -srcDirectory argument, but a lot of the time all we care about is
# the folder below that that contains Config, Localization, Src, etc...
Write-Host $srcDirectory
$modSrcRoot = "$srcDirectory/$modNameCanonical"

# check that all files in the mod folder are present in the .x2proj file
ValidateProjectFile $modSrcRoot $modNameCanonical

# build the staging path
$stagingPath = "{0}/XComGame/Mods/{1}/" -f $sdkPath, $modNameCanonical

# determine whether or not there are changes to the Content directory before we clean
# used later to determine if we can skip shader precompilation
$shaderCachePath = "{0}/Content/{1}_ModShaderCache.upk" -f $stagingPath, $modNameCanonical
$tempCachePath = "{0}/tmp/{1}_ModShaderCache.upk" -f $modSrcRoot, $modNameCanonical

$canSkipShaderPrecompliation = $false

# Need to store the ModShaderCache before we compare the Content directories, it will interfere with the check.
# Also, if there are no changes and we skip precompliation, we will need a backup of the ModShaderCache since it won't be regenerated after the stagingPath is cleaned.
#if(Test-Path $tempCachePath) {
#    # if we found a shadercache in here, that means that we found it last time and cached it, but the build failed and /tmp wasn't cleaned up... we can skip precompliation.
#    $canSkipShaderPrecompliation = $true
#    Write-Host "Found previously-stashed ModShaderCache. Shader precompliation can be skipped."
#} elseif(Test-Path $shaderCachePath) {
#    Write-Host "Found ModShaderCache, stashing it..."
#    
#    if(-not (Test-Path -Path $modSrcRoot/tmp)) {
#        New-Item $modSrcRoot/tmp -type Directory
#    } 
#    
#    Copy-Item -Path $shaderCachePath -Destination $tempCachePath
#    Remove-Item -Path $shaderCachePath
#    $canSkipShaderPrecompliation = $true
#    
#    Write-Host "Stashed."
#} else {
#    Write-Host "Unable to find a ModShaderCache. Shader precompliation is required."
#}

# check to see if the files changed
if($canSkipShaderPrecompliation) {
    $canSkipShaderPrecompliation = -not (HaveDirectoryContentsChanged $modSrcRoot/Content $stagingPath/Content)
}

if($canSkipShaderPrecompliation) {
    Write-Host "Can skip shader precompliation."
} else {
    Write-Host "Can't skip shader precompliation."
    if(Test-Path $tempCachePath) {
        Remove-Item -Path $tempCachePath
        Remove-Item -path $modSrcRoot/tmp
    }
}

# clean
$stagingPath = "{0}\XComGame\Mods\{1}" -f $sdkPath, $modNameCanonical
Write-Host "Cleaning mod project at $stagingPath...";
if (Test-Path $stagingPath) {
    Remove-Item $stagingPath -Recurse -Force -WarningAction SilentlyContinue;
}
Write-Host "Cleaned."

# copy source to staging
Robocopy.exe "$modSrcRoot" "$sdkPath\XComGame\Mods\$modNameCanonical" *.* /S /E /COPY:DAT /PURGE /MIR /NP /R:1 /W:30
if (Test-Path "$stagingPath\$modNameCanonical.x2proj") {
    Remove-Item "$stagingPath\$modNameCanonical.x2proj"
}

New-Item "$stagingPath/Script" -ItemType Directory

# read mod metadata from the x2proj file

Write-Host "Reading mod metadata from $modSrcRoot/$modNameCanonical.x2proj..."
[xml]$x2projXml = Get-Content -Path "$modSrcRoot/$modNameCanonical.x2proj"
$modProperties = $x2projXml.Project.PropertyGroup[0]
$modPublishedId = $modProperties.SteamPublishID
$modTitle = $modProperties.Name
$modDescription = $modProperties.Description
Write-Host "Read."

# write mod metadata - used by Firaxis' "make" tooling
Write-Host "Writing mod metadata..."
$metadataPublishPath = "$sdkPath/XComGame/Mods/$modNameCanonical/$modNameCanonical.XComMod"
WriteModMetadata -mod $modNameCanonical -sdkPath $sdkPath -publishedId $modPublishedId -title $modTitle -description $modDescription -writeTo $metadataPublishPath
Write-Host "Written."

# mirror the SDK's SrcOrig to its Src
Write-Host "Mirroring SrcOrig to Src..."
Robocopy.exe "$sdkPath/Development/SrcOrig" "$sdkPath/Development/Src" *.uc *.uci /S /E /COPY:DAT /PURGE /MIR /NP /R:1000000 /W:30
Write-Host "Mirrored."

# copying the mod's scripts to the script staging location
Write-Host "Copying the mod's scripts to Src..."
Copy-Item "$stagingPath/Src/*" "$sdkPath/Development/Src/" -Force -Recurse -WarningAction SilentlyContinue
Write-Host "Copied."

# build package lists we'll need later and delete as appropriate
# all packages we are about to compile
[System.String[]]$allpackages = Get-ChildItem "$sdkPath/Development/Src" -Directory
# the mod's packages, only those .u files will be copied to the output
[System.String[]]$thismodpackages = Get-ChildItem "$modSrcRoot/Src" -Directory

# append extra_globals.uci to globals.uci
if (Test-Path "$sdkPath/Development/Src/extra_globals.uci") {
    Get-Content "$sdkPath/Development/Src/extra_globals.uci" | Add-Content "$sdkPath/Development/Src/Core/Globals.uci"
}

if ($forceFullBuild) {
    # if a full build was requested, clean all compiled scripts too
    Write-Host "Full build requested. Cleaning all compiled scripts from $sdkPath/XComGame/Script..."
    Remove-Item "$sdkPath/XComGame/Script/*.u"
    Write-Host "Cleaned."
}
else {
    # clean mod's compiled script
    Write-Host "Cleaning existing mod's compiled script from $sdkPath/XComGame/Script..."
    foreach ($modpkg in $thismodpackages) {
	    if (Test-Path "$sdkPath/XComGame/Script/$modpk.u") {
            Remove-Item "$sdkPath/XComGame/Script/$modpkg.u"
        }
    }

    Write-Host "Cleaned."
}

# build the base game scripts
Write-Host "Compiling base game scripts..."
if ($debug)
{
    Launch-Make "$sdkPath/binaries/Win64/XComGame.com" "make -debug -nopause -unattended" $sdkPath $modSrcRoot
} else {
    Launch-Make "$sdkPath/binaries/Win64/XComGame.com" "make -nopause -unattended" $sdkPath $modSrcRoot
}
CheckErrorCode "Failed to compile base game scripts!"
Write-Host "Compiled base game scripts."

# build the mod's scripts
Write-Host "Compiling mod scripts..."
if ($debug)
{
    Launch-Make "$sdkPath/binaries/Win64/XComGame.com" "make -debug -nopause -mods $modNameCanonical $stagingPath" $sdkPath $modSrcRoot
} else {
    Launch-Make "$sdkPath/binaries/Win64/XComGame.com" "make -nopause -mods $modNameCanonical $stagingPath" $sdkPath $modSrcRoot
}
CheckErrorCode "Failed to compile mod scripts!"
Write-Host "Compiled mod scripts."

# Check if this is a Highlander and we need to cook things
$needscooking = $false
for ($i=0; $i -lt $thismodpackages.length; $i++)
{
    $name = $thismodpackages[$i]
    if ($nativescriptpackages.Contains($name))
    {
        $needscooking = $true
        break;
    }
}

if ($needscooking)
{
    # Cook it
    # First, make sure the cooking directory is set up
    $modcookdir = [io.path]::combine($sdkPath, 'XComGame', 'Published', 'CookedPCConsole')
    # Normally, the mod tools create a symlink in the SDK directory to the game CookedPCConsole directory,
    # but we'll just be using the game one to make it more robust
    $cookedpcconsoledir = [io.path]::combine($gamePath, 'XComGame', 'CookedPCConsole')
    if(-not(Test-Path $modcookdir))
    {
        Write-Host "Creating Published/CookedPCConsole directory"
        New-Item $modcookdir -ItemType Directory
    }

    [System.String[]]$files = "GuidCache.upk", "GlobalPersistentCookerData.upk", "PersistentCookerShaderData.bin"
    for ($i=0; $i -lt $files.length; $i++) {
        $name = $files[$i]
        if(-not(Test-Path ([io.path]::combine($modcookdir, $name))))
        {
            Write-Host "Copying $name"
            Copy-Item ([io.path]::combine($cookedpcconsoledir, $name)) $modcookdir
        }
    }

    # Ideally, the cooking process wouldn't modify the big *.tfc files, but it does, so we don't overwrite existing ones (/XC /XN /XO)
    # In order to "reset" the cooking direcory, just delete it and let the script recreate them
    Write-Host "Copying Texture File Caches"
    Robocopy.exe "$cookedpcconsoledir" "$modcookdir" *.tfc /NJH /XC /XN /XO

    # Cook it!
    # The CookPackages commandlet generally is super unhelpful. The output is basically always the same and errors
    # don't occur -- it rather just crashes the game. Hence, we just pipe the output to $null
    Write-Host "Invoking CookPackages (this may take a while)"
    if ($final_release -eq $true)
    {
        & "$sdkPath/binaries/Win64/XComGame.com" CookPackages -platform=pcconsole -final_release -quickanddirty -modcook -sha -multilanguagecook=INT+FRA+ITA+DEU+RUS+POL+KOR+ESN -singlethread -nopause #>$null 2>&1
    } else {
        & "$sdkPath/binaries/Win64/XComGame.com" CookPackages -platform=pcconsole -quickanddirty -modcook -sha -multilanguagecook=INT+FRA+ITA+DEU+RUS+POL+KOR+ESN -singlethread -nopause #>$null 2>&1
    }

    if ($LASTEXITCODE -ne 0)
    {
        FailureMessage "Failed to cook packages"
    }

    Write-Host "Cooked packages"

    # Create CookedPCConsole folder for the mod
    New-Item "$stagingPath/CookedPCConsole" -ItemType Directory
}

# copy compiled mod scripts to the staging area
Write-Host "Copying the compiled and cooked mod scripts to staging..."
for ($i=0; $i -lt $thismodpackages.length; $i++) {
    $name = $thismodpackages[$i]
    if ($nativescriptpackages.Contains($name))
    {
        # This is a native (cooked) script package -- copy important upks
        Copy-Item "$modcookdir/$name.upk" "$stagingPath/CookedPCConsole" -Force -WarningAction SilentlyContinue
        Copy-Item "$modcookdir/$name.upk.uncompressed_size" "$stagingPath/CookedPCConsole" -Force -WarningAction SilentlyContinue
        Write-Host "$modcookdir/$name.upk"
    } else {
        # This is a normal script package
        Copy-Item "$sdkPath/XComGame/Script/$name.u" "$stagingPath/Script" -Force -WarningAction SilentlyContinue
        Write-Host "$sdkPath/XComGame/Script/$name.u"
    }
}
Write-Host "Copied compiled script packages."

# TODO: Optimize this. One could skip recompiling shader caches if the shader cache is newer than any other content file.
Write-Host "Testing $modSrcRoot/Content"
if(Test-Path "$modSrcRoot/Content")
{
    Write-Host "Exists"
    $contentfiles = Get-ChildItem "$modSrcRoot/Content\*"  -Include *.upk, *.umap -Recurse -File -Name
    if($contentfiles.length -gt 0)
    {
        # build the mod's shader cache
        Write-Host "Precompiling Shaders..."
        &"$sdkPath/binaries/Win64/XComGame.com" precompileshaders -nopause platform=pc_sm4 DLC=$modNameCanonical
        if ($LASTEXITCODE -ne 0)
        {
            throw "Failed to compile mod shader cache!"
        }
        Write-Host "Generated Shader Cache."
    }
}

# copy all staged files to the actual game's mods folder
Write-Host "Copying all staging files to production..."
Copy-Item $stagingPath "$gamePath/XComGame/Mods/" -Force -Recurse -WarningAction SilentlyContinue
Write-Host "Copied mod to game directory."

# we made it!
Write-Host "*** SUCCESS! ***"
Write-Host "$modNameCanonical ready to run."
