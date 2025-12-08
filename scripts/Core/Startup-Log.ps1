function Startup {

    <#
    .SYNOPSIS
        Runs startup tasks including usage logging, music playback, and quote display.
    #>

    ITT-ScriptBlock -ArgumentList $Debug -ScriptBlock {
 
        param($Debug)
        
        function UsageCount {
            try {
                $Message = "👨‍💻 Version: $($itt.version)`n🚀 URL: $($itt.command)"
                $EncodedMessage = [uri]::EscapeDataString($Message)
                $Url = "itt.emadadel4-a0a.workers.dev/log?text=$EncodedMessage"
                $result = Invoke-RestMethod -Uri $Url -Method GET
                Add-Log -Message "`n  $result times worldwide`n"
            }
            catch {
                Add-Log -Message "Unstable internet connection detected." -Level "info"
                Start-Sleep 10
                UsageCount
            }
        }

        function Quotes {
            $q = (Invoke-RestMethod "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Quotes.json").Quotes | Sort-Object { Get-Random }
            Set-Statusbar -Text "☕ $($itt.database.locales.Controls.$($itt.Language).welcome)"; Start-Sleep 18
            $i = @{quote = "💬"; info = "📢"; music = "🎵"; Cautton = "⚠"; default = "☕" }
            while (1) { foreach ($x in $q) { $c = $i[$x.type]; if (-not $c) { $c = $i.default }; $t = "`“$($x.text)`”"; if ($x.name) { $t += " ― $($x.name)" }; Set-Statusbar -Text "$c $t"; Start-Sleep 25 } }
        }

        function LOG {
            Write-Host "`n  $($itt.api.message)`n" -ForegroundColor Green
            Write-Host "  ███████████████████╗ " -NoNewline
            Write-Host "My old GitHub account was restricted without any reason." -ForegroundColor Gray
            Write-Host "  ██╚══██╔══╚═══██╔══╝ " -NoNewline
            Write-Host "This is the new official repo:" -ForegroundColor Gray
            Write-Host "  ██║  ██║ Emad ██║    " -NoNewline
            Write-Host "Main repository: https://github.com/emadadeldev/ittea" -ForegroundColor Gray
            Write-Host "  ██║  ██║ Adel ██║    " -NoNewline
            Write-Host "Backup 1: https://gitlab.com/emadadel/itt" -ForegroundColor Gray
            Write-Host "  ██║  ██║      ██║    " -NoNewline
            Write-Host "Backup 2: https://codeberg.org/emadadel/itt" -ForegroundColor Gray
            Write-Host "  ╚═╝  ╚═╝      ╚═╝    " -ForegroundColor White
            # debug start
            if ($Debug) { return }
            # debug end
            UsageCount
            Quotes
        }

        LOG
    }
}