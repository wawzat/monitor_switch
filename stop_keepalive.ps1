$pidFilePath = Join-Path $env:USERPROFILE 'keepalive.pid'

if (-Not (Test-Path $pidFilePath)) {
    Write-Host "No PID file found at $pidFilePath." -ForegroundColor Yellow
    return
}

try {
    $raw = Get-Content $pidFilePath -ErrorAction Stop
    $keepAlivePid = [int]$raw
} catch {
    Write-Warning "Could not read a valid integer PID from file: $_"
    return
}

$proc = Get-Process -Id $keepAlivePid -ErrorAction SilentlyContinue
if ($proc) {
    try {
        Stop-Process -Id $keepAlivePid -Force -ErrorAction Stop
        Write-Host "Successfully stopped process $keepAlivePid." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to stop process $($keepAlivePid): $_"
    }
} else {
    Write-Host "No running process found with PID $keepAlivePid." -ForegroundColor Yellow
}

Remove-Item $pidFilePath -ErrorAction SilentlyContinue