function System-Default {

    try {
        $dc = $itt.database.locales.Controls.$shortCulture
        if (-not $dc -or [string]::IsNullOrWhiteSpace($dc)) {
            Set-Statusbar -Text "Default System language is not supported yet, Fallback to English"
            $dc = $itt.database.locales.Controls.en
            $itt.Language = "en"
        }
        
        $itt["window"].DataContext = $dc
        $itt.Language = $dc.Name
        Write-Host $itt.Language
        Set-ItemProperty -Path $itt.registryPath -Name "language" -Value "default" -Force
    }
    catch {
        Write-Host "An error occurred: $_"
    }
}

function Set-Language {
    param ([string]$lang)
    if ($lang -eq "default") { System-Default }
    else {
        $itt.Language = $lang
        $itt["window"].DataContext = $itt.database.locales.Controls.$($itt.Language)
        Set-ItemProperty -Path $itt.registryPath -Name "language" -Value $lang -Force
    }
}