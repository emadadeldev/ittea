param (
    # debug start
    [switch]$Debug,
    # debug end
    # Quick install
    [string]$i
)

# Load DLLs
Add-Type -AssemblyName 'System.Windows.Forms', 'PresentationFramework', 'PresentationCore', 'WindowsBase','System.Net.Http'
$Host.UI.RawUI.WindowTitle = "Install Twaeks Tool"

# ================================
#region Hashtable
# ================================
# Synchronized Hashtable for shared variables
$itt = [Hashtable]::Synchronized(@{

    database       = @{}
    ProcessRunning = $false
    lastupdate     = "#{replaceme}"
    registryPath   = "HKCU:\Software\ITT@emadadel"
    icon           = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/icon.ico"
    Theme          = "default"
    Date           = (Get-Date -Format "MM/dd/yyy")
    Language       = "default"
    ittDir         = "$env:ProgramData\itt\"
    command        = "$($MyInvocation.MyCommand.Definition)"
})
# ================================
#endregion Hashtable
# ================================

# ================================
#region Check for updates
# ================================
if(-not $Debug)
{
    $checkUrl = "https://ver.emadadel4-a0a.workers.dev/check?version=$($itt.lastupdate)"
    $response = Invoke-RestMethod -Uri $checkUrl -ErrorAction Stop
    if ($response.status) {
        Write-Host "$($response.message)" -ForegroundColor Red
        read-host "   Press Enter to visit https://github.com/emadadeldev/ittea"
        Start-Process("https://github.com/emadadeldev/ittea")
        exit
    }
}
# ================================
#endregion Check for updates
# ================================

# ================================
#region Ask user for administrator privileges if not already running as admin
# ================================
# Ask user for administrator privileges if not already running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "PowerShell" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
    exit
}
# ================================
#endregion Ask user for administrator privileges if not already running as admin
# ================================

Write-Host "`n  Relax, good things are loading… almost there!" -ForegroundColor Yellow

# Create directory if it doesn't exist
if (-not (Test-Path -Path $itt.ittDir)) {New-Item -ItemType Directory -Path $itt.ittDir -Force | Out-Null}

# Trace the script
Start-Transcript -Path (Join-Path $itt.ittDir "logs\log_$(Get-Date -Format 'yyyy-MM-dd').log") -Append -Force *> $null