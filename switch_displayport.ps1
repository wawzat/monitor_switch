# Set both monitors to DisplayPort
$exePath = Join-Path $PSScriptRoot "writeValueToDisplay.exe"

& $exePath 0 0xD0 0xF4 0x50
& $exePath 1 0xD0 0xF4 0x50