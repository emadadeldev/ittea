function ExecuteCommand {

    <#
        .SYNOPSIS
        Executes a PowerShell command in a new process.
    #>

    param ($tweak)

    try {
        Add-Log -Message "Please wait..." -Level "INFO"
        $script = [scriptblock]::Create($tweak)
        Invoke-Command  $script -ErrorAction Stop
    } catch  {
        Add-Log -Message "ERROR: $($_.Exception.Message)" -Level "WARNING"
    }
}