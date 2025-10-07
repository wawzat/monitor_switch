@echo off
setlocal

REM Get the directory of this batch file
set scriptDir=%~dp0

REM Build the full path to the PowerShell script
set psScript="%scriptDir%switch_hdmi1.ps1"

REM Run the PowerShell script
powershell.exe -ExecutionPolicy Bypass -File %psScript%

endlocal