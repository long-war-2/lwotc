@echo off

if "%XCOM2SDKPATH%" == "" (
    echo You need to specify the location of the XCOM 2 WOTC SDK in the XCOM2SDKPATH environment variable
    exit /b 1
)

if "%XCOM2GAMEPATH%" == "" (
    echo You need to specify the location of the XCOM 2 War of the Chosen game directory (typically ^<path to Steam^>\steamapps\common\XCOM 2\XCom2-WarOfTheChosen^)
    exit /b 1
)

rem The trailing backslash after %~dp0 is important, otherwise PowerShell thinks the " is being escaped!
powershell.exe -NonInteractive -ExecutionPolicy Unrestricted  -file "%~dp0.scripts\build.ps1" -srcDirectory "%~dp0\" -sdkPath "%XCOM2SDKPATH%" -gamePath "%XCOM2GAMEPATH%" %*
