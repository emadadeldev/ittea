function About {
    $aboutPopup = $itt['window'].FindName('AboutPopup')
    $aboutPopup.FindName('ver').Text = "Version $($itt.version) $($itt.api.message)"
    $aboutPopup.IsOpen = $true
}