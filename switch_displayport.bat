@echo off
setlocal

REM Load sensitive variables
call "%~dp0config.bat"

REM SSH key path (dynamic)
set sshKey=%USERPROFILE%\.ssh\id_rsa_windows

REM Trigger remote script inside desktop session
ssh -i "%sshKey%" %sshUserHost% %psexecPath% -i 1 powershell.exe -ExecutionPolicy Bypass -File %remoteScript%

endlocal