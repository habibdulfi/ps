# Modern Interactive Windows Setup Script with MahApps.Metro UI

Add-Type -AssemblyName PresentationFramework

# Create the Main Window with Metro Theme
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Windows Setup & Tweaks" Height="500" Width="650" Background="#1E1E1E">
    <Grid>
        <StackPanel Orientation="Vertical" VerticalAlignment="Center" HorizontalAlignment="Center" Width="500">
            <TextBlock Text="Windows Setup & Tweaks" Foreground="White" FontSize="22" HorizontalAlignment="Center" Margin="0,10,0,20"/>
            
            <ListBox Name="ListBoxOptions" Foreground="Black" Background="White" Height="150" FontSize="14">
                <ListBoxItem Content="Select and Install Software"/>
                <ListBoxItem Content="Select and Apply Windows Tweaks"/>
                <ListBoxItem Content="Select and Apply System Optimization"/>
                <ListBoxItem Content="Exit"/>
            </ListBox>
            
            <Button Name="ProceedButton" Content="Proceed" Width="150" Height="45" Background="#0078D7" Foreground="White" FontSize="16" HorizontalAlignment="Center" Margin="0,20,0,0"/>
        </StackPanel>
    </Grid>
</Window>
"@

$Reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$XAML)
$Window = [Windows.Markup.XamlReader]::Load($Reader)
$ProceedButton = $Window.FindName("ProceedButton")
$ListBoxOptions = $Window.FindName("ListBoxOptions")

# Handle Button Click
$ProceedButton.Add_Click({
    $SelectedIndex = $ListBoxOptions.SelectedIndex
    switch ($SelectedIndex) {
        0 { Select-Package-Manager }
        1 { Show-Tweaks-UI }
        2 { Show-Optimizations-UI }
        3 { $Window.Close() }
    }
})

$Window.ShowDialog()

# Function to Select Package Manager
function Select-Package-Manager {
    $choice = [System.Windows.MessageBox]::Show("Do you want to use Winget instead of Chocolatey?", "Package Manager Selection", [System.Windows.MessageBoxButton]::YesNo)
    if ($choice -eq [System.Windows.MessageBoxResult]::Yes) {
        Show-Software-UI -PackageManager "winget"
    } else {
        Show-Software-UI -PackageManager "choco"
    }
}

# Function to Show Software Selection UI
function Show-Software-UI {
    param ($PackageManager)
    
    $SoftwareXAML = @"
<Window Title='Select Software' Height='450' Width='550' Background='#1E1E1E'>
    <Grid>
        <StackPanel VerticalAlignment='Center' HorizontalAlignment='Center' Width='500'>
            <TextBlock Text='Select Software to Install' Foreground='White' FontSize='18' HorizontalAlignment='Center' Margin='0,10,0,20'/>
            <ScrollViewer Height='250'>
                <StackPanel Name='SoftwarePanel' Background='#333' Padding='10'/>
            </ScrollViewer>
            <Button Name='InstallButton' Content='Install' Width='150' Height='40' Background='#0078D7' Foreground='White' FontSize='16' HorizontalAlignment='Center' Margin='0,20,0,0'/>
        </StackPanel>
    </Grid>
</Window>
"@
    
    $Reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$SoftwareXAML)
    $SoftwareWindow = [Windows.Markup.XamlReader]::Load($Reader)
    $SoftwarePanel = $SoftwareWindow.FindName("SoftwarePanel")
    $InstallButton = $SoftwareWindow.FindName("InstallButton")
    
    $SoftwareList = @{ "Google Chrome" = "googlechrome"; "VS Code" = "vscode"; "7-Zip" = "7zip"; "Notepad++" = "notepadplusplus"; "Git" = "git"; "Python" = "python"; "VLC Media Player" = "vlc"; "Spotify" = "spotify"; "Zoom" = "zoom"; "Brave Browser" = "brave" }
    
    $Checkboxes = @()
    foreach ($key in $SoftwareList.Keys) {
        $cb = New-Object Windows.Controls.CheckBox
        $cb.Content = $key
        $cb.Foreground = "White"
        $cb.FontSize = 14
        $cb.Margin = New-Object System.Windows.Thickness(5)
        $SoftwarePanel.Children.Add($cb)
        $Checkboxes += $cb
    }
    
    $InstallButton.Add_Click({
        foreach ($cb in $Checkboxes) {
            if ($cb.IsChecked) {
                & $PackageManager install $SoftwareList[$cb.Content] -y
            }
        }
        $SoftwareWindow.Close()
    })
    
    $SoftwareWindow.ShowDialog()
}

# Function to Show Tweaks UI
function Show-Tweaks-UI {
    [System.Windows.MessageBox]::Show("Applying Tweaks...", "Tweaks")
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
}

# Function to Show Optimizations UI
function Show-Optimizations-UI {
    [System.Windows.MessageBox]::Show("Applying System Optimizations...", "Optimizations")
    powercfg -h off
    bcdedit /set disabledynamictick yes
}
