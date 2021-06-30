Write-Host "Build Common Loading"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$global:def_robocopy_args = @("/S", "/E", "/DCOPY:DA", "/COPY:DAT", "/PURGE", "/MIR", "/NP", "/R:1000000", "/W:30")
$global:buildCommonSelfPath = split-path -parent $MyInvocation.MyCommand.Definition
# list of all native script packages
$global:nativescriptpackages = @("XComGame", "Core", "Engine", "GFxUI", "AkAudio", "GameFramework", "UnrealEd", "GFxUIEditor", "IpDrv", "OnlineSubsystemPC", "OnlineSubsystemLive", "OnlineSubsystemSteamworks", "OnlineSubsystemPSN")

$global:invarCulture = [System.Globalization.CultureInfo]::InvariantCulture

class BuildProject {
	[string] $modNameCanonical
	[string] $projectRoot
	[string] $sdkPath
	[string] $gamePath
	[string] $contentOptionsJsonFilename
	[long] $publishID = -1
	[bool] $debug = $false
	[bool] $final_release = $false
	[string[]] $include = @()
	[string[]] $clean = @()
	[object[]] $preMakeHooks = @()

	# internals
	[hashtable] $macroDefs = @{}
	[object[]] $timings = @()

	# lazily set
	[string] $modSrcRoot
	[string] $devSrcRoot
	[string] $stagingPath
	[string] $commandletHostPath
	[string] $buildCachePath
	[string] $modcookdir
	[string] $makeFingerprintsPath
	[string[]] $thismodpackages
	[bool] $isHl
	[bool] $cookHL
	[PSCustomObject] $contentOptions

	BuildProject(
		[string]$mod,
		[string]$projectRoot,
		[string]$sdkPath,
		[string]$gamePath
	){
		$this.modNameCanonical = $mod
		$this.projectRoot = $projectRoot
		$this.sdkPath = $sdkPath
		$this.gamePath = $gamePath
	}

	[void]SetContentOptionsJsonFilename($filename) {
		$this.contentOptionsJsonFilename = $filename
	}

	[void]SetWorkshopID([long] $publishID) {
		if ($publishID -le 0) { ThrowFailure "publishID must be >0" }
		$this.publishID = $publishID
	}

	[void]EnableFinalRelease() {
		$this.final_release = $true
		$this._CheckFlags()
	}

	[void]EnableDebug() {
		$this.debug = $true
		$this._CheckFlags()
	}

	[void]AddPreMakeHook([Action[]] $action) {
		$this.preMakeHooks += $action
	}

	[void]AddToClean([string] $modName) {
		$this.clean += $modName
	}

	[void]IncludeSrc([string] $src) {
		if (!(Test-Path $src)) { ThrowFailure "include path $src doesn't exist" }
		$this.include += $src
	}

	[void]InvokeBuild() {
		try {
			$fullStopwatch = [Diagnostics.Stopwatch]::StartNew()
			$this._ConfirmPaths()
			$this._SetupUtils()
			$this._LoadContentOptions()
			$this._PerformStep({ ($_)._CleanAdditional() }, "Cleaning", "Cleaned", "additional mods")
			$this._PerformStep({ ($_)._CopyModToSdk() }, "Mirroring", "Mirrored", "mod to SDK")
			$this._PerformStep({ ($_)._ConvertLocalization() }, "Converting", "Converted", "Localization UTF-8 -> UTF-16")
			$this._PerformStep({ ($_)._CopyToSrc() }, "Populating", "Populated", "Development\Src folder")
			$this._PerformStep({ ($_)._RunPreMakeHooks() }, "Running", "Ran", "Pre-Make hooks")
			$this._PerformStep({ ($_)._CheckCleanCompiled() }, "Verifying", "Verified", "compiled script packages")
			$this._PerformStep({ ($_)._RunMakeBase() }, "Compiling", "Compiled", "base-game script packages")
			$this._PerformStep({ ($_)._RunMakeMod() }, "Compiling", "Compiled", "mod script packages")
			$this._RecordCoreTimestamp()
			if ($this.isHl) {
				if (-not $this.debug) {
					$this._PerformStep({ ($_)._RunCookHL() }, "Cooking", "Cooked", "Highlander packages")
				} else {
					Write-Host "Skipping cooking as debug build"
				}
			}
			$this._PerformStep({ ($_)._CopyScriptPackages() }, "Copying", "Copied", "compiled script packages")
			
			# The shader step needs to happen before cooking - precompiler gets confused by some inlined materials
			$this._PerformStep({ ($_)._PrecompileShaders() }, "Precompiling", "Precompiled", "shaders")
	
			$this._PerformStep({ ($_)._RunCookAssets() }, "Cooking", "Cooked", "mod assets")
	
			# Do this last as there is no need for it earlier - the cooker obviously has access to the game assets
			# and precompiling shaders seems to do nothing (I assume they are included in the game's GlobalShaderCache)
			$this._PerformStep({ ($_)._CopyMissingUncooked() }, "Copying", "Copied", "requested uncooked packages")
	
			$this._PerformStep({ ($_)._FinalCopy() }, "Copying", "Copied", "built mod to game directory")
			$fullStopwatch.Stop()
			$this._ReportTimings($fullStopwatch)
			SuccessMessage "*** SUCCESS! ($(FormatElapsed $fullStopwatch.Elapsed)) ***" $this.modNameCanonical
		}
		catch {
			[System.Media.SystemSounds]::Hand.Play()
			throw
		}
	}

	[void]_PerformStep([scriptblock]$stepCallback, [string]$progressWord, [string]$completedWord, [string]$description) {
		Write-Host "$($progressWord) $($description)..."
		$sw = [Diagnostics.Stopwatch]::StartNew()

		# HACK: Set $_ for $stepCallback with Foreach-Object on only one object
		$this | ForEach-Object $stepCallback

		$sw.Stop()

		$record = [PSCustomObject]@{
			Description = "$($progressWord) $($description)"
			Seconds = $sw.Elapsed.TotalSeconds
		}

		$this.timings += $record

		Write-Host -ForegroundColor DarkGreen "$($completedWord) $($description) in $(FormatElapsed $sw.Elapsed)"
	}

	[void]_ReportTimings([Diagnostics.Stopwatch]$fullStopwatch) {
		if (-not [string]::IsNullOrEmpty($env:X2MBC_REPORT_TIMINGS)) {
			$fullTime = $fullStopwatch.Elapsed.TotalSeconds
			$accountedTime = $this.timings | Measure-Object -Sum -Property Seconds | Select-Object -ExpandProperty Sum
			$this.timings += [PSCustomObject]@{
				Description = "Total Duration"
				Seconds = $fullTime
			}
			$this.timings += [PSCustomObject]@{
				Description = "Unaccounted time"
				Seconds = $fullTime - $accountedTime
			}

			$this.timings | Sort-Object -Descending -Property { $_.Seconds } | ForEach-Object {
				$_ | Add-Member -NotePropertyName "Share" -NotePropertyValue ($_.Seconds / $fullTime).ToString("0.00%", $global:invarCulture)
				$_.Seconds = $_.Seconds.ToString("0.00s", $global:invarCulture)
				$_
			} | Format-Table | Out-String | Write-Host
		}
	}

	[void]_CheckFlags() {
		if ($this.debug -eq $true -and $this.final_release -eq $true)
		{
			ThrowFailure "-debug and -final_release cannot be used together"
		}
	}

	[void]_ConfirmPaths() {
		Write-Host "SDK Path: $($this.sdkPath)"
		Write-Host "Game Path: $($this.gamePath)"
	
		# Check if the user config is set up correctly
		if (([string]::IsNullOrEmpty($this.sdkPath) -or $this.sdkPath -eq '${config:xcom.highlander.sdkroot}') -or ([string]::IsNullOrEmpty($this.gamePath) -or $this.gamePath -eq '${config:xcom.highlander.gameroot}'))
		{
			ThrowFailure "Please set up user config xcom.highlander.sdkroot and xcom.highlander.gameroot"
		}
		elseif (!(Test-Path $this.sdkPath)) # Verify the SDK and game paths exist before proceeding
		{
			ThrowFailure ("The path '{}' doesn't exist. Please adjust the xcom.highlander.sdkroot variable in your user config and retry." -f $this.sdkPath)
		}
		elseif (!(Test-Path $this.gamePath)) 
		{
			ThrowFailure ("The path '{}' doesn't exist. Please adjust the xcom.highlander.gameroot variable in your user config and retry." -f $this.gamePath)
		}
	}

	[void]_SetupUtils() {
		$this.modSrcRoot = "$($this.projectRoot)\$($this.modNameCanonical)"
		$this.stagingPath = "$($this.sdkPath)\XComGame\Mods\$($this.modNameCanonical)"
		$this.devSrcRoot = "$($this.sdkPath)\Development\Src"
		$this.commandletHostPath = "$($this.sdkPath)/binaries/Win64/XComGame.com"

		# build package lists we'll need later and delete as appropriate
		# the mod's packages
		$this.thismodpackages = Get-ChildItem "$($this.modSrcRoot)/Src" -Directory

		$this.isHl = $this._HasNativePackages()
		$this.cookHL = $this.isHl -and -not $this.debug

		if (-not $this.isHl -and $this.final_release) {
			ThrowFailure "-final_release only makes sense if the mod in question is a Highlander"
		}

		$this.modcookdir = [io.path]::combine($this.sdkPath, 'XComGame', 'Published', 'CookedPCConsole')

		$this.buildCachePath = [io.path]::combine($this.projectRoot, 'BuildCache')
		if (!(Test-Path $this.buildCachePath))
		{
			New-Item -ItemType "directory" -Path $this.buildCachePath
		}

		$this.makeFingerprintsPath = "$($this.sdkPath)\XComGame\lastBuildDetails.json"
		$lastBuildDetails = if (Test-Path $this.makeFingerprintsPath) {
			Get-Content $this.makeFingerprintsPath | ConvertFrom-Json
		} else {
			[PSCustomObject]@{}
		}

		@("buildMode", "globalsHash", "coreTimestamp") | ForEach-Object {
			if(-not (Get-Member -InputObject $lastBuildDetails -name $_ -Membertype Properties)) {
				$lastBuildDetails | Add-Member -NotePropertyName $_ -NotePropertyValue "unknown"
			}
		}

		$lastBuildDetails | ConvertTo-Json | Set-Content -Path $this.makeFingerprintsPath
	}

	[void]_LoadContentOptions() {
		Write-Host "Preparing content options"

		if ([string]::IsNullOrEmpty($this.contentOptionsJsonFilename))
		{
			$this.contentOptions = [PSCustomObject]@{}
		}
		else
		{
			$contentOptionsJsonPath = Join-Path $this.modSrcRoot $this.contentOptionsJsonFilename
			
			if (!(Test-Path $contentOptionsJsonPath)) {
				ThrowFailure "ContentOptionsJsonPath $contentOptionsJsonPath doesn't exist"
			}
			
			$this.contentOptions = Get-Content $contentOptionsJsonPath | ConvertFrom-Json
			Write-Host "Loaded $($contentOptionsJsonPath)"
		}

		if (($this.contentOptions.PSobject.Properties | ForEach-Object {$_.Name}) -notcontains "missingUncooked")
		{
			Write-Host "No missing uncooked"
			$this.contentOptions | Add-Member -MemberType NoteProperty -Name 'missingUncooked' -Value @()
		}

		if (($this.contentOptions.PSobject.Properties | ForEach-Object {$_.Name}) -notcontains "sfCollectionMaps")
		{
			Write-Host "No collection maps to cook"
			$this.contentOptions | Add-Member -MemberType NoteProperty -Name 'sfCollectionMaps' -Value @()
		}
	}

	[void]_CopyModToSdk() {
		$xf = @("*.x2proj")

		if (![string]::IsNullOrEmpty($this.contentOptionsJsonFilename)) {
			$xf += $this.contentOptionsJsonFilename
		}
		
		Write-Host "Copying mod project to staging..."
		Robocopy.exe "$($this.modSrcRoot)" "$($this.sdkPath)\XComGame\Mods\$($this.modNameCanonical)" *.* $global:def_robocopy_args /XF @xf /XD "ContentForCook"
		Write-Host "Copied project to staging."

		New-Item "$($this.stagingPath)/Script" -ItemType Directory

		# read mod metadata from the x2proj file
		Write-Host "Reading mod metadata from $($this.modSrcRoot)\$($this.modNameCanonical).x2proj..."
		[xml]$x2projXml = Get-Content -Path "$($this.modSrcRoot)\$($this.modNameCanonical).x2proj"
		$modProperties = $x2projXml.Project.PropertyGroup[0]
		$publishedId = $modProperties.SteamPublishID
		if ($this.publishID -ne -1) {
			$publishedId = $this.publishID
			Write-Host "Using override workshop ID of $publishedId"
		}
		$title = $modProperties.Name
		$description = $modProperties.Description
		Write-Host "Read."

		Write-Host "Writing mod metadata..."
		Set-Content "$($this.sdkPath)/XComGame/Mods/$($this.modNameCanonical)/$($this.modNameCanonical).XComMod" "[mod]`npublishedFileId=$publishedId`nTitle=$title`nDescription=$description`nRequiresXPACK=true"
		Write-Host "Written."

		# Create CookedPCConsole folder for the mod
		if ($this.cookHL) {
			New-Item "$($this.stagingPath)/CookedPCConsole" -ItemType Directory
		}
	}
	
	[void]_CleanAdditional() {
		# clean
		foreach ($modName in $this.clean) {
			$cleanDir = "$($this.sdkPath)/XComGame/Mods/$($modName)"
			if (Test-Path $cleanDir) {
				Write-Host "Cleaning $($modName)..."
				Remove-Item -Recurse -Force $cleanDir
			}
		}
	}

	[void]_ConvertLocalization() {
		Get-ChildItem "$($this.stagingPath)\Localization" -Recurse -File | 
		Foreach-Object {
			$content = Get-Content $_.FullName -Encoding UTF8
			$content | Out-File $_.FullName -Encoding Unicode
		}
	}

	[void]_CopyToSrc() {
		# mirror the SDK's SrcOrig to its Src
		Write-Host "Mirroring SrcOrig to Src..."
		Robocopy.exe "$($this.sdkPath)\Development\SrcOrig" "$($this.devSrcRoot)" *.uc *.uci $global:def_robocopy_args
		Write-Host "Mirrored SrcOrig to Src."

		$this._ParseMacroFile("$($this.devSrcRoot)\Core\Globals.uci")

		# Copy dependencies
		Write-Host "Copying dependency sources to Src..."
		foreach ($depfolder in $this.include) {
			Get-ChildItem "$($depfolder)" -Directory -Name | Write-Host
			$this._CopySrcFolder($depfolder)
		}
		Write-Host "Copied dependency sources to Src."

		# copying the mod's scripts to the script staging location
		Write-Host "Copying the mod's sources to Src..."
		$this._CopySrcFolder("$($this.modSrcRoot)\Src")
		Write-Host "Copied mod sources to Src."
	}

	[void]_CopySrcFolder([string] $includeDir) {
		Copy-Item "$($includeDir)\*" "$($this.devSrcRoot)\" -Force -Recurse -WarningAction SilentlyContinue
		$extraGlobalsFile = "$($includeDir)\extra_globals.uci"
		if (Test-Path $extraGlobalsFile) {
			# append extra_globals.uci to globals.uci
			"// Macros included from $($extraGlobalsFile)" | Add-Content "$($this.devSrcRoot)\Core\Globals.uci"
			Get-Content $extraGlobalsFile | Add-Content "$($this.devSrcRoot)\Core\Globals.uci"

			$this._ParseMacroFile($extraGlobalsFile)
		}
	}

	[void]_ParseMacroFile([string]$file) {
		$lines = Get-Content $file
		# check for dupes
		$redefine = $false
		$lineNr = 1
		foreach ($line in $lines) {
			$defineMatch = $line | Select-String -Pattern '^\s*`define\s*([a-zA-Z][a-zA-Z0-9_]*)'
			if ($null -ne $defineMatch -and $defineMatch.Matches.Success) {
				[string]$macroName = $defineMatch.Matches.Groups[1]
				$prevDef = $this.macroDefs[$macroName]
				if ($null -ne $prevDef -and
					-not $redefine -and
					$prevDef.file -ne $file) {
					Write-Host -ForegroundColor Red "Error: Implicit redefinition of macro $($macroName)"
					$defineWord = if ($prevDef.redefine) { "redefined" } else { "defined" }
					Write-Host "    Note: Previously $($defineWord) at $($prevDef.file)($($prevDef.lineNr))"
					Write-Host "    Note: Implicitly redefined at $($file)($($lineNr))"
					Write-Host "    Help: Rename the macro, or add ``// X2MBC-Redefine`` above to explicitly redefine and silence this warning."
					ThrowFailure "Implicit macro redefinition."
				}
				$macroDef = [PSCustomObject]@{
					file = $file
					lineNr = $lineNr
					redefine = $redefine
				}
				$this.macroDefs[$macroName] = $macroDef
			} elseif ($line -match '^\s*`define') {
				ThrowFailure "Unrecognized macro at $($file)($($line)). This is a bug in X2ModBuildCommon."
			}

			$redefine = $line -match "X2MBC-Redefine"
			$lineNr += 1
		}
	}

	[void]_RunPreMakeHooks() {
		foreach ($hook in $this.preMakeHooks) {
			$hook.Invoke()
		}
	}

	[string]_GetCoreMtime() {
		if (Test-Path "$($this.sdkPath)/XComGame/Script/Core.u") {
			return Get-Item "$($this.sdkPath)/XComGame/Script/Core.u" | Select-Object -ExpandProperty LastWriteTime
		} else {
			return "missing"
		}
	}

	[void]_CheckCleanCompiled() {
		# #16: Switching between debug and release causes an error in the make commandlet if script packages aren't deleted.
		# #20: Changes to Globals.uci aren't tracked by UCC, so we must delete script packages if Globals.uci changes.
		$lastBuildDetails = Get-Content $this.makeFingerprintsPath | ConvertFrom-Json

		$buildMode = if ($this.debug -eq $true) { "debug" } else { "release" }
		$globalsHash = Get-FileHash "$($this.sdkPath)\Development\Src\Core\Globals.uci" | Select-Object -ExpandProperty Hash
		$coreTimeStamp = $this._GetCoreMtime()

		$rebuild = if ($lastBuildDetails.buildMode -ne $buildMode) {
			Write-Host "Detected switch between debug and non-debug build."
			$true
		} elseif ($lastBuildDetails.coreTimestamp -ne $coreTimeStamp) {
			Write-Host "Detected previous external rebuild."
			$true
		} elseif ($lastBuildDetails.globalsHash -ne $globalsHash) {
			Write-Host "Detected change in macros (Globals.uci)."
			$true
		} else {
			$false
		}

		# Order: Deleting first cannot cause an issue because the compiler will just rebuild.
		if ($rebuild) {
			Write-Host "Cleaning all compiled scripts from $($this.sdkPath)/XComGame/Script to avoid compiler error..."
			Remove-Item "$($this.sdkPath)/XComGame/Script/*.u"
			Write-Host "Cleaned."
		}

		$lastBuildDetails.buildMode = $buildMode
		$lastBuildDetails.globalsHash = $globalsHash

		# Similarly, recording the previous invocation fingerprints before the build is complete
		# cannot cause an issue because the compiler will simply continue an interrupted build.
		$lastBuildDetails | ConvertTo-Json | Set-Content -Path $this.makeFingerprintsPath
	}

	[void]_RecordCoreTimestamp() {
		# Unfortunately, ModBuddy with Fxs' plugin can rebuild the packages under our nose.
		# As a last resort, record the Core.u timestamp
		$lastBuildDetails = Get-Content $this.makeFingerprintsPath | ConvertFrom-Json
		$lastBuildDetails.coreTimestamp = $this._GetCoreMtime()
		$lastBuildDetails | ConvertTo-Json | Set-Content -Path $this.makeFingerprintsPath
	}

	[void]_RunMakeBase() {
		# build the base game scripts
		$scriptsMakeArguments = "make -nopause -unattended"
		if ($this.final_release -eq $true)
		{
			$scriptsMakeArguments = "$scriptsMakeArguments -final_release"
		}
		if ($this.debug -eq $true)
		{
			$scriptsMakeArguments = "$scriptsMakeArguments -debug"
		}

		$handler = [MakeStdoutReceiver]::new($this.devSrcRoot, "$($this.modSrcRoot)\Src")
		$handler.processDescr = "compiling base game scripts"
		$this._InvokeEditorCmdlet($handler, $scriptsMakeArguments, 50)

		# If we build in final release, we must build the normal scripts too
		if ($this.final_release -eq $true)
		{
			Write-Host "Compiling base game scripts without final_release..."
			$scriptsMakeArguments = "make -nopause -unattended"
			$handler = [MakeStdoutReceiver]::new($this.devSrcRoot, "$($this.modSrcRoot)\Src")
			$handler.processDescr = "compiling base game scripts"
			$this._InvokeEditorCmdlet($handler, $scriptsMakeArguments, 50)
		}
	}

	[void]_RunMakeMod() {
		# build the mod's scripts
		$scriptsMakeArguments = "make -nopause -mods $($this.modNameCanonical) $($this.stagingPath)"
		if ($this.debug -eq $true)
		{
			$scriptsMakeArguments = "$scriptsMakeArguments -debug"
		}
		$handler = [MakeStdoutReceiver]::new($this.devSrcRoot, "$($this.modSrcRoot)\Src")
		$handler.processDescr = "compiling mod scripts"
		$this._InvokeEditorCmdlet($handler, $scriptsMakeArguments, 50)
	}

	[bool]_HasNativePackages() {
		# Check if this is a Highlander and we need to cook things
		$anynative = $false
		foreach ($name in $this.thismodpackages) 
		{
			if ($global:nativescriptpackages.Contains($name)) {
				$anynative = $true
				break
			}
		}
		return $anynative
	}

	[void]_CopyScriptPackages() {
		# copy packages to staging
		foreach ($name in $this.thismodpackages) {
			if ($this.cookHL -and $global:nativescriptpackages.Contains($name))
			{
				# This is a native (cooked) script package -- copy important upks
				Copy-Item "$($this.modcookdir)\$name.upk" "$($this.stagingPath)\CookedPCConsole" -Force -WarningAction SilentlyContinue
				Copy-Item "$($this.modcookdir)\$name.upk.uncompressed_size" "$($this.stagingPath)\CookedPCConsole" -Force -WarningAction SilentlyContinue
				Write-Host "$($this.modcookdir)\$name.upk"
			}
			else
			{
				# Or this is a non-native package
				Copy-Item "$($this.sdkPath)\XComGame\Script\$name.u" "$($this.stagingPath)\Script" -Force -WarningAction SilentlyContinue
				Write-Host "$($this.sdkPath)\XComGame\Script\$name.u"
			}
		}
	}

	[void]_PrecompileShaders() {
		Write-Host "Checking the need to PrecompileShaders"
		$contentfiles = @()

		if (Test-Path "$($this.modSrcRoot)/Content")
		{
			$contentfiles = $contentfiles + (Get-ChildItem "$($this.modSrcRoot)/Content" -Include *.upk, *.umap -Recurse -File)
		}
		
		# Turns out that seekfree packages contain an inlined shader cache, so there is no need to pass them through the shader precompiler
		# if (Test-Path "$($this.modSrcRoot)/ContentForCook")
		# {
		# 	$contentfiles = $contentfiles + (Get-ChildItem "$($this.modSrcRoot)/ContentForCook" -Include *.upk, *.umap -Recurse -File)
		# }

		if ($contentfiles.length -eq 0) {
			Write-Host "No content files, skipping PrecompileShaders."
			return
		}

		# for ($i = 0; $i -lt $contentfiles.Length; $i++) {
		# 	Write-Host $contentfiles[$i]
		# }

		$need_shader_precompile = $false
		$shaderCacheName = "$($this.modNameCanonical)_ModShaderCache.upk"
		$cachedShaderCachePath = "$($this.buildCachePath)/$($shaderCacheName)"
		
		# Try to find a reason to precompile the shaders
		if (!(Test-Path -Path $cachedShaderCachePath))
		{
			$need_shader_precompile = $true
		} 
		elseif ($contentfiles.length -gt 0)
		{
			$shader_cache = Get-Item $cachedShaderCachePath
			
			foreach ($file in $contentfiles)
			{
				if ($file.LastWriteTime -gt $shader_cache.LastWriteTime -Or $file.CreationTime -gt $shader_cache.LastWriteTime)
				{
					$need_shader_precompile = $true
					break
				}
			}
		}
		
		if ($need_shader_precompile)
		{
			# build the mod's shader cache
			Write-Host "Precompiling Shaders..."
			$precompileShadersFlags = "precompileshaders -nopause platform=pc_sm4 DLC=$($this.modNameCanonical)"

			$handler = [PassthroughReceiver]::new()
			$handler.processDescr = "precompiling shaders"
			$this._InvokeEditorCmdlet($handler, $precompileShadersFlags, 10)

			Write-Host "Generated Shader Cache."

			Copy-Item -Path "$($this.stagingPath)/Content/$shaderCacheName" -Destination $this.buildCachePath
		}
		else
		{
			Write-Host "No reason to precompile shaders, using existing"
			Copy-Item -Path $cachedShaderCachePath -Destination "$($this.stagingPath)/Content"
		}
	}

	[void]_RunCookAssets() {
		# Preliminary step: figure out what we need to do

		$contentForCookPath = "$($this.modSrcRoot)\ContentForCook"

		$sfCollectionOnlyMapsNames = @($this.contentOptions.sfCollectionMaps | ForEach-Object { $_.name })
		$sfStandaloneNames = @()
		$sfMapsNames = @()

		if (-not(Test-Path $contentForCookPath)) {
			if ($sfCollectionOnlyMapsNames.Length -lt 1) {
				ThrowFailure "Collection map cooking is requested, but no ContentForCook folder is present"
			}

			Write-Host "No assets to cook, skipping"
			return
		}

		if (Test-Path "$contentForCookPath/Maps") {
			$sfMapsNames = @(Get-ChildItem -Path "$contentForCookPath/Maps" -Recurse -Include *.umap | ForEach-Object { $_.BaseName })

			# Allow using the force-package-into-map functionality for non-empty maps
			$sfCollectionOnlyMapsNames = $sfCollectionOnlyMapsNames | Where-Object { $sfMapsNames -notcontains $_ }
		}

		if (Test-Path "$contentForCookPath/Standalone") {
			$sfStandaloneNames = @(Get-ChildItem -Path "$contentForCookPath/Standalone" -Recurse -Include *.upk | ForEach-Object { $_.BaseName })
		}

		if (($sfMapsNames.Length -lt 1) -and ($sfStandaloneNames.Length -lt 1) -and ($sfCollectionOnlyMapsNames.Length -lt 1)) {
			if ((Test-Path "$contentForCookPath/Secondary") -and ($null -ne (Get-ChildItem -Path "$contentForCookPath/Secondary" -Recurse -Include *.upk))) {
				ThrowFailure "Found secondary packages for cooking but nothing ever could use them"
			}

			Write-Host "No assets to cook, skipping"
			return
		}

		# We are definitely cooking
		Write-Host "Starting assets cooking"

		# Bit of debug info
		Write-Host "SF Standalone: $sfStandaloneNames"
		Write-Host "Maps: $sfMapsNames"
		Write-Host "Collection only maps: $sfCollectionOnlyMapsNames"

		# Step 0. Basic preparation
		
		$projectCookCacheDir = [io.path]::combine($this.buildCachePath, 'PublishedCookedPCConsole')
		$collectionMapsPath = [io.path]::combine($this.buildCachePath, 'CollectionMaps')
		$tfcSuffix = "_$($this.modNameCanonical)_"
		
		$sdkEnginePath = "$($this.sdkPath)/XComGame/Config/DefaultEngine.ini"
		$sdkEngineContentOriginal = Get-Content $sdkEnginePath | Out-String
		$sdkEngineChangesPreamble = "HACKS FOR MOD ASSETS COOKING"
		
		$cookOutputParentDir = [io.path]::combine($this.sdkPath, 'XComGame', 'Published')
		$cookOutputDir = [io.path]::combine($cookOutputParentDir, 'CookedPCConsole')

		$sdkContentModsDir = [io.path]::combine($this.sdkPath, 'XComGame', 'Content', 'Mods')
		$sdkContentModsOurDir = [io.path]::combine($sdkContentModsDir, $this.modNameCanonical)
		$sdkContentModsOurStandaloneDir = [io.path]::combine($sdkContentModsOurDir, "Standalone")
		$sdkContentModsOurGuardDir = [io.path]::combine($sdkContentModsOurDir, "aaaaaa")
		$sdkContentModsOurGuardPackagePath = [io.path]::combine($sdkContentModsOurGuardDir, "TEMP_DlcCookIteratorGuard_$($this.modNameCanonical).upk")
		
		# First, we need to check that everything is ready for us to do these shenanigans
		# This doesn't use locks, so it can break if multiple builds are running at the same time,
		# so let's hope that mod devs are smart enough to not run simultanoues builds
		
		if ($sdkEngineContentOriginal.Contains($sdkEngineChangesPreamble))
		{
			ThrowFailure "Another cook is already in progress (DefaultEngine.ini)"
		}

		# Prepare the changes to the engine ini
		$newEngineLines = @()

		# Denote the beginning of our changes (+ used by the check above)
		$newEngineLines += ";$sdkEngineChangesPreamble - $($this.modNameCanonical)"

		# Collection maps
		$newEngineLines += "[Engine.PackagesToForceCookPerMap]"
		foreach ($mapDef in $this.contentOptions.sfCollectionMaps) {
			$newEngineLines += "+Map=$($mapDef.name)"

			foreach ($package in $mapDef.packages) {
				$newEngineLines += "+Package=$package"
			}
		}

		# Paths
		$newEngineLines += "[Core.System]"
		if ($sfMapsNames.Length -gt 0) { $newEngineLines += "+Paths=$contentForCookPath\Maps" }
		if ($sfCollectionOnlyMapsNames.Length -gt 0) { $newEngineLines += "+Paths=$collectionMapsPath" }
		if (Test-Path "$contentForCookPath/Secondary") { $newEngineLines += "+Paths=$contentForCookPath\Secondary" }

		# Final content
		$sdkEngineContentNew = $newEngineLines -join "`n"
		$sdkEngineContentNew = "$sdkEngineContentOriginal`n$sdkEngineContentNew"

		# Prepare the cook output folder
		$previousCookOutputDirPath = $null
		if (Test-Path $cookOutputDir)
		{
			$previousCookOutputDirName = "Pre_$($this.modNameCanonical)_Cook_CookedPCConsole"
			$previousCookOutputDirPath = [io.path]::combine($this.sdkPath, 'XComGame', 'Published', $previousCookOutputDirName)
			
			Rename-Item $cookOutputDir $previousCookOutputDirName
		} 

		# Make sure our local cache folder exists
		if (!(Test-Path $projectCookCacheDir))
		{
			New-Item -ItemType "directory" -Path $projectCookCacheDir
		}

		# Prepare the list of maps to cook
		$cookedMaps = @()
		$dirtyMaps = @()

		# Check the dev-made maps
		# Not the best (doesn't take into account the dependencies) but will suffice for now
		foreach ($map in $sfMapsNames) {
			$cookedMaps += $map

			$cookedPath = "$projectCookCacheDir\$map.upk"

			if (!(Test-Path $cookedPath)) {
				Write-Host "$map has no cached cooked version"
				$dirtyMaps += $map
			}
			else {
				$original = Get-ChildItem -Path "$contentForCookPath\Maps" -Include "$map.umap" -Recurse

				if ($original.LastWriteTime -gt (Get-Item $cookedPath).LastWriteTime) {
					$dirtyMaps += $map
					Write-Host "$map original was updated"
				}
			}
		}

		# Check the collection maps
		foreach ($mapDef in $this.contentOptions.sfCollectionMaps) {
			$map = $mapDef.name
			$cookedPath = "$projectCookCacheDir\$map.upk"

			$cookedMaps += $map

			if (!(Test-Path $cookedPath)) {
				Write-Host "$map has no cached cooked version"
				$dirtyMaps += $map
			}
			else {
				$existingCooked = Get-Item $cookedPath

				foreach ($package in $mapDef.packages) {
					if (((Get-ChildItem -Path "$contentForCookPath\Secondary" -Include "$package.upk" -Recurse).LastWriteTime) -gt $existingCooked.LastWriteTime) {
						Write-Host "$map dependency was updated ($package)"
						$dirtyMaps += $map
						break
					}
				}
			}
		}

		# Dedupe for cases when collection maps are manually made
		# Also sort for consitency and ease of reading of the command line arguments
		$cookedMaps = $cookedMaps | Sort-Object -unique
		$dirtyMaps = $dirtyMaps | Sort-Object -unique

		# Prepare the command line arguments
		# Note that we still need the -TFCSUFFIX even though -DLCName suffixes the TFCs as with only the latter using TFCs will crash at runtime (reads from base game ones?)
		$mapsString = $dirtyMaps -join " "
		$cookFlags = "CookPackages $mapsString -skipmaps -platform=pcconsole -unattended -DLCName=$($this.modNameCanonical) -singlethread -TFCSUFFIX=$tfcSuffix"

		# Prepare the output handler
		$handler = [ModcookReceiver]::new()
		$handler.processDescr = "cooking mod packages"

		# Prep the folder for the collection maps
		# Not the most efficient approach, but there are bigger time saves to be had
		if ($sfCollectionOnlyMapsNames.Length -gt 0) {
			Remove-Item $collectionMapsPath -Force -Recurse -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
			New-Item -ItemType "directory" -Path $collectionMapsPath

			foreach ($map in $sfCollectionOnlyMapsNames) {
				# Important: we cannot use .umap extension here - git lfs (if in use) gets confused during git subtree add
				# See https://github.com/X2CommunityCore/X2ModBuildCommon/wiki/Do-not-use-.umap-for-files-in-this-repo
				Copy-Item "$global:buildCommonSelfPath\EmptyUMap" "$collectionMapsPath\$map.umap"
			}
		}

		# Prep the folder for the SF standalone packages

		if (!(Test-Path $sdkContentModsDir)) {
			New-Item -ItemType "directory" -Path $sdkContentModsDir
		} else {
			if (Test-Path $sdkContentModsOurDir) {
				# If we have any files, then something is happening here - abort
				if ((Get-ChildItem -Path $sdkContentModsOurDir -Force -File -Recurse).Length -gt 0) {
					ThrowFailure "$sdkContentModsOurDir is already in use (not empty)"
				}
			}
		}

		if ($sfStandaloneNames.Length -gt 0) {
			if (Test-Path $sdkContentModsOurDir) {
				# Empty folders don't matter at all - clean them up so that they don't get in the way
				Get-ChildItem -Path $sdkContentModsOurDir -Force -Directory |
					ForEach-Object { $_.FullName } |
					Remove-Item -Recurse
			} else {
				New-Item -ItemType "directory" -Path $sdkContentModsOurDir
			}

			# Prep the guard package.
			# When the cooker iterates the packages to decide what to cook, it will always skip the first
			# one alphabetically. To counteract this, we make a dummy package which will always be
			# iterated first
			New-Item -ItemType "directory" -Path $sdkContentModsOurGuardDir
			Copy-Item "$global:buildCommonSelfPath\EmptyPackage" $sdkContentModsOurGuardPackagePath
		} else {
			if (Test-Path $sdkContentModsOurDir) {
				# Just delete the folder so it doesn't cause any confusion
				Remove-Item $sdkContentModsOurDir -Force -Recurse
			}
		}

		# Backup the DefaultEngine.ini
		Copy-Item $sdkEnginePath "$($this.sdkPath)/XComGame/Config/DefaultEngine.ini.bak_PRE_ASSET_COOKING"

		# This try block needs to be kept as small as possible as it puts the SDK into a (temporary) invalid state
		try {
			# Redirect all the cook output to our local cache
			# This allows us to not recook everything when switching between projects (e.g. CHL)
			# Ensure parent directory exists
			if (-not (Test-Path -Path $cookOutputParentDir)) {
				New-Item -Path $cookOutputParentDir -Type Directory
			}
			New-Junction $cookOutputDir $projectCookCacheDir

			# Put our standalone packages in a place where the cooker looks for them
			if ($sfStandaloneNames.Length -gt 0) { New-Junction $sdkContentModsOurStandaloneDir "$contentForCookPath/Standalone" }

			# Set the modified engine.ini
			$sdkEngineContentNew | Set-Content $sdkEnginePath -NoNewline

			# while ($true) {}

			Write-Host "Invoking cooker"
			Write-Host $cookFlags

			# Invoke the cooker
			# Even a sleep of 1 ms causes a noticable delay between cooker being done (files created)
			# and output completing. So, just spin
			$this._InvokeEditorCmdlet($handler, $cookFlags, 0)
		}
		finally {
			Write-Host "Cleaning up the asset cooking hacks"

			# Revert ini
			try {
				$sdkEngineContentOriginal | Set-Content $sdkEnginePath -NoNewline
				Write-Host "Reverted $sdkEnginePath"	
			}
			catch {
				FailureMessage "Failed to revert $sdkEnginePath"
				FailureMessage $_
			}

			# Revert junctions

			try {
				Remove-Junction $cookOutputDir
				Write-Host "Removed $cookOutputDir junction"
			}
			catch {
				FailureMessage "Failed to remove $cookOutputDir junction"
				FailureMessage $_
			}

			if ($sfStandaloneNames.Length -gt 0) {
				try {
					Remove-Junction $sdkContentModsOurStandaloneDir
					Write-Host "Removed $sdkContentModsOurStandaloneDir junction"
				}
				catch {
					FailureMessage "Failed to remove $sdkContentModsOurStandaloneDir junction"
					FailureMessage $_
				}

				try {
					Remove-Item $sdkContentModsOurGuardDir -Recurse
					Write-Host "Removed $sdkContentModsOurGuardDir folder"
				}
				catch {
					FailureMessage "Failed to remove $sdkContentModsOurGuardDir folder"
					FailureMessage $_
				}

				try {
					# Important: not recursive!
					# If we failed to undo the Standalone junction above, we will nuke the original
					# packages in the mod project if this is a recursive removal
					Remove-Item $sdkContentModsOurDir 
					Write-Host "Removed $sdkContentModsOurDir folder"
				}
				catch {
					FailureMessage "Failed to remove $sdkContentModsOurDir folder"
					FailureMessage $_
				}
			}
			
			# Restore the HL cook folder
			if (![string]::IsNullOrEmpty($previousCookOutputDirPath))
			{
				try {
					if (Test-Path $cookOutputDir) {
						ThrowFailure "$cookOutputDir still exists, cannot restore previous"
					}

					Rename-Item $previousCookOutputDirPath "CookedPCConsole"
					Write-Host "Restored previous $cookOutputDir"	
				}
				catch {
					FailureMessage "Failed to restore previous $cookOutputDir"
					FailureMessage $_
				}
			}
		}

		# Prepare the folder for cooked stuff
		$stagingCookedDir = [io.path]::combine($this.stagingPath, 'CookedPCConsole')
		if (!(Test-Path $stagingCookedDir)) {
			New-Item -ItemType "directory" -Path $stagingCookedDir
		}
		
		# Copy over the TFC files
		# The name of the file is extrenely long and stupid, but I'm tired of various weird behaviours, so better safe than sorry
		Get-ChildItem -Path $projectCookCacheDir -Filter "*_$($this.modNameCanonical)_DLCTFC$tfcSuffix.tfc" | Copy-Item -Destination $stagingCookedDir
		
		# Copy over the maps
		for ($i = 0; $i -lt $cookedMaps.Length; $i++) {
			$umap = $cookedMaps[$i];
			Copy-Item "$projectCookCacheDir\$umap.upk" -Destination $stagingCookedDir
		}
		
		# Copy over the SF standalone packages
		foreach ($package in $sfStandaloneNames) {
			# Since we don't ship the GuidCache with the mod, we need to remove the _SF suffix.
			# Otherwise the game won't find the package
			$dest = [io.path]::Combine($stagingCookedDir, "$package.upk")
			Copy-Item "$projectCookCacheDir\${package}_SF.upk" -Destination $dest
		}

		Write-Host "Assets cook completed"
	}

	[void]_RunCookHL() {
		# Cook it
		# Normally, the mod tools create a symlink in the SDK directory to the game CookedPCConsole directory,
		# but we'll just be using the game one to make it more robust
		$cookedpcconsoledir = [io.path]::combine($this.gamePath, 'XComGame', 'CookedPCConsole')
		if(-not(Test-Path $this.modcookdir))
		{
			Write-Host "Creating Published/CookedPCConsole directory..."
			New-Item $this.modcookdir -ItemType Directory
		}

		[System.String[]]$files = "GuidCache.upk", "GlobalPersistentCookerData.upk", "PersistentCookerShaderData.bin"
		foreach ($name in $files) {
			if(-not(Test-Path ([io.path]::combine($this.modcookdir, $name))))
			{
				Write-Host "Copying $name..."
				Copy-Item ([io.path]::combine($cookedpcconsoledir, $name)) $this.modcookdir
			}
		}

		# Ideally, the cooking process wouldn't modify the big *.tfc files, but it does, so we don't overwrite existing ones (/XC /XN /XO)
		# In order to "reset" the cooking direcory, just delete it and let the script recreate them
		Write-Host "Copying Texture File Caches..."
		Robocopy.exe "$cookedpcconsoledir" "$($this.modcookdir)" *.tfc /NJH /XC /XN /XO
		Write-Host "Copied Texture File Caches."
		
		# Prepare editor args
		$cook_args = @("cookpackages", "-platform=pcconsole", "-quickanddirty", "-modcook", "-sha", "-multilanguagecook=INT+FRA+ITA+DEU+RUS+POL+KOR+ESN", "-singlethread", "-nopause")
		if ($this.final_release -eq $true)
		{
			$cook_args += "-final_release"
		}
		
		# The CookPackages commandlet generally is super unhelpful. The output is basically always the same and errors
		# don't occur -- it rather just crashes the game. Hence, we just buffer the output and present it to user only
		# if something went wrong

		# TODO: Filter more lines for HL cook? `Hashing`? `SHA: package not found`? `Couldn't find localized resource`?
		# `Warning, Texture file cache waste exceeds`? `Warning, Package _ is not conformed`?
		$handler = [BufferingReceiver]::new()
		$handler.processDescr = "cooking native packages"

		# Cook it!
		Write-Host "Invoking CookPackages (this may take a while)"
		$this._InvokeEditorCmdlet($handler, $cook_args, 10)
	}

	[void]_CopyMissingUncooked() {
		if ($this.contentOptions.missingUncooked.Length -lt 1)
		{
			Write-Host "Skipping Missing Uncooked logic"
			return
		}

		Write-Host "Including MissingUncooked"

		$missingUncookedPath = [io.path]::Combine($this.stagingPath, "Content", "MissingUncooked")
		$sdkContentPath = [io.path]::Combine($this.sdkPath, "XComGame", "Content")

		if (!(Test-Path $missingUncookedPath))
		{
			New-Item -ItemType "directory" -Path $missingUncookedPath
		}

		foreach ($fileName in $this.contentOptions.missingUncooked)
		{
			(Get-ChildItem -Path $sdkContentPath -Filter $fileName -Recurse).FullName | Copy-Item -Destination $missingUncookedPath
		}
	}

	[void]_FinalCopy() {
		$finalModPath = "$($this.gamePath)\XComGame\Mods\$($this.modNameCanonical)"

		# copy all staged files to the actual game's mods folder
		# TODO: Is the string interpolation required in the robocopy calls?
		Robocopy.exe "$($this.stagingPath)" "$($finalModPath)" *.* $global:def_robocopy_args
	}

	[void]_InvokeEditorCmdlet([StdoutReceiver] $receiver, [string] $makeFlags, [int] $sleepMsDuration) {
		# Create a ProcessStartInfo object to hold the details of the make command, its arguments, and set up
		# stdout/stderr redirection.
		$pinfo = New-Object System.Diagnostics.ProcessStartInfo
		$pinfo.FileName = $this.commandletHostPath
		$pinfo.RedirectStandardOutput = $true
		$pinfo.RedirectStandardError = $true
		$pinfo.UseShellExecute = $false
		$pinfo.Arguments = $makeFlags
		$pinfo.WorkingDirectory = $this.commandletHostPath | Split-Path


		# Set the exited flag on our exit object on process exit.
		# We need another object for the Exited event to set a flag we can monitor from this function.
		$exitData = New-Object psobject -property @{ exited = $false }
		$exitAction = {
			$event.MessageData.exited = $true
		}

		# An action for handling data written to stderr. The Cmdlets don't seem to write anything here,
		# or at least not diagnostics, so we can just pass it through.
		$errAction = {
			$errTxt = $Event.SourceEventArgs.Data
			Write-Host $errTxt
		}

		$messageData = New-Object psobject -property @{
			handler = $receiver
		}

		# Create an stdout filter action delegating to the actual implementation
		$outAction = {
			[StdoutReceiver] $handler = $event.MessageData.handler
			[string] $outTxt = $Event.SourceEventArgs.Data
			$handler.ParseLine($outTxt)
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
		try {
			if ($sleepMsDuration -lt 1) {
				while (!$exitData.exited) {
					# Just spin
				}		
			} else {
				while (!$exitData.exited) {
					Start-Sleep -m $sleepMsDuration
				}		
			}
		}
		finally {
			# If we are stopping MSBuild hosted build, we need to kill the editor manually
			if (!$exitData.exited) {
				Write-Host "Killing $($receiver.processDescr) tree"
				KillProcessTree $process.Id
			}
		}

		$exitCode = $process.ExitCode
		$receiver.Finish($exitCode)
	}
}

class StdoutReceiver {
	[bool] $crashDetected = $false
	[string] $processDescr = ""

	[void]ParseLine([string] $outTxt) {
		if ($outTxt.Contains("Crash Detected") -or $outTxt.Contains("(filename not found)")) {
			$this.crashDetected = $true
		}
	}

	[void]Finish([int] $exitCode) {
		if ($this.crashDetected) {
			ThrowFailure "Crash detected while $($this.processDescr)"
		}

		if ($exitCode -ne 0) {
			ThrowFailure "Failed $($this.processDescr)"
		}
	}
}

class PassthroughReceiver : StdoutReceiver {
	PassthroughReceiver(){
	}

	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		Write-Host $outTxt
	}

	[void]Finish([int] $exitCode) {
		([StdoutReceiver]$this).Finish($exitCode)
	}
}

class BufferingReceiver : StdoutReceiver {
	[object] $logLines
	BufferingReceiver(){
		$this.logLines = New-Object System.Collections.Generic.List[System.Object]
	}

	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		$this.logLines.Add($outTxt)
	}

	[void]Finish([int] $exitCode) {
		if (($exitCode -ne 0) -or $this.crashDetected) {
			foreach ($line in $this.logLines) {
				Write-Host $line
			}
		}
		([StdoutReceiver]$this).Finish($exitCode)
	}
}


class MakeStdoutReceiver : StdoutReceiver {
	[string] $developmentDirectory
	[string] $modSrcRoot

	MakeStdoutReceiver(
		[string]$developmentDirectory,
		[string]$modSrcRoot
	){
		$this.developmentDirectory = $developmentDirectory
		$this.modSrcRoot = $modSrcRoot
	}

	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		$messagePattern = "^(.*)\(([0-9]*)\) : (.*)$"
		if (($outTxt -Match "Error|Warning") -And ($outTxt -Match $messagePattern)) {
			# And just do a regex replace on the sdk Development directory with the mod src directory.
			# The pattern needs escaping to avoid backslashes in the path being interpreted as regex escapes, etc.
			$pattern = [regex]::Escape($this.developmentDirectory)
			# n.b. -Replace is case insensitive
			$replacementTxt = $outtxt -Replace $pattern, $this.modSrcRoot
			# this syntax works with both VS Code and ModBuddy
			$outTxt = $replacementTxt -Replace $messagePattern, '$1($2) : $3'
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

	[void]Finish([int] $exitCode) {
		([StdoutReceiver]$this).Finish($exitCode)
	}
}

class ModcookReceiver : StdoutReceiver {
	[bool] $lastLineWasAdding = $false
	[bool] $permitAdditional = $false

	ModcookReceiver(){
	}
	
	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		$permitLine = $true # Default to true in case there is something we don't handle

		if ($outTxt.StartsWith("Adding package") -or $outTxt.StartsWith("Adding level") -or $outTxt.StartsWith("GFx movie package")) {
			if ($outTxt.Contains("\BuildCache\") -or $outTxt.Contains("\ContentForCook\") -or $outTxt.Contains("\Mods\")) {
				$permitLine = $true
			} else {
				$permitLine = $false

				if (!$this.lastLineWasAdding) {
					Write-Host "[Adding sdk assets ...]"
				}
			}

			$this.lastLineWasAdding = !$permitLine
			$this.permitAdditional = $permitLine
		} elseif ($outTxt.StartsWith("Adding additional")) {
			$permitLine = $this.permitAdditional
		} else {
			$this.lastLineWasAdding = $false
			$permitLine = $true
		}

		if ($permitLine) {
			Write-Host $outTxt
		}
	}

	[void]Finish([int] $exitCode) {
		([StdoutReceiver]$this).Finish($exitCode)
	}
}

function FailureMessage($message)
{
	[System.Media.SystemSounds]::Hand.Play()
	Write-Host $message -ForegroundColor "Red"
}

function ThrowFailure($message)
{
	throw $message
}

function SuccessMessage($message, $modNameCanonical)
{
	[System.Media.SystemSounds]::Asterisk.Play()
	Write-Host $message -ForegroundColor "Green"
	Write-Host "$modNameCanonical ready to run." -ForegroundColor "Green"
}

function FormatElapsed($elapsed) {
	return $elapsed.TotalSeconds.ToString("0.00s", $global:invarCulture)
}

function New-Junction ([string] $source, [string] $destination) {
	Write-Host "Creating Junction: $source -> $destination"
	&"$global:buildCommonSelfPath\junction.exe" -nobanner -accepteula "$source" "$destination"
}

function Remove-Junction ([string] $path) {
	Write-Host "Removing Junction: $path"
	&"$global:buildCommonSelfPath\junction.exe" -nobanner -accepteula -d "$path"
}

# https://stackoverflow.com/a/55942155/2588539
# $process.Kill() works but we really need to kill the child as well, since it's the one which is actually doing work
# Unfotunately, $process.Kill($true) does nothing 
function KillProcessTree ([int] $ppid) {
	Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ppid } | ForEach-Object { KillProcessTree $_.ProcessId }
	Stop-Process -Id $ppid
}
