function Startup {

    <#
    .SYNOPSIS
        Usage count, and quote display.
    #>

    ITT-ScriptBlock -ArgumentList $i, $Debug -ScriptBlock {
 
        param($Debug)
        
        # Get usage count
        function UsageCount {
            try {
                $Url = "https://itt.emadadel4-a0a.workers.dev/log"
                $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method GET
                $count = $response.Content.Trim()
                Add-Log -Message "`n  $count times worldwide`n"
            }
            catch {
                Start-Sleep 8
                UsageCount
            }
        }

        function Quotes {
            $q = (Invoke-RestMethod "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Quotes.json").Quotes | Sort-Object { Get-Random }
            Start-Sleep 18
            $i = @{quote = "💬"; info = "📢"; music = "🎵"; Cautton = "⚠"; default = "☕" }
            while (1) { foreach ($x in $q) { $c = $i[$x.type]; if (-not $c) { $c = $i.default }; $t = "`“$($x.text)`”"; if ($x.name) { $t += " ― $($x.name)" }; Set-Statusbar -Text "$c $t"; Start-Sleep 25 } }
        }

        function LOG {
            Write-Host "  ███████████████████╗ "
            Write-Host "  ██╚══██╔══╚═══██╔══╝ "
            Write-Host "  ██║  ██║ Emad ██║    " -NoNewline
            Write-Host "Main repository: https://github.com/emadadeldev/ittea" -ForegroundColor Yellow
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