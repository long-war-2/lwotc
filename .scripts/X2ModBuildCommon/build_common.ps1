Write-Host "Build Common Loading"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

$global:buildCommonSelfPath = split-path -parent $MyInvocation.MyCommand.Definition

$cleanCookerOutput = Join-Path -Path $global:buildCommonSelfPath "clean_cooker_output.ps1"
Write-Host "Sourcing $cleanCookerOutput"
. $cleanCookerOutput

# list of all native script packages
$global:nativescriptpackages = @("XComGame", "Core", "Engine", "GFxUI", "AkAudio", "GameFramework", "UnrealEd", "GFxUIEditor", "IpDrv", "OnlineSubsystemPC", "OnlineSubsystemLive", "OnlineSubsystemSteamworks", "OnlineSubsystemPSN")
$global:def_robocopy_args = @("/S", "/E", "/COPY:DAT", "/PURGE", "/MIR", "/NP", "/R:1000000", "/W:30")

$global:invarCulture = [System.Globalization.CultureInfo]::InvariantCulture

class BuildProject {
	[string] $modNameCanonical
	[string] $modNameFull
	[string] $projectRoot
	[string] $sdkPath
	[string] $gamePath
	[string] $finalModPath
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
	[string] $modX2projPath
	[string] $devSrcRoot
	[string] $stagingPath
	[string] $xcomModPath
	[string] $commandletHostPath
	[string] $buildCachePath
	[string] $cookerOutputPath
	[string] $makeFingerprintsPath
	[string[]] $thismodpackages
	[bool] $isHl
	[bool] $cookHL
	[PSCustomObject] $contentOptions
	[string] $sdkEngineIniPath
	[string] $sdkEngineIniContent

	BuildProject(
		[string]$mod,
		[string]$projectRoot,
		[string]$sdkPath,
		[string]$gamePath
	){
		$this.modNameFull = $mod
		$this.modNameCanonical = $mod -Replace '[\s;]',''
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
		$this.modSrcRoot = "$($this.projectRoot)\$($this.modNameFull)"
		$this.modX2projPath = "$($this.modSrcRoot)\$($this.modNameFull).x2proj"
		$this.stagingPath = "$($this.sdkPath)\XComGame\Mods\$($this.modNameCanonical)"
		$this.xcomModPath = "$($this.stagingPath)\$($this.modNameCanonical).XComMod"
		$this.finalModPath = "$($this.gamePath)\XComGame\Mods\$($this.modNameCanonical)"
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

		$this.cookerOutputPath = [io.path]::combine($this.sdkPath, 'XComGame', 'Published', 'CookedPCConsole')

		$this.buildCachePath = [io.path]::combine($this.projectRoot, 'BuildCache')
		if (!(Test-Path $this.buildCachePath))
		{
			New-Item -ItemType "directory" -Path $this.buildCachePath
		}

		$this.sdkEngineIniPath = "$($this.sdkPath)/XComGame/Config/DefaultEngine.ini"
		$this.sdkEngineIniContent = Get-Content $this.sdkEngineIniPath | Out-String

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

		if (($this.contentOptions.PSobject.Properties | ForEach-Object {$_.Name}) -notcontains "sfStandalone")
		{
			Write-Host "No packages to make SF"
			$this.contentOptions | Add-Member -MemberType NoteProperty -Name 'sfStandalone' -Value @()
		}
		
		if (($this.contentOptions.PSobject.Properties | ForEach-Object {$_.Name}) -notcontains "sfMaps")
		{
			Write-Host "No umaps to cook"
			$this.contentOptions | Add-Member -MemberType NoteProperty -Name 'sfMaps' -Value @()
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
		Robocopy.exe "$($this.modSrcRoot)" "$($this.stagingPath)" *.* $global:def_robocopy_args /XF @xf /XD "ContentForCook"
		Write-Host "Copied project to staging."

		New-Item "$($this.stagingPath)/Script" -ItemType Directory

		# read mod metadata from the x2proj file
		Write-Host "Reading mod metadata from $($this.modX2ProjPath)"
		[xml]$x2projXml = Get-Content -Path "$($this.modX2ProjPath)"
		$xmlPropertyGroup = $x2projXml.Project.PropertyGroup
		$modProperties = if ($xmlPropertyGroup -is [array]) { $xmlPropertyGroup[0] } else { $xmlPropertyGroup }
		$publishedId = $modProperties.SteamPublishID
		if ($this.publishID -ne -1) {
			$publishedId = $this.publishID
			Write-Host "Using override workshop ID of $publishedId"
		}
		$title = $modProperties.Name
		$description = $modProperties.Description
		Write-Host "Read."

		Write-Host "Writing mod metadata..."
		Set-Content "$($this.xcomModPath)" "[mod]`npublishedFileId=$publishedId`nTitle=$title`nDescription=$description`nRequiresXPACK=true"
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

		$handler = [MakeStdoutReceiver]::new($this)
		$handler.processDescr = "compiling base game scripts"
		$this._InvokeEditorCmdlet($handler, $scriptsMakeArguments, 50)

		# If we build in final release, we must build the normal scripts too
		if ($this.final_release -eq $true)
		{
			Write-Host "Compiling base game scripts without final_release..."
			$scriptsMakeArguments = "make -nopause -unattended"
			$handler = [MakeStdoutReceiver]::new($this)
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
		$handler = [MakeStdoutReceiver]::new($this)
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
				Copy-Item "$($this.cookerOutputPath)\$name.upk" "$($this.stagingPath)\CookedPCConsole" -Force -WarningAction SilentlyContinue
				Copy-Item "$($this.cookerOutputPath)\$name.upk.uncompressed_size" "$($this.stagingPath)\CookedPCConsole" -Force -WarningAction SilentlyContinue
				Write-Host "$($this.cookerOutputPath)\$name.upk"
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

		# We don't need to consider
		# .umaps - they will never contain material (instances) objects - only reference them
		# ContentForCook - seekfree packages have an inlined shader cache

		if (Test-Path "$($this.modSrcRoot)/Content")
		{
			$contentfiles += Get-ChildItem "$($this.modSrcRoot)/Content" -Include *.upk -Recurse -File
		}

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
		$step = [ModAssetsCookStep]::new($this)
		$step.Execute()
	}

	[void]_RunCookHL() {
		$this._EnsureCookerOutputParentDirExists()

		# Cook it
		# Normally, the mod tools create a symlink in the SDK directory to the game CookedPCConsole directory,
		# but we'll just be using the game one to make it more robust
		$cookedpcconsoledir = [io.path]::combine($this.gamePath, 'XComGame', 'CookedPCConsole')

		[System.String[]]$files = "GuidCache.upk", "GlobalPersistentCookerData.upk", "PersistentCookerShaderData.bin"
		foreach ($name in $files) {
			if(-not(Test-Path ([io.path]::combine($this.cookerOutputPath, $name))))
			{
				Write-Host "Copying $name..."
				Copy-Item ([io.path]::combine($cookedpcconsoledir, $name)) $this.cookerOutputPath
			}
		}

		# Ideally, the cooking process wouldn't modify the big *.tfc files, but it does, so we don't overwrite existing ones (/XC /XN /XO)
		# In order to "reset" the cooking direcory, just delete it and let the script recreate them
		Write-Host "Copying Texture File Caches..."
		Robocopy.exe "$cookedpcconsoledir" "$($this.cookerOutputPath)" *.tfc /NJH /XC /XN /XO
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

	[void] _EnsureCookerOutputParentDirExists () {
		if(-not(Test-Path $this.cookerOutputPath)) {
			Write-Host "Creating Published/CookedPCConsole directory..."
			New-Item $this.cookerOutputPath -ItemType Directory
		}
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
		# copy all staged files to the actual game's mods folder
		# TODO: Is the string interpolation required in the robocopy calls?
		Robocopy.exe "$($this.stagingPath)" "$($this.finalModPath)" *.* $global:def_robocopy_args
	}

	[string[]] _PrepareBuildCacheEngineIniWithAdditions ([string] $fileNamePrefix, [array] $lines) {
		$localDefaultEngineIniPath = [io.path]::combine($this.buildCachePath, $fileNamePrefix + "_DefaultEngine.ini")
		$localXComEngineIniPath = [io.path]::combine($this.buildCachePath, $fileNamePrefix + "_XComEngine.ini")

		$newEngineIniContent = $this.sdkEngineIniContent + "`n" + ($lines -join "`n") + "`n"
		$newEngineIniContent | Set-Content $localDefaultEngineIniPath -NoNewline

		return @($localDefaultEngineIniPath, $localXComEngineIniPath)
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

class ModAssetsCookStep {
	[BuildProject] $project

	[string] $xpackTfcSuffix = '_XPACK_'
	[string] $actualTfcSuffix

	[string] $contentForCookPath
	[string] $collectionMapsPath

	[string] $sdkContentModsDir
	[string] $sdkContentModsOurDir

	[string[]] $dirtyMaps
	[string[]] $cookedMaps
	[string[]] $sfCollectionOnlyMaps

	[string] $engineIniDefaultPath
	[string] $engineIniXComPath

	[string] $editorArgs

	[string] $cookerOutputTrackerPath
	[object] $cookerOutputTracker

	ModAssetsCookStep ([BuildProject] $project) {
		$this.project = $project
	}

	[void] Execute() {
		if (($this.project.contentOptions.sfStandalone.Length -lt 1) -and ($this.project.contentOptions.sfMaps.Length -lt 1) -and ($this.project.contentOptions.sfCollectionMaps.Length -lt 1)) {
			Write-Host "No asset cooking is requested, skipping"
			return

			# TODO: Check if there are any assets in ContentForCook when no cooking is configured
		}

		Write-Host "Initializing assets cooking"

		$this._Init()
		$this._Verify()
		
		Write-Host "Preparing assets cooking"

		$this._PrepareSdkFolders()
		$this._PrepareProjectCache()
		
		$this._VerifyCachedTfcsNotAltered() # Needs to be after _PrepareProjectCache (CollectionMaps are created) and _PrepareSdkFolders (otherwise Get-ChildItem for TFCs fails)
		$this._VerifyCachedSfPackagesNotAltered()
		
		$this._DetermineDirtyMaps()
		$this._PrepareEngineIni()
		$this._PrepareEditorArgs()

		Write-Host "Starting assets cooking"
		
		$this._ExecuteCore()
		$this._WarnTfcGrowth()
		$this._RecordCookerOutputTracker()
		$this._StageArtifacts()

		Write-Host "Assets cook completed"
	}

	[void] _Init() {
		$this.actualTfcSuffix = "_$($this.project.modNameCanonical)_DLCTFC$($this.xpackTfcSuffix)"

		$this.contentForCookPath = "$($this.project.modSrcRoot)\ContentForCook"
		$this.collectionMapsPath = [io.path]::combine($this.project.buildCachePath, 'CollectionMaps')
		
		$this.sdkContentModsDir = [io.path]::combine($this.project.sdkPath, 'XComGame', 'Content', 'Mods')
		$this.sdkContentModsOurDir = [io.path]::combine($this.sdkContentModsDir, $this.project.modNameCanonical)

		$this.cookedMaps = @($this.project.contentOptions.sfMaps)
		foreach ($mapDef in $this.project.contentOptions.sfCollectionMaps) {
			$this.cookedMaps += $mapDef.name
		}
	
		$this.sfCollectionOnlyMaps = @()
		foreach ($mapDef in $this.project.contentOptions.sfCollectionMaps) {
			if ($null -eq (Get-ChildItem -Path $this.contentForCookPath -Filter $mapDef.name -Recurse)) {
				$this.sfCollectionOnlyMaps += $mapDef.name
			}
		}

		$this.cookerOutputTrackerPath = [io.path]::combine($this.project.buildCachePath, 'AssetsCookerOutputTracker.json')

		if (Test-Path $this.cookerOutputTrackerPath) {
			$this.cookerOutputTracker = Get-Content $this.cookerOutputTrackerPath | ConvertFrom-Json
		} else {
			$this.cookerOutputTracker = [PSCustomObject]@{
				tfcFiles = @() # Assume no TFCs if no info is stored. This will cause a full recook if any are found
				sfPackages = @()
			}
		}
	}

	[void] _Verify() {
		# TODO: consider removing this requirement.
		# It might be legitimate use case to cook a "secondary" vanilla package or a collection map that consists of only vanilla packages
		if (-not(Test-Path $this.contentForCookPath))
		{
			ThrowFailure "Asset cooking is requested, but no ContentForCook folder is present"
		}

		if (Test-Path $this.sdkContentModsOurDir) {
			# If we have any files, then something is happening here - abort
			if ($null -ne (Get-ChildItem -Path $this.sdkContentModsOurDir -Force -Recurse)) {
				ThrowFailure "$($this.sdkContentModsOurDir) is already in use (not empty)"
		}
	}

		# The DLC cooker needs to read/copy the shipped GPCD
		$shippedGpcdPath = [io.path]::combine($this.project.sdkPath, 'XComGame', 'CookedPCConsole', 'GlobalPersistentCookerData.upk')
		if (!(Test-Path $shippedGpcdPath)) {
			ThrowFailure "$shippedGpcdPath does not exist. Please verify your that your SDK is configured correctly"
		}
		}

	[void] _PrepareProjectCache() {
		# Prep the folder for the collection maps
		# Not the most efficient approach, but there are bigger time saves to be had
		Remove-Item $this.collectionMapsPath -Force -Recurse -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
		New-Item -ItemType "directory" -Path $this.collectionMapsPath

		foreach ($map in $this.sfCollectionOnlyMaps) {
			# Important: we cannot use .umap extension here - git lfs (if in use) gets confused during git subtree add
			# See https://github.com/X2CommunityCore/X2ModBuildCommon/wiki/Do-not-use-.umap-for-files-in-this-repo
			Copy-Item "$global:buildCommonSelfPath\EmptyUMap" "$($this.collectionMapsPath)\$map.umap"
		}
	}
			
	[void] _VerifyCachedTfcsNotAltered () {
		if (!$this._CheckCachedTfcsNotAltered()) {
			Write-Host "Performing a full recook"
			CleanModAssetCookerOutput $this.project.sdkPath $this.project.modNameCanonical @($this.contentForCookPath, $this.collectionMapsPath)

			# Save that everything is deleted
			$this.cookerOutputTracker.tfcFiles = @()
			$this._RecordCookerOutputTracker()
				 }
			}

	[bool] _CheckCachedTfcsNotAltered () {
		[System.Collections.ArrayList] $currentTfcs = @($this._GetOurTfcFiles() | Select-Object -ExpandProperty Name)

		foreach ($trackedFileData in $this.cookerOutputTracker.tfcFiles) {
			if (!$currentTfcs.Contains($trackedFileData.fullFileName)) {
				Write-Host "$($trackedFileData.fullFileName) is missing"
				return $false
			}

			$path = [io.path]::combine($this.project.cookerOutputPath, $trackedFileData.fullFileName)
			$file = Get-Item $path

			if ($file.LastWriteTimeUtc.Ticks -ne $trackedFileData.lastUpdatedUtc) {
				Write-Host "$($trackedFileData.fullFileName) timestamp mismatch"
				return $false
		}

			$currentTfcs.Remove($trackedFileData.fullFileName)
	}

		if ($currentTfcs.Count -gt 0) {
			Write-Host "Unexpected TFCs found: $currentTfcs"
			return $false
		}

		return $true
	}

	# Why is this needed?
	# It's technically fine to cook the same package from multiple mods.
	# However, if the package ends up having any textures that point to a TFC file,
	# they will be pointing to a TFC that we will not ship (as it is of a different DLC)
	# which at runtime will at best cause missing mip levels, and at worst, crash the game.
	[void] _VerifyCachedSfPackagesNotAltered () {
		# Delete tracked if timestamp doesn't match

		foreach ($trackedFileData in $this.cookerOutputTracker.sfPackages) {
			$path = [io.path]::combine($this.project.cookerOutputPath, $trackedFileData.fullFileName)

			if (Test-Path $path) {
				$file = Get-Item $path

				if ($file.LastWriteTimeUtc.Ticks -ne $trackedFileData.lastUpdatedUtc) {
					Write-Host "$($trackedFileData.fullFileName) timestamp mismatch - deleting"
					Remove-Item $path -Force
				}
			}
		}

		# Delete supposed-to-cook if they exist but are not tracked

		foreach ($fileName in $this._GetDesiredOutputPackageFileNames()) {
			$path = [io.path]::combine($this.project.cookerOutputPath, $fileName)
			$trackedFileData = $this._GetSfPackageTrackerData($fileName)

			if ($null -eq $trackedFileData -and (Test-Path $path)) {
				Write-Host "$fileName exists, but is not tracked - deleting"
				Remove-Item $path -Force
			}
		}
	}

	[void] _DetermineDirtyMaps () {
		$this.dirtyMaps = @()

		# Check the dev-made maps
		# Not the best (doesn't take into account the dependencies - FIXME) but will suffice for now.
		foreach ($map in $this.cookedMaps) {
			if ($this.sfCollectionOnlyMaps.Contains($map)) { continue; }

			$cookedPath = [io.path]::combine($this.project.cookerOutputPath, "$map.upk")

			if (!(Test-Path $cookedPath)) {
				Write-Host "$map has no cooked version"
				$this.dirtyMaps += $map
			}
			else {
				$original = Get-ChildItem -Path $this.contentForCookPath -Include "$map.umap" -Recurse

				if ($original.LastWriteTime -gt (Get-Item $cookedPath).LastWriteTime) {
					$this.dirtyMaps += $map
					Write-Host "$map original was updated"
				}
			}
		}

		# Check the collection maps
		foreach ($mapDef in $this.project.contentOptions.sfCollectionMaps) {
			$map = $mapDef.name
			$cookedPath = [io.path]::combine($this.project.cookerOutputPath, "$map.upk")

			if ($this.dirtyMaps.Contains($map)) { continue; }

			if (!(Test-Path $cookedPath)) {
				Write-Host "$map has no cooked version"
				$this.dirtyMaps += $map
			}
			else {
				$existingCooked = Get-Item $cookedPath

				foreach ($package in $mapDef.packages) {
					if (((Get-ChildItem -Path $this.contentForCookPath -Include "$package.upk" -Recurse).LastWriteTime) -gt $existingCooked.LastWriteTime) {
						Write-Host "$map dependency was updated ($package)"
						$this.dirtyMaps += $map
						break
					}
				}
			}
		}
	}

	[void] _PrepareEngineIni() {
		$this.engineIniDefaultPath, $this.engineIniXComPath =
			$this.project._PrepareBuildCacheEngineIniWithAdditions("AssetsCook", $this._PrepareEngineIniAdditions())
	}

	[string[]] _PrepareEngineIniAdditions () {
		$lines = @()

		# "Inject" our assets into the SDK to make them visible to the cooker
		$lines += "[Core.System]"
		$lines += "+Paths=$($this.contentForCookPath)"
		$lines += "-Paths=..\..\XComGame\Content\Mods" # Do not actually load the packages from there

		if ($this.sfCollectionOnlyMaps.Length -gt 0) {
		$lines += "+Paths=$($this.collectionMapsPath)"
	}

		# Stop all the "Adding [...]" garbage
		# TODO: our maps here?
		$lines += "[Engine.X2DirectoriesToSkipEnumeration]"
		$lines += ".Directory=..\..\XComGame"
		$lines += ".Directory=..\..\Engine"

		# Collection maps
		# TODO: Switch + to .
		$lines += "[Engine.PackagesToForceCookPerMap]"
		foreach ($mapDef in $this.project.contentOptions.sfCollectionMaps) {
			$lines += "+Map=$($mapDef.name)"

			foreach ($package in $mapDef.packages) {
				$lines += "+Package=$package"
			}
		}

		return $lines
	}

	[void] _PrepareSdkFolders () {
		$this.project._EnsureCookerOutputParentDirExists()
				
		if (-not(Test-Path $this.sdkContentModsOurDir)) {
			Write-Host "Creating $($this.sdkContentModsOurDir) directory..."
			New-Item $this.sdkContentModsOurDir -ItemType Directory
		}
	}

	[void] _PrepareEditorArgs () {
		$cookerFlags = "-platform=pcconsole -skipmaps -TFCSUFFIX=$($this.xpackTfcSuffix) -singlethread -unattended -DLCName=$($this.project.modNameCanonical)"
		$mapsString = $this.dirtyMaps -join " "

		$this.editorArgs = "CookPackages $mapsString $cookerFlags -DEFENGINEINI=""$($this.engineIniDefaultPath)"" -ENGINEINI=""$($this.engineIniXComPath)"""
	}

	[void] _ExecuteCore () {
		# This try block needs to be kept as small as possible as it puts the SDK into a (temporary) invalid state
		try {
			if ($this.project.contentOptions.sfStandalone.Length -gt 0) {
				# Create iterator guard (the first package alphabetically is always skipped)
				$this._CreateMarkerPackageFile('000000000_________IteratorGuard')

				# Create dummy files for each of the seekfree standalone packages
				foreach ($package in $this.project.contentOptions.sfStandalone) {
					$this._CreateMarkerPackageFile($package)
				}
			}

			$this._InvokeAssetCooker($this.editorArgs)
		}
		finally {
			Write-Host "Cleaning up the asset cooking hacks"
			$cleanupFailed = $false

				try {
				Remove-Item -Recurse -Force "$($this.sdkContentModsOurDir)\*"
				Write-Host "Emptied $($this.sdkContentModsOurDir)"
				}
				catch {
				FailureMessage "Failed to empty $($($this.sdkContentModsOurDir))"
					FailureMessage $_

					$cleanupFailed = $true
			}

			if ($cleanupFailed) {
				Write-Host ""
				Write-Host ""
				ThrowFailure "Failed to clean up the asset cooking hacks - your SDK is now in a corrupted state. Please preform the cleanup manually before building a mod or opening the editor."
			}
		}
	}

	[void] _CreateMarkerPackageFile ([string] $packageName) {
		New-Item -Path $this.sdkContentModsOurDir -Name "$packageName.upk" -ItemType File
	}

	[void] _InvokeAssetCooker ([string] $editorArguments) {
		Write-Host $editorArguments

		$handler = [ModcookReceiver]::new()
		$handler.processDescr = "cooking mod packages"

		# Even a sleep of 1 ms causes a noticable delay between cooker being done (files created)
		# and output completing. So, just spin
		$this.project._InvokeEditorCmdlet($handler, $editorArguments, 0)
	}

	[void] _WarnTfcGrowth () {
		$tfcs = $this._GetOurTfcFiles()
		$growthEntries = @()

		foreach ($file in $tfcs) {
			$trackedFileData = $this._GetTfcTrackerData($file.Name)

			if ($null -eq $trackedFileData) {
				# New file - ignore
				continue
			}

			if ($file.Length -eq $trackedFileData.originalSize) {
				continue
			}

			$increase = $file.Length / $trackedFileData.originalSize

			$growthEntries += [PSCustomObject]@{
				Name = $file.Name
				OriginalSize = FormatFileSize($trackedFileData.originalSize)
				CurrentSize = FormatFileSize($file.Length)
				Increase = "${increase}x"
			}
		}

		if ($growthEntries.Length -gt 0) {
			$growthEntries | Format-Table | Out-String | Write-Host

			Write-Host "WARNING: TFC files grew since initial creation. This could indicate data duplication."
			Write-Host "Your mod will still function normally, but the file size might be larger than needed"
			Write-Host "(i.e. useless data present). See above for details."
			Write-Host "You should consider doing a full rebuild before distributing your mod (e.g. via the workshop)."
			Write-Host ""
		}

		# TODO: current logic doesn't account for case when a package (which has/had textures) is removed from the seekfree list.
		# We will keep shipping the TFC (with useless data) in this case without any warnings
	}

	[void] _RecordCookerOutputTracker () {
		# TFCs

		$tfcs = $this._GetOurTfcFiles()

		foreach ($file in $tfcs) {
			$trackedFileData = $this._GetTfcTrackerData($file.Name)

			if ($null -eq $trackedFileData) {
				# Write-Host "New file: $($file.Name)"

				$this.cookerOutputTracker.tfcFiles += [PSCustomObject]@{
					fullFileName = $file.Name
					originalSize = $file.Length
					lastUpdatedUtc = $file.LastWriteTimeUtc.Ticks
				}

				continue
			}

			# Not a new file - just store the new last updated time
			$trackedFileData.lastUpdatedUtc = $file.LastWriteTimeUtc.Ticks
		}

		# SF packages

		$sfPackageFilesNames = $this._GetDesiredOutputPackageFileNames()
		# Write-Host "sfPackages: $sfPackageFilesNames"

		# SF packages (removed)
		$this.cookerOutputTracker.sfPackages = @($this.cookerOutputTracker.sfPackages | Where-Object { $sfPackageFilesNames.Contains($_.fullFileName) })
		
		# SF packages (new/updated)

		foreach ($fileName in $sfPackageFilesNames) {
			$file = Get-Item "$($this.project.cookerOutputPath)\$fileName"
			$trackedFileData = $this._GetSfPackageTrackerData($file.Name)

			if ($null -eq $trackedFileData) {
				# Write-Host "New file: $($file.Name)"

				$this.cookerOutputTracker.sfPackages += [PSCustomObject]@{
					fullFileName = $file.Name
					lastUpdatedUtc = $file.LastWriteTimeUtc.Ticks
				}

				continue
			}

			# Not a new file - just store the new last updated time
			$trackedFileData.lastUpdatedUtc = $file.LastWriteTimeUtc.Ticks
		}

		# Write the file
		$this.cookerOutputTracker | ConvertTo-Json | Set-Content -Path $this.cookerOutputTrackerPath
	}

	[string[]] _GetDesiredOutputPackageFileNames () {
		$sfPackageFilesNames = @($this.project.contentOptions.sfStandalone | Foreach-Object { "${_}_SF" })
		$sfPackageFilesNames += $this.cookedMaps

		return @($sfPackageFilesNames | Foreach-Object { "$_.upk" })
	}

	[PSCustomObject] _GetTfcTrackerData ([string] $fullFileName) {
		foreach ($fileData in $this.cookerOutputTracker.tfcFiles) {
			if ($fullFileName -eq $fileData.fullFileName) {
				return $fileData
			}
		}
		
		return $null
	}

	[PSCustomObject] _GetSfPackageTrackerData ([string] $fullFileName) {
		foreach ($fileData in $this.cookerOutputTracker.sfPackages) {
			if ($fullFileName -eq $fileData.fullFileName) {
				return $fileData
			}
		}

		return $null
	}

	[void] _StageArtifacts () {
		# Prepare the folder for cooked stuff
		$stagingCookedDir = [io.path]::combine($this.project.stagingPath, 'CookedPCConsole')
		if (!(Test-Path $stagingCookedDir)) {
			New-Item -ItemType "directory" -Path $stagingCookedDir
		}

		# Copy over the TFC files
		$this._GetOurTfcFiles() | Copy-Item -Destination $stagingCookedDir

		# Copy over the maps
		for ($i = 0; $i -lt $this.cookedMaps.Length; $i++) 
		{
			$umap = $this.cookedMaps[$i];
			Copy-Item "$($this.project.cookerOutputPath)\$umap.upk" -Destination $stagingCookedDir
		}

		# Copy over the SF packages
		for ($i = 0; $i -lt $this.project.contentOptions.sfStandalone.Length; $i++) 
		{
			$package = $this.project.contentOptions.sfStandalone[$i];
			$dest = [io.path]::Combine($stagingCookedDir, "${package}.upk");
			
			# We need to remove the _SF suffix, otherwise the game won't find the package
			Copy-Item "$($this.project.cookerOutputPath)\${package}_SF.upk" -Destination $dest
		}
	}

	[System.IO.FileInfo[]] _GetOurTfcFiles () {
		return @(Get-ChildItem -Path $this.project.cookerOutputPath -Filter "*$($this.actualTfcSuffix).tfc")
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
	[BuildProject] $proj
	[string[]] $reversePaths

	MakeStdoutReceiver(
		[BuildProject]$proj
	){
		$this.proj = $proj
		# Since later paths overwrite earlier files, check paths in reverse order
		$this.reversePaths = @("$($this.proj.sdkPath)\Development\SrcOrig") +
			$this.proj.include + @("$($this.proj.modSrcRoot)\Src")
		[array]::Reverse($this.reversePaths)
	}

	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		$messagePattern = "^(.*)\(([0-9]*)\) : (.*)$"
		if (($outTxt -Match "Error|Warning") -And ($outTxt -Match $messagePattern)) {
			# extract original path from $matches automatic variable created by above -Match
			$origPath = $matches[1]

			# create regex pattern specifically from the part we're interested in replacing
			$pattern = [regex]::Escape("$($this.proj.sdkPath)\Development\Src")

			$found = $false
			foreach ($checkPath in $this.reversePaths) {
				$testPath = $origPath -Replace $pattern,$checkPath
				# if the file exists, it's certainly the one that caused the error
				if (Test-Path $testPath) {
					# Normalize path to get rid of `..`s
					$testPath = [IO.Path]::GetFullPath($testPath)
					# this syntax works with both VS Code and ModBuddy
					$outTxt = $outTxt -Replace $messagePattern, ($testPath + '($2) : $3')
					$found = $true
					break
				}
			}
			if (-not $found) {
				$outTxt = $outTxt -Replace $messagePattern, ($origPath + '($2) : $3')
			}
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

	ModcookReceiver(){
	}
	
	[void]ParseLine([string] $outTxt) {
		([StdoutReceiver]$this).ParseLine($outTxt)
		$permitLine = $true # Default to true in case there is something we don't handle

		if ($outTxt.StartsWith("GFx movie package")) {
				$permitLine = $false

				if (!$this.lastLineWasAdding) {
				Write-Host "[GFx movie packages ...]"
			}

			$this.lastLineWasAdding = $true
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

# https://stackoverflow.com/a/55942155/2588539
# $process.Kill() works but we really need to kill the child as well, since it's the one which is actually doing work
# Unfotunately, $process.Kill($true) does nothing 
function KillProcessTree ([int] $ppid) {
	Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ppid } | ForEach-Object { KillProcessTree $_.ProcessId }
	Stop-Process -Id $ppid
}

# https://superuser.com/a/468795/673577
Function FormatFileSize () {
    Param ([int64]$size)
    If     ($size -gt 1TB) {[string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {[string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {[string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {[string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf ($size -gt 0)   {[string]::Format("{0:0.00} B", $size)}
    Else                   {""}
}