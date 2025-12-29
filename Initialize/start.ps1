# Load DLLs
Add-Type -AssemblyName 'System.Windows.Forms', 'PresentationFramework', 'PresentationCore', 'WindowsBase','System.Net.Http'

# Init Splash Window
$reader = New-Object System.Xml.XmlNodeReader ([xml]$SplashWindowContent)
$splash = [Windows.Markup.XamlReader]::Load($reader)
# Show Splash Window
$splash.Show()
Write-Host "`n  Relax, good things are loading… almost there!" -ForegroundColor Yellow

# Console Title
$Host.UI.RawUI.WindowTitle = "Install Twaeks Tool"

# ================================
#region Hashtable
# ================================
# Synchronized Hashtable for shared variables
$itt = [Hashtable]::Synchronized(@{
    ProcessRunning = $false
    database       = @{}
    api            = $null
    version        = "#{replaceme}"
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
    $checkUrl = "https://ver.emadadel4-a0a.workers.dev/check?version=$($itt.version)"
    $itt.api = Invoke-RestMethod -Uri $checkUrl -ErrorAction Stop
    if ($itt.api.status) {
        Write-Host "$($itt.api.message)" -ForegroundColor Red
        read-host "   Press Enter to visit https://github.com/emadadeldev/ittea"
        Start-Process("https://github.com/emadadeldev/ittea")
        $splash.Close()
        exit
        
    }
}
# ================================
#endregion Check for updates
# ================================

# ================================
#region Ask user for administrator privileges if not already running as admin
# ================================
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "PowerShell" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
    exit
}
# ================================
#endregion Ask user for administrator privileges if not already running as admin
# ================================
# Console Color
$Host.UI.RawUI.BackgroundColor = 'Black'
# Clear Consle
Clear-Host
# ================================
#region MAXIMIZE CURRENT WINDOW
# ================================
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
}
"@

$hwnd = [Win32]::GetConsoleWindow()
[Win32]::ShowWindowAsync($hwnd, 3) | Out-Null
# ================================
#endregion MAXIMIZE CURRENT WINDOW
# ================================

# Create directory if it doesn't exist
if (-not (Test-Path -Path $itt.ittDir)) {New-Item -ItemType Directory -Path $itt.ittDir -Force | Out-Null}
# Trace the script
Start-Transcript -Path (Join-Path $itt.ittDir "logs\log_$(Get-Date -Format 'yyyy-MM-dd').log") -Append -Force *> $null