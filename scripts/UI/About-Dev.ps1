function About {
    $aboutPopup = $itt['window'].FindName('AboutPopup')
    $aboutPopup.FindName('ver').Text = "Version $($itt.version)"
    $aboutPopup.IsOpen = $true
}