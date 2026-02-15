function Invoke-DisableAutoDrivers {

    <#
        .SYNOPSIS
        Disables or enables automatic driver updates and sets all related Registry keys.
    #>

    Param(
        [bool]$Enabled = $true
    )

    $driverValue = if ($Enabled) { 0 } else { 1 }

    $registryKeys = @(
        @{ Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update"; Name = "ExcludeWUDriversInQualityUpdate"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Update"; Name = "ExcludeWUDriversInQualityUpdate"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate"; Name = "value"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"; Name = "ExcludeWUDriversInQualityUpdate"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"; Name = "ExcludeWUDriversInQualityUpdate"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"; Name = "SearchOrderConfig"; Value = $driverValue }
    )

    foreach ($key in $registryKeys) {
        try {
            if (-not (Test-Path $key.Path)) {
                New-Item -Path $key.Path -Force | Out-Null
            }
            Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -Type DWord -Force
            Write-Host "Set $($key.Path)\$($key.Name) = $($key.Value)" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to set $($key.Path)\$($key.Name) : $_"
        }
    }

    Write-Host ("Auto drivers update " + (if ($Enabled) {"Disabled"} else {"Enabled"})) -ForegroundColor Cyan
}