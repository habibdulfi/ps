# Modern Interactive Windows Setup Script with Winget & Chocolatey Selection

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Define the XAML for the UI
[xml]$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Software Installer" Height="350" Width="500" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Select a Package Manager:" HorizontalAlignment="Left" Margin="20,20,0,0" VerticalAlignment="Top" FontSize="16"/>
        <RadioButton x:Name="WingetRadio" Content="Winget" HorizontalAlignment="Left" Margin="20,60,0,0" VerticalAlignment="Top" FontSize="14"/>
        <RadioButton x:Name="ChocoRadio" Content="Chocolatey" HorizontalAlignment="Left" Margin="20,90,0,0" VerticalAlignment="Top" FontSize="14"/>
        <Label Content="Select Software to Install:" HorizontalAlignment="Left" Margin="20,130,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="ChromeCheck" Content="Google Chrome" HorizontalAlignment="Left" Margin="20,160,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="VSCodeCheck" Content="Visual Studio Code" HorizontalAlignment="Left" Margin="20,190,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="SevenZipCheck" Content="7-Zip" HorizontalAlignment="Left" Margin="20,220,0,0" VerticalAlignment="Top" FontSize="14"/>
        <Button x:Name="InstallButton" Content="Install" HorizontalAlignment="Center" Margin="0,270,0,0" VerticalAlignment="Top" Width="100" Height="30" FontSize="14"/>
    </Grid>
</Window>
"@

# Load the XAML
$Reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Window = [Windows.Markup.XamlReader]::Load($Reader)

# Connect to UI elements
$WingetRadio = $Window.FindName("WingetRadio")
$ChocoRadio = $Window.FindName("ChocoRadio")
$ChromeCheck = $Window.FindName("ChromeCheck")
$VSCodeCheck = $Window.FindName("VSCodeCheck")
$SevenZipCheck = $Window.FindName("SevenZipCheck")
$InstallButton = $Window.FindName("InstallButton")

# Define button click event
$InstallButton.Add_Click({
    # Determine selected package manager
    if ($WingetRadio.IsChecked) {
        $PackageManager = "winget"
    } elseif ($ChocoRadio.IsChecked) {
        $PackageManager = "choco"
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a package manager!", "Error")
        return
    }

    # Install selected software
    if ($ChromeCheck.IsChecked) {
        if ($PackageManager -eq "winget") {
            Start-Process -NoNewWindow -FilePath "winget" -ArgumentList "install --id=Google.Chrome -e -h"
        } else {
            Start-Process -NoNewWindow -FilePath "choco" -ArgumentList "install googlechrome -y"
        }
    }
    if ($VSCodeCheck.IsChecked) {
        if ($PackageManager -eq "winget") {
            Start-Process -NoNewWindow -FilePath "winget" -ArgumentList "install --id=Microsoft.VisualStudioCode -e -h"
        } else {
            Start-Process -NoNewWindow -FilePath "choco" -ArgumentList "install vscode -y"
        }
    }
    if ($SevenZipCheck.IsChecked) {
        if ($PackageManager -eq "winget") {
            Start-Process -NoNewWindow -FilePath "winget" -ArgumentList "install --id=7zip.7zip -e -h"
        } else {
            Start-Process -NoNewWindow -FilePath "choco" -ArgumentList "install 7zip -y"
        }
    }

    [System.Windows.Forms.MessageBox]::Show("Installation complete!", "Success")
})

# Show the window
$Window.ShowDialog() | Out-Null
