# load file.itt
function Get-file {

    # Check if a process is running
    if ($itt.ProcessRunning) {
        Message -key "Please_wait" -icon "Warning" -action "OK"
        return
    }

    # Open file dialog to select JSON file
    $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog -Property @{
        Filter = "itt files (*.itt)|*.itt"
        Title  = "itt File"
    }

    if ($openFileDialog.ShowDialog() -eq $true) {

        try {

            # Load and parse JSON data
            $FileContent = Get-Content -Path $openFileDialog.FileName -Raw | ConvertFrom-Json -ErrorAction Stop

            # Check if ListView matches the current list
            if ($FileContent.ListView -ne $itt.currentList) {
                Message -NoneKey "PLEASE SELECT THE CORRECT TAB" -icon "Warning" -action "OK"
                return
            }

            # Get the apps list and collection view
            $collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt.($itt.currentList).Items)

            # Define the filter predicate using Items array
            $collectionView.Filter = {
                param($item)

                if ($FileContent.Items.Name -contains $item.Content) { 
                    $item.IsChecked = $true
                    return $true
                } else { 
                    return $false 
                }
            }
        }
        catch {
            Write-Warning "Failed to load or parse JSON file: $_"
        }
    }
}

# Save selected items to a JSON file
function Save-File {

    $itt['window'].FindName($itt.currentList).SelectedIndex = 0
    Show-Selected -ListView "$($itt.currentList)" -Mode "Filter"
    $selectedApps = Get-SelectedItems -Mode "$($itt.currentList)"

    if ($selectedApps.Count -le 0) { return }

    # Collect checked items
    $items = foreach ($item in $itt.$($itt.currentList).Items) {
        if ($item.IsChecked) {
            [PSCustomObject]@{
                Name = $item.Content
            }
        }
    }

    # If no items are selected, show a message and return
    if ($items.Count -eq 0) {
        Message -key "Empty_save_msg" -icon "Information" -action "OK"
        return
    }

    # Prepare the custom JSON structure
    $jsonObject = @{
        ListView = $itt.currentList
        Items    = $items
    }

    # Open save file dialog
    $saveFileDialog = New-Object Microsoft.Win32.SaveFileDialog -Property @{
        Filter = "JSON files (*.itt)|*.itt"
        Title  = "Save JSON File"
    }

    if ($saveFileDialog.ShowDialog() -eq $true) {
        # Save items to JSON file
        $jsonObject | ConvertTo-Json -Compress | Out-File -FilePath $saveFileDialog.FileName -Force
        Write-Host "Saved: $($saveFileDialog.FileName)"
    }

    # Uncheck checkboxes if user canceled
    Show-Selected -ListView "$($itt.currentList)" -Mode "Default"
}