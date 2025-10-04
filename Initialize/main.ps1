#=========================================================================== 
#region Select elements with a Name attribute using XPath and iterate over them
#=========================================================================== 
$MainXaml.SelectNodes("//*[@Name]") | ForEach-Object {
    $name = $_.Name
    $element = $itt["window"].FindName($name)

    if ($element) {
        $itt[$name] = $element
        $type = $element.GetType().Name

        switch ($type) {
            "Button" { $element.Add_Click({ Invoke-Button $this.Name $this.Content }) }
            "MenuItem" { $element.Add_Click({ Invoke-Button $this.Name -Content $this.Header }) }
            "TextBox" { $element.Add_TextChanged({ Invoke-Button $this.Name $this.Text }) }
            "TextBlock" { $element.Add_MouseLeftButtonDown({ Invoke-Button $this.Name $this.Text }) }
            "ComboBox" { $element.add_SelectionChanged({ Invoke-Button $this.Name $this.SelectedItem.Content }) }
            "TabControl" { 
                $element.add_SelectionChanged({ Invoke-Button $this.Name $this.SelectedItem.Name }) 
                ChangeTap
            }
            "CheckBox" {
                $element.IsChecked = Get-ToggleStatus -ToggleSwitch $name
                $element.Add_Click({ Invoke-Toggle $this.Name })
            }
            "Border" {
                $element.Add_MouseLeftButtonDown({ Invoke-Button $this.Name $this.Text })
            }
        }
    }
}
#=========================================================================== 
#endregion Select elements with a Name attribute using XPath and iterate over them
#=========================================================================== 

# Define OnClosing event handler
$onClosingEvent = {
    param($s, $c)
    # Show confirmation message box
    $result = Message -key "Exit_msg" -icon "ask" -action "YesNo"
    if ($result -eq "Yes") {
        $itt.runspace.Dispose()
        $itt.runspace.Close()
        $script:powershell.Dispose()
        $script:powershell.Stop()
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
    else {
        $c.Cancel = $true
    }
}

$itt["window"].Add_ContentRendered({
    Startup
    Show-Event

    # Quick install
    if ($i) {
        Quick-Install -file $i *> $null
    }
})

# Close event handler
$itt["window"].add_Closing($onClosingEvent)

# Keyboard shortcut
$itt["window"].Add_PreViewKeyDown($KeyEvents)

# Show Window
$itt["window"].ShowDialog() | Out-Null

# Dispose of runspaces and other objects
$itt.runspace.Dispose()
$itt.runspace.Close()

# Collect garbage
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# Stop PowerShell session and release resources
$script:powershell.Dispose()
$script:powershell.Stop()

# Stop transcript logging
Stop-Transcript *> $null