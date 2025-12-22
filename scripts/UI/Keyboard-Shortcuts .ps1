$KeyEvents = {

    $modifiers = $_.KeyboardDevice.Modifiers
    $key = $_.Key

    switch ($key) {
        "Enter" {
            if ($itt.currentList -eq "AppsListView") { Invoke-Install }
            elseif ($itt.currentList -eq "TweaksListView") { Invoke-Apply }
        }
        "S" {
            if ($modifiers -eq "Ctrl") {
                if ($itt.currentList -eq "AppsListView") { Invoke-Install }
                elseif ($itt.currentList -eq "TweaksListView") { Invoke-Apply }
            }
            elseif ($modifiers -eq "Shift") { Save-File }
        }
        "D" { 
            if ($itt.ProcessRunning) { Set-Statusbar -Text "📢 Shortcut is disabled while process is running" return }
            if ($modifiers -eq "Shift") { Get-file } 
        }
        "Q" {
            if ($modifiers -eq "Ctrl") {
                $itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "apps" }
            }
            elseif ($modifiers -eq "Shift") { RestorePoint }
        }
        "W" { if ($modifiers -eq "Ctrl") { $itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "tweeksTab" } } }
        "E" { if ($modifiers -eq "Ctrl") { $itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "SettingsTab" } } }
        "I" {
            if ($modifiers -eq "Ctrl") { About }
            elseif ($modifiers -eq "Shift") { ITTShortcut }
        }
        "C" { if ($modifiers -eq "Shift") { Start-Process explorer.exe $env:ProgramData\chocolatey\lib } }
        "T" { if ($modifiers -eq "Shift") { Start-Process explorer.exe $env:ProgramData\itt } }
        "G" { if ($modifiers -eq "Ctrl") { $this.Close() } }
        "F" {
            if ($modifiers -eq "Ctrl") {
                if ($itt.SearchInput.IsFocused) {
                    $itt.SearchInput.MoveFocus((New-Object System.Windows.Input.TraversalRequest([System.Windows.Input.FocusNavigationDirection]::Next)))
                } else {
                    $itt.SearchInput.Focus()
                }
            }
        }
        "A" {
            if ($modifiers -eq "Ctrl" -and ($itt.CurrentCategory -eq "AppsCategory" -or $itt.CurrentCategory -eq "TwaeksCategory")) {
                $itt["window"].FindName($itt.CurrentCategory).SelectedIndex = 0
            }
        }
    }
}
