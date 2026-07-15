# Console Color
$Host.UI.RawUI.BackgroundColor = 'Black'
# Console Title
$Host.UI.RawUI.WindowTitle = "Install Twaeks Tool"

# Clear Consle
Clear-Host


# Load DLLs
Add-Type -AssemblyName 'System.Windows.Forms', 'PresentationFramework', 'PresentationCore', 'WindowsBase','System.Net.Http'

# Init Splash Window
$reader = New-Object System.Xml.XmlNodeReader ([xml]$SplashWindowContent)
$splash = [Windows.Markup.XamlReader]::Load($reader)
# Show Splash Window
$splash.Show()

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

    Write-Host "`n  Checking everything...`n"

    while ($true) 
    {
        try {
            $latestVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/version.txt" -ErrorAction Stop).Trim()

            if ($latestVersion -ne $itt.version) {
                $splash.Close()
                Write-Host "YOU ARE USING AN OLD VERSION OF ITT. PORTABLE SCRIPT IS NOT RECOMMENDED`nPLEASE USE THE LATEST VERSION FROM THE OFFICIAL COMMANDS AT https://github.com/emadadeldev/ittea" -ForegroundColor Red
                Read-Host "Press Enter to visit https://github.com/emadadeldev/ittea"
                Start-Process "https://github.com/emadadeldev/ittea"
                exit
            }

            break
        }
        catch {
            Write-Host "  Unstable internet connection detected. Retrying in 10 seconds...`n" -ForegroundColor Yellow
            Start-Sleep 10
    }

}
}
# ================================
#endregion Check for updates
# ================================
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
Write-Host "  Version [$($itt.Version)]" -ForegroundColor Green
Write-Host "  Status [Verified]" -ForegroundColor Green
Write-Host "`n  Relax, good things are loading… almost there!`n"
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