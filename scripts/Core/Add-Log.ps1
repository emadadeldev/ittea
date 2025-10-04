function Add-Log {

    <#
        .SYNOPSIS
        Custom Write-Host Display Text with icon and name
    #>

    param ([string]$Message, [string]$Level = "Default")

    $level = $Level.ToUpper()
    $colorMap = @{ INFO="White"; WARNING="Yellow"; ERROR="Red"; INSTALLED="White"; APPLY="White"; DEBUG="Yellow" }
    $iconMap  = @{ INFO="[i]"; WARNING="[!]"; ERROR="[X]"; DEFAULT=""; DEBUG="[DEBUG]"; ITT="[ITT]"; Chocolatey="[Chocolatey]"; Winget="[Winget]" }

    $color = if ($colorMap.ContainsKey($level)) { $colorMap[$level] } else { "White" }
    $icon  = if ($iconMap.ContainsKey($level)) { $iconMap[$level] } else { "i" }

    Write-Host "$icon $Message" -ForegroundColor $color
}