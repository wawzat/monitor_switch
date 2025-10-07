# Get the path to the executable relative to the script's location
$exePath = Join-Path $PSScriptRoot "writeValueToDisplay.exe"

# Set both monitors to HDMI 1
& $exePath 0 0x90 0xF4 0x50
& $exePath 1 0x90 0xF4 0x50