function FeedbackWindow {
   
    # ------------------- Create Window -------------------
    $workerURL = "https://itt.emadadel4-a0a.workers.dev/feedback"
    $window = New-Object System.Windows.Window
    $window.Resources.MergedDictionaries.Add($itt["window"].Resources)
    $window.Background = $window.Resources["PrimaryBackgroundColor"]
    $window.Title = "Send Feedback"
    $window.Icon = $itt.Icon
    $window.Height = 434
    $window.Width = 480
    $window.WindowStartupLocation = "CenterScreen"
    $window.ResizeMode = "NoResize"

    # ------------------- Create Grid -------------------
    $grid = New-Object System.Windows.Controls.Grid
    $grid.Margin = [System.Windows.Thickness]::new(10)

    # Row definitions
    $row0 = New-Object System.Windows.Controls.RowDefinition; $row0.Height = "Auto"
    $row1 = New-Object System.Windows.Controls.RowDefinition; $row1.Height = "Auto"
    $row2 = New-Object System.Windows.Controls.RowDefinition; $row2.Height = "Auto"
    $row3 = New-Object System.Windows.Controls.RowDefinition; $row3.Height = "Auto"
    $row4 = New-Object System.Windows.Controls.RowDefinition; $row4.Height = "Auto"
    $row5 = New-Object System.Windows.Controls.RowDefinition; $row5.Height = "*"
    $row6 = New-Object System.Windows.Controls.RowDefinition; $row6.Height = "Auto"

    $grid.RowDefinitions.Add($row0)
    $grid.RowDefinitions.Add($row1)
    $grid.RowDefinitions.Add($row2)
    $grid.RowDefinitions.Add($row3)
    $grid.RowDefinitions.Add($row4)
    $grid.RowDefinitions.Add($row5)
    $grid.RowDefinitions.Add($row6)

    # ------------------- Dropdown Label -------------------
    $typeLabel = New-Object System.Windows.Controls.Label
    $typeLabel.Content = "Feedback:"
    $typeLabel.FontSize = 14
    [System.Windows.Controls.Grid]::SetRow($typeLabel,0)
    $grid.Children.Add($typeLabel)

    # ------------------- Dropdown ComboBox -------------------
    $typeBox = New-Object System.Windows.Controls.ComboBox
    $typeBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
    $typeBox.Items.Add("Improvement")
    $typeBox.Items.Add("Bug / Issue")
    $typeBox.Items.Add("Feature Request")
    $typeBox.Items.Add("Other")
    $typeBox.SelectedIndex = 0
    [System.Windows.Controls.Grid]::SetRow($typeBox,1)
    $grid.Children.Add($typeBox)

    # ------------------- Subject Label -------------------
    $subjectLabel = New-Object System.Windows.Controls.Label
    $subjectLabel.Content = "Subject:"
    $subjectLabel.FontSize = 14
    [System.Windows.Controls.Grid]::SetRow($subjectLabel,2)
    $grid.Children.Add($subjectLabel)

    # ------------------- Subject TextBox -------------------
    $subjectBox = New-Object System.Windows.Controls.TextBox
    $subjectBox.Height = 30
    $subjectBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
    [System.Windows.Controls.Grid]::SetRow($subjectBox,3)
    $grid.Children.Add($subjectBox)

    # ------------------- Message Label -------------------
    $msgLabel = New-Object System.Windows.Controls.Label
    $msgLabel.Content = "Message:"
    $msgLabel.FontSize = 14
    [System.Windows.Controls.Grid]::SetRow($msgLabel,4)
    $grid.Children.Add($msgLabel)

    # ------------------- Message TextBox -------------------
    $msgBox = New-Object System.Windows.Controls.TextBox
    $msgBox.Height = 120
    $msgBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
    $msgBox.AcceptsReturn = $true
    $msgBox.TextWrapping = "Wrap"
    [System.Windows.Controls.Grid]::SetRow($msgBox,5)
    $grid.Children.Add($msgBox)

    # ------------------- Send Button -------------------
    $sendButton = New-Object System.Windows.Controls.Button
    $sendButton.Content = "Send"
    $sendButton.Height = 35
    $sendButton.Width = 100
    $sendButton.HorizontalAlignment = "Center"
    $sendButton.Margin = [System.Windows.Thickness]::new(0,10,0,0)
    [System.Windows.Controls.Grid]::SetRow($sendButton,6)
    $grid.Children.Add($sendButton)

    $window.Content = $grid

    # ------------------- Button Click Event -------------------
    $sendButton.Add_Click({
        $type = $typeBox.SelectedItem
        $subject = $subjectBox.Text.Trim()
        $msg  = $msgBox.Text.Trim()

        if (-not $subject -or -not $msg) {
            [System.Windows.MessageBox]::Show("Please fill in all fields.","Warning")
            return
        }

        if ($msg.Length -gt 100) {
            [System.Windows.MessageBox]::Show("Message too long. Maximum 50 characters allowed.","Warning")
            return
        }

        try {
            $jsonBody = @{
                type = $type
                subject = $subject
                text = $msg
            } | ConvertTo-Json

            $response = Invoke-RestMethod -Uri $workerURL -Method Post -Body $jsonBody -ContentType "application/json"

            [System.Windows.MessageBox]::Show("Feedback sent successfully!`n$response","Success")

            $subjectBox.Clear()
            $msgBox.Clear()
            $typeBox.SelectedIndex = 0
        }
        catch {
            [System.Windows.MessageBox]::Show("Failed to send feedback.`n$_","Error")
        }
    })

    # ------------------- Show Window -------------------
    $window.ShowDialog() | Out-Null
}