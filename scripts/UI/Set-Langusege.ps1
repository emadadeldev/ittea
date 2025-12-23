function System-Default {

    $itt.Language = $itt.database.locales.Controls

    # Check if the property exists
    if ($itt.Language.PSObject.Properties.Name -contains $shortCulture) {
        $itt["window"].DataContext = $itt.database.locales.Controls.$shortCulture
        $itt.Language = $shortCulture 
    } 
    else
    {
        Set-Statusbar -Text "System language is not supported yet, Fallback to English"
        $itt.Language = "en" 
    }

    Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -Force
}

function Set-Language {
    param ([string]$lang)
    if ($lang -eq "default") { System-Default }
    else {
        $itt["window"].DataContext = $itt.database.locales.Controls.$($itt.Language)
        Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value $lang -Force
        $itt.Language = $lang
    }
}