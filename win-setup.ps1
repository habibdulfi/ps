# Modern System Toolkit with Software Installation, Tweaks, Optimization & Configuration

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Define the XAML for the Main Menu
[xml]$MainMenuXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="System Toolkit" Height="650" Width="750" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Welcome to System Toolkit" HorizontalAlignment="Center" Margin="0,20,0,0" VerticalAlignment="Top" FontSize="22" FontWeight="Bold"/>
        <Button x:Name="SoftwareInstallButton" Content="Software Installation" HorizontalAlignment="Center" Margin="0,80,0,0" VerticalAlignment="Top" Width="350" Height="40" FontSize="14"/>
        <Button x:Name="TweaksButton" Content="System Tweaks" HorizontalAlignment="Center" Margin="0,130,0,0" VerticalAlignment="Top" Width="350" Height="40" FontSize="14"/>
        <Button x:Name="OptimizationButton" Content="System Optimization" HorizontalAlignment="Center" Margin="0,180,0,0" VerticalAlignment="Top" Width="350" Height="40" FontSize="14"/>
        <Button x:Name="ConfigButton" Content="System Configuration" HorizontalAlignment="Center" Margin="0,230,0,0" VerticalAlignment="Top" Width="350" Height="40" FontSize="14"/>
        <Button x:Name="ExitButton" Content="Exit" HorizontalAlignment="Center" Margin="0,280,0,0" VerticalAlignment="Top" Width="150" Height="30" FontSize="14"/>
    </Grid>
</Window>
"@

# Load the Main Menu XAML
$MainMenuReader = (New-Object System.Xml.XmlNodeReader $MainMenuXAML)
$MainMenuWindow = [Windows.Markup.XamlReader]::Load($MainMenuReader)

# Connect to Main Menu UI elements
$SoftwareInstallButton = $MainMenuWindow.FindName("SoftwareInstallButton")
$TweaksButton = $MainMenuWindow.FindName("TweaksButton")
$OptimizationButton = $MainMenuWindow.FindName("OptimizationButton")
$ConfigButton = $MainMenuWindow.FindName("ConfigButton")
$ExitButton = $MainMenuWindow.FindName("ExitButton")

# Define Software Installation Submenu
$SoftwareInstallButton.Add_Click({
    [xml]$SoftwareXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Software Installation" Height="650" Width="750" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Select a Package Manager:" HorizontalAlignment="Left" Margin="20,20,0,0" VerticalAlignment="Top" FontSize="16"/>
        <RadioButton x:Name="WingetRadio" Content="Winget" HorizontalAlignment="Left" Margin="20,50,0,0" VerticalAlignment="Top" FontSize="14"/>
        <RadioButton x:Name="ChocoRadio" Content="Chocolatey" HorizontalAlignment="Left" Margin="20,80,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Browsers:" HorizontalAlignment="Left" Margin="20,120,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="ChromeCheck" Content="Google Chrome" HorizontalAlignment="Left" Margin="20,150,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="FirefoxCheck" Content="Mozilla Firefox" HorizontalAlignment="Left" Margin="20,180,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Development Tools:" HorizontalAlignment="Left" Margin="300,120,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="GitCheck" Content="Git" HorizontalAlignment="Left" Margin="300,150,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="PythonCheck" Content="Python" HorizontalAlignment="Left" Margin="300,180,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Media Players:" HorizontalAlignment="Left" Margin="20,220,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="VLCCheck" Content="VLC Media Player" HorizontalAlignment="Left" Margin="20,250,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="SpotifyCheck" Content="Spotify" HorizontalAlignment="Left" Margin="20,280,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Utilities:" HorizontalAlignment="Left" Margin="300,220,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="VSCodeCheck" Content="Visual Studio Code" HorizontalAlignment="Left" Margin="300,250,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="SevenZipCheck" Content="7-Zip" HorizontalAlignment="Left" Margin="300,280,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Button x:Name="InstallButton" Content="Install" HorizontalAlignment="Center" Margin="0,350,0,0" VerticalAlignment="Top" Width="120" Height="40" FontSize="14"/>
    </Grid>
</Window>
"@

    # Load Software Installation Window
    $SoftwareReader = (New-Object System.Xml.XmlNodeReader $SoftwareXAML)
    $SoftwareWindow = [Windows.Markup.XamlReader]::Load($SoftwareReader)
    $SoftwareWindow.ShowDialog() | Out-Null
})

# Define Exit Button Click Event
$ExitButton.Add_Click({
    $MainMenuWindow.Close()
})

# Show the Main Menu
$MainMenuWindow.ShowDialog() | Out-Null
