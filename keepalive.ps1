# The computer on DisplayPort will sleep unless kept awake by this script.
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class SleepBlocker {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
"@

# Prevent sleep and display turn-off
[SleepBlocker]::SetThreadExecutionState(2147483651)

# Write out our PID so external tools can track/kill us
$pid | Out-File "$env:USERPROFILE\keepalive.pid"

Write-Host "System sleep prevention active. Will exit at 10:00 PM."

# Calculate today's 10:00 PM
$endTime = (Get-Date).Date.AddHours(22)

# If it's already past 10 PM, clean up and exit immediately
if ((Get-Date) -ge $endTime) {
    Remove-Item "$env:USERPROFILE\keepalive.pid"
    Write-Host "It's already past 10:00 PM. Exiting script."
    exit
}

# Loop until we hit 10 PM, waking every 5 minutes
while ((Get-Date) -lt $endTime) {
    Start-Sleep -Seconds 300
}

# Cleanup once 10 PM arrives
Remove-Item "$env:USERPROFILE\keepalive.pid"
Write-Host "10:00 PM reached. Exiting script."