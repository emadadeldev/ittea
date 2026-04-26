function Add-Log {

    <#
        .SYNOPSIS
        Custom Write-Host Display Text with icon and name
    #>

    param ([string]$Message, [string]$Level = "Default")

    $level = $Level.ToUpper()
    $date = Get-date -f "[HH:MM:ss tt]"
    $colorMap = @{ INFO="White"; WARNING="Yellow"; ERROR="Red"; INSTALLED="White"; APPLY="White"; DEBUG="Yellow" }
    $iconMap  = @{ INFO="[i]$date"; WARNING="[i]$date"; ERROR="[X]$date"; DEFAULT=""; DEBUG="[DEBUG]$date"; ITT="[ITT]$date"; Chocolatey="[Chocolatey]$date"; Winget="[Winget]$date" }

    $color = if ($colorMap.ContainsKey($level)) { $colorMap[$level] } else { "White" }
    $icon  = if ($iconMap.ContainsKey($level)) { $iconMap[$level] } else { "i" }

    Write-Host "  $icon $Message" -ForegroundColor $color
}