function Get-File {
    
    param(
        [string]$Source
    )

    if ($itt.ProcessRunning) {
        Message -key "Please_wait" -icon "Warning" -action "OK"
        return
    }

    try {

        # =========================
        # CLI: URL or file path
        # =========================
        if ($Source) {

            if ($Source -match '^https?://') {
                # Load from URL
                $jsonRaw = (Invoke-WebRequest -Uri $Source -UseBasicParsing -ErrorAction Stop).Content
            }
            elseif (Test-Path $Source) {
                # Load from local file
                $jsonRaw = Get-Content -Path $Source -Raw
            }
            else {
                throw "Invalid source"
            }

        }
        # =========================
        #  UI: File Dialog
        # =========================
        else {

            $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog -Property @{
                Filter = "itt file (*.itt)|*.itt"
                Title  = "itt File"
            }

            if ($openFileDialog.ShowDialog() -ne $true) {
                return
            }

            $jsonRaw = Get-Content -Path $openFileDialog.FileName -Raw
        }

        # =========================
        # Parse JSON
        # =========================
        $FileContent = $jsonRaw | ConvertFrom-Json -ErrorAction Stop

        if ($FileContent.ListView -ne $itt.currentList) {
            Message -NoneKey "PLEASE SELECT THE CORRECT TAB" -icon "Warning" -action "OK"
            return
        }

        $collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView(
            $itt.($itt.currentList).Items
        )

        $collectionView.Filter = {
            param($item)

            if ($FileContent.Items.Name -contains $item.Content) {
                $item.IsChecked = $true
                return $true
            }
            return $false
        }

    }
    catch {
        Message -NoneKey "Failed to load ITT source" -icon "Error" -action "OK"
        Write-Warning $_
    }
}

# Save selected items to a JSON file
function Save-File {

    if($itt.currentList -eq "SettingsList") {return}

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
        Message -NoneKey "Saved $($saveFileDialog.FileName)" -icon "Information" -action "OK"
        Write-Host "Saved: $($saveFileDialog.FileName)"
    }

    # Uncheck checkboxes if user canceled
    Show-Selected -ListView "$($itt.currentList)" -Mode "Default"
}