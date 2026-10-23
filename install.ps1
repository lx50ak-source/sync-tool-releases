# sync_tool installer / updater.
# Usage (one line, in PowerShell):
#   irm https://raw.githubusercontent.com/lx50ak-source/sync-tool-releases/main/install.ps1 | iex
# Downloads the latest release, installs it for the current user (no admin rights), and starts it.
# The app then registers itself to start with Windows and adds the "Send to" menu entry.
# Settings and pairings (%APPDATA%\sync_tool) are kept across updates.

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # the progress bar makes Invoke-WebRequest very slow on Windows PowerShell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = 'lx50ak-source/sync-tool-releases'
$dir  = Join-Path $env:LOCALAPPDATA 'Programs\sync_tool'
$zip  = Join-Path $env:TEMP 'sync_tool.zip'

Write-Host 'sync_tool: downloading the latest version...'
Invoke-WebRequest "https://github.com/$repo/releases/latest/download/sync_tool.zip" -OutFile $zip -UseBasicParsing

# Stop a running copy so its files can be replaced (it is restarted below).
Get-Process sync_tool -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

New-Item -ItemType Directory -Force -Path $dir | Out-Null
Expand-Archive -Path $zip -DestinationPath $dir -Force
Remove-Item $zip -Force

# Start it through Explorer so it doesn't belong to this PowerShell window in any way.
Start-Process explorer.exe -ArgumentList "`"$(Join-Path $dir 'sync_tool.exe')`""
Write-Host "sync_tool: installed in $dir and running (icon next to the clock)."
Write-Host 'If Windows Firewall asks, allow it on private networks.'
