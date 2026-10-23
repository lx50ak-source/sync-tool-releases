# sync_tool uninstaller.
# Usage (one line, in PowerShell):
#   irm https://raw.githubusercontent.com/lx50ak-source/sync-tool-releases/main/uninstall.ps1 | iex
# Removes the program, the login entry, the Start menu and "Send to" entries. Settings and pairings in
# %APPDATA%\sync_tool are kept; delete that folder too for a full reset.

$ErrorActionPreference = 'Stop'
$dir = Join-Path $env:LOCALAPPDATA 'Programs\sync_tool'

Get-Process sync_tool -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 1
Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name sync_tool -ErrorAction SilentlyContinue
Get-ChildItem -LiteralPath ([Environment]::GetFolderPath('SendTo')) -Filter '*(sync_tool).lnk' -ErrorAction SilentlyContinue | Remove-Item -Force
$startMenu = Join-Path ([Environment]::GetFolderPath('Programs')) 'sync_tool.lnk'
if (Test-Path $startMenu) { Remove-Item -LiteralPath $startMenu -Force }
if (Test-Path $dir) { Remove-Item -LiteralPath $dir -Recurse -Force }
Write-Host 'sync_tool: removed.'
