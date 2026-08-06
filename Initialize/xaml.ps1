#===========================================================================
#region initialize Runspace
#===========================================================================
# Max threads = number of logical processors
$MaxThreads = [int]$env:NUMBER_OF_PROCESSORS

# Create a session state variable entry for sharing $itt across runspaces
$HashVars = New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry `
    -ArgumentList 'itt', $itt, $null

# Create the initial session state
$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$InitialSessionState.Variables.Add($HashVars)
#===========================================================================
#endregion initialize Runspace
#===========================================================================

# ================================
#region Function Injection
# ================================

# List of functions to include in the runspace environment
$Functions = @(
    'Install-App', 'Install-Dependencies', 'Install-Winget', 'Add-Log', 'Finish', 'Message',
    'Notify', 'UpdateUI', 'ExecuteCommand', 'Set-Registry', 'Set-Taskbar',
    'Refresh-Explorer', 'CreateRestorePoint', 'Set-Statusbar'
)

foreach ($Func in $Functions) {
    $Command = Get-Command $Func -ErrorAction SilentlyContinue
    if ($Command) {
        $InitialSessionState.Commands.Add(
            (New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry `
                $Command.Name, $Command.ScriptBlock.ToString())
        )
            
        # Debug start
        #Write-Output "  [Debug] <$Func> included in runspace`n"

        Add-Log "<$Func> included in runspace`n" -Level "debug"

        # Debug end
    }
}
# ================================
#endregion Function Injection
# ================================

# ================================
#region Runspace Pool Creation
# ================================

$itt.Runspace = [RunspaceFactory]::CreateRunspacePool(
    1, $MaxThreads, $InitialSessionState, $Host
)

$itt.Runspace.Open()
# ================================
#endregion Runspace Pool Creation
# ================================

# ================================
#region UI Windows Initialization
# ================================

try {
    [xml]$MainXaml = $MainWindowXaml
    $itt["window"] = [Windows.Markup.XamlReader]::Load([System.Xml.XmlNodeReader]$MainXaml)
}
catch {
    Write-Output "Error initializing UI: $($_.Exception.Message)"
}

# ==================================
#endregion UI Windows Initialization
# ==================================

#===========================================================================
#region Initialize WPF Controls
#===========================================================================
# List Views
$itt.CurrentList
$itt.CurrentCategory
$itt.TabControl = $itt["window"].FindName("taps")
$itt.AppsListView = $itt["window"].FindName("AppsListView")
$itt.TweaksListView = $itt["window"].FindName("TweaksListView")
$itt.searchInput = $itt["window"].FindName("searchInput")
$itt.SettingsListView = $itt["window"].FindName("SettingsList")

# Buttons and Inputs
$itt.Description = $itt["window"].FindName("description")
$itt.Statusbar = $itt["window"].FindName("statusbar")
$itt.InstallBtn = $itt["window"].FindName("installBtn")
$itt.ApplyBtn = $itt["window"].FindName("applyBtn")
$itt.installText = $itt["window"].FindName("installText")
$itt.installIcon = $itt["window"].FindName("installIcon")
$itt.applyText = $itt["window"].FindName("applyText")
$itt.applyIcon = $itt["window"].FindName("applyIcon")
$itt.QuoteIcon = $itt["window"].FindName("QuoteIcon")

#===========================================================================
#endregion Initialize WPF Controls
#===========================================================================

#===========================================================================
#region Create default keys
#===========================================================================
try {
    # Get current os theme
    $appsTheme = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"
    $fullCulture = Get-ItemPropertyValue -Path "HKCU:\Control Panel\International" -Name "LocaleName"
    $shortCulture = $fullCulture.Split('-')[0]
    # Ensure registry key exists and set defaults if necessary
    if (-not (Test-Path $itt.registryPath)) {
        New-Item -Path $itt.registryPath -Force | Out-Null
        Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
        Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -Force
        Set-ItemProperty -Path $itt.registryPath -Name "backup" -Value 0 -Force
        Set-ItemProperty -Path $itt.registryPath -Name "source" -Value "auto" -Force
        $itt['window'].FindName('hotdot').Visibility = [System.Windows.Visibility]::Visible
    }
    else {
        # HIDE HOTDOT IF NOT FIRST TIME
        $itt['window'].FindName('hotdot').Visibility = [System.Windows.Visibility]::Hidden
    }
    try {
        # Attempt to get existing registry values
        $itt.Theme = (Get-ItemProperty -Path $itt.registryPath -Name "Theme" -ErrorAction Stop).Theme
        $itt.Locales = (Get-ItemProperty -Path $itt.registryPath -Name "locales" -ErrorAction Stop).locales
        $itt.backup = (Get-ItemProperty -Path $itt.registryPath -Name "backup" -ErrorAction Stop).backup
        $itt.PackgeManager = (Get-ItemProperty -Path $itt.registryPath -Name "source" -ErrorAction Stop).source
    }
    catch {
        # Creating missing registry keys
        # debug start
        if ($Debug) { Add-Log -Message "Creating missing registry keys..." -Level "debug" }
        # debug end
        New-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -PropertyType String -Force *> $Null
        New-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -PropertyType String -Force *> $Null
        New-ItemProperty -Path $itt.registryPath -Name "backup" -Value 0 -PropertyType DWORD -Force *> $Null
        New-ItemProperty -Path $itt.registryPath -Name "source" -Value "auto" -PropertyType String -Force *> $Null
    }


    #===========================================================================
    #region Fetch Data
    #===========================================================================
    $h = [System.Net.Http.HttpClientHandler]::new()
    $h.AutomaticDecompression = [System.Net.DecompressionMethods] 'GZip,Deflate'
    $c = [System.Net.Http.HttpClient]::new($h)

    # debug start
        # $appsUrl = "http://127.0.0.1:5500/static/Database/Applications.json"
         #$tweaksUrl = "http://127.0.0.1:5500/static/Database/Tweaks.json"
    # debug end

    $appsUrl = "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Applications.json"
    $tweaksUrl = "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Tweaks.json"
    #$localsUrl = "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/locales.json"

    while ($true) {
        try {
            $appsTask   = $c.GetStringAsync($appsUrl)
            $tweaksTask = $c.GetStringAsync($tweaksUrl)

            $appsJson   = $appsTask.GetAwaiter().GetResult()
            $tweaksJson = $tweaksTask.GetAwaiter().GetResult()

            $appsData   = $appsJson | ConvertFrom-Json
            $tweaksData = $tweaksJson | ConvertFrom-Json

            if ($appsData -and $tweaksData) 
            {
                foreach ($app in $appsData)
                {
                    if ($app.link)
                    {
                        $app | Add-Member -Force NoteProperty Icon (
                            "https://www.google.com/s2/favicons?sz=64&domain_url=$([Uri]::EscapeDataString($app.link))"
                        )

                        $app | Add-Member -Force NoteProperty IconVisibility "Visible"
                    }
                    else
                    {
                        $app | Add-Member -Force NoteProperty Icon ""
                        $app | Add-Member -Force NoteProperty IconVisibility "Collapsed"
                    }
                }

                $itt.AppsListView.ItemsSource   = $appsData
                $itt.TweaksListView.ItemsSource = $tweaksData

                $splash.Close()
                break
            }

            Write-Host "Still loading data..." -ForegroundColor Yellow
        }
        catch {
            Write-Host "Unstable internet connection detected. Retrying in 10 seconds..." -ForegroundColor Yellow
        }

        Start-Sleep -Seconds 10
    }
    #===========================================================================
    #endregion Fetch Data
    #===========================================================================
    #===========================================================================
    #region Set Language based on culture
    #===========================================================================
    try {
        $Locales = switch ($itt.Locales) {
            "default" {
                switch ($shortCulture) {
                    #{LangagesSwitch}
                    default { "en" }
                }
            }
            #{LangagesSwitch}
            default { "en" }
        }
        $itt["window"].DataContext = $itt.database.locales.Controls.$Locales
        $itt.Language = $Locales
    }
    catch {
        # fallbak to en lang
        $itt["window"].DataContext = $itt.database.locales.Controls.en
    }
    #===========================================================================
    #endregion Set Language based on culture
    #===========================================================================
    #===========================================================================
    #region Check theme settings
    #===========================================================================
    try {
        $Themes = switch ($itt.Theme) {
            #{ThemesSwitch}
            default {
                switch ($appsTheme) {
                    "0" { 
                        "Dark"
                        Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
                    }
                    "1" { 
                        
                        "Light" 
                        Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
                    }
                }
            }
        }
        $itt["window"].Resources.MergedDictionaries.Add($itt["window"].FindResource($Themes))
        $itt.Theme = $Themes
    }
    catch {
        # Fall back to default theme if there error
        $fallback = switch ($appsTheme) {
            "0" { "Dark" }
            "1" { "Light" }
        }
        Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
        $itt["window"].Resources.MergedDictionaries.Add($itt["window"].FindResource($fallback))
        $itt.Theme = $fallback
    }
    #===========================================================================
    #endregion Check theme settings
    #===========================================================================
    #===========================================================================
    #region Get user Settings from registry
    #===========================================================================
    # Init mediaPlayer
    $itt["window"].title = "Install Tweaks Tool | Emad Adel"
    #===========================================================================
    #endregion Get user Settings from registry
    #===========================================================================
    # init taskbar icon
    $itt["window"].TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
    if (-not $Debug) { Set-Taskbar -progress "None" -icon "logo" }
}
catch {
    Write-Output "Error: $_"
}
#===========================================================================
#endregion Create default keys
#===========================================================================