function UpdateUI {
    
    <#
        .SYNOPSIS
        Update button's content width, text.
    #>

    param([string]$Name,[string]$Content,[string]$NonKey,[string]$Width = "140")

    $itt['window'].Dispatcher.Invoke([Action]{
        $itt.$Name.Width = $Width

        if($Content)
        {
            $itt.$Name.Content = $itt.database.locales.Controls.$($itt.Language).$Content
        }else{
            $itt.$Name.Text = $NonKey
        }
    })
}