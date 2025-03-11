# Load WPF assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Define the XAML for the Main Menu
[xml]$MainMenuXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="System Toolkit" Height="450" Width="650" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Welcome to System Toolkit" HorizontalAlignment="Center" Margin="0,20,0,0" VerticalAlignment="Top" FontSize="20" FontWeight="Bold"/>
        <Button x:Name="SoftwareInstallButton" Content="Software Installation" HorizontalAlignment="Center" Margin="0,80,0,0" VerticalAlignment="Top" Width="200" Height="40" FontSize="14"/>
        <Button x:Name="TweaksButton" Content="Tweaks" HorizontalAlignment="Center" Margin="0,130,0,0" VerticalAlignment="Top" Width="200" Height="40" FontSize="14"/>
        <Button x:Name="OptimizationButton" Content="System Optimization" HorizontalAlignment="Center" Margin="0,180,0,0" VerticalAlignment="Top" Width="200" Height="40" FontSize="14"/>
        <Button x:Name="ConfigButton" Content="Configuration" HorizontalAlignment="Center" Margin="0,230,0,0" VerticalAlignment="Top" Width="200" Height="40" FontSize="14"/>
        <Button x:Name="ExitButton" Content="Exit" HorizontalAlignment="Center" Margin="0,280,0,0" VerticalAlignment="Top" Width="100" Height="30" FontSize="14"/>
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

# Function to run backend tasks and display output
function Invoke-BackendTask {
    param (
        [ScriptBlock]$ScriptBlock
    )
    # Start a job to run the task
    $job = Start-ThreadJob -ScriptBlock $ScriptBlock

    # Monitor the job and display output in real-time
    while ($job.State -eq "Running") {
        Receive-Job -Job $job | ForEach-Object {
            Write-Host $_
        }
        Start-Sleep -Milliseconds 100
    }

    # Get final output
    Receive-Job -Job $job | ForEach-Object {
        Write-Host $_
    }

    # Clean up the job (forcefully remove it if it's still running)
    Remove-Job -Job $job -Force
}

# Define Software Installation Submenu
$SoftwareInstallButton.Add_Click({
    # Define the XAML for the Software Installation Submenu
    [xml]$SoftwareXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Software Installation" Height="500" Width="700" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Select a Package Manager:" HorizontalAlignment="Left" Margin="20,20,0,0" VerticalAlignment="Top" FontSize="16"/>
        <RadioButton x:Name="WingetRadio" Content="Winget" HorizontalAlignment="Left" Margin="20,60,0,0" VerticalAlignment="Top" FontSize="14"/>
        <RadioButton x:Name="ChocoRadio" Content="Chocolatey" HorizontalAlignment="Left" Margin="20,90,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Browsers:" HorizontalAlignment="Left" Margin="20,130,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="ChromeCheck" Content="Google Chrome" HorizontalAlignment="Left" Margin="20,160,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="FirefoxCheck" Content="Mozilla Firefox" HorizontalAlignment="Left" Margin="20,190,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="EdgeCheck" Content="Microsoft Edge" HorizontalAlignment="Left" Margin="20,220,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Communication:" HorizontalAlignment="Left" Margin="20,260,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="ZoomCheck" Content="Zoom" HorizontalAlignment="Left" Margin="20,290,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="SlackCheck" Content="Slack" HorizontalAlignment="Left" Margin="20,320,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="TeamsCheck" Content="Microsoft Teams" HorizontalAlignment="Left" Margin="20,350,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Utilities:" HorizontalAlignment="Left" Margin="350,130,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="SevenZipCheck" Content="7-Zip" HorizontalAlignment="Left" Margin="350,160,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="WinRARCheck" Content="WinRAR" HorizontalAlignment="Left" Margin="350,190,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="NotepadPlusCheck" Content="Notepad++" HorizontalAlignment="Left" Margin="350,220,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Label Content="Development Tools:" HorizontalAlignment="Left" Margin="350,260,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="VSCodeCheck" Content="Visual Studio Code" HorizontalAlignment="Left" Margin="350,290,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="GitCheck" Content="Git" HorizontalAlignment="Left" Margin="350,320,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="DockerCheck" Content="Docker" HorizontalAlignment="Left" Margin="350,350,0,0" VerticalAlignment="Top" FontSize="14"/>
        
        <Button x:Name="InstallButton" Content="Install" HorizontalAlignment="Center" Margin="0,400,0,0" VerticalAlignment="Top" Width="100" Height="30" FontSize="14"/>
    </Grid>
</Window>
"@

    # Load the Software Installation Submenu XAML
    $SoftwareReader = (New-Object System.Xml.XmlNodeReader $SoftwareXAML)
    $SoftwareWindow = [Windows.Markup.XamlReader]::Load($SoftwareReader)

    # Connect to Software Installation Submenu UI elements
    $WingetRadio = $SoftwareWindow.FindName("WingetRadio")
    $ChocoRadio = $SoftwareWindow.FindName("ChocoRadio")
    $ChromeCheck = $SoftwareWindow.FindName("ChromeCheck")
    $FirefoxCheck = $SoftwareWindow.FindName("FirefoxCheck")
    $EdgeCheck = $SoftwareWindow.FindName("EdgeCheck")
    $ZoomCheck = $SoftwareWindow.FindName("ZoomCheck")
    $SlackCheck = $SoftwareWindow.FindName("SlackCheck")
    $TeamsCheck = $SoftwareWindow.FindName("TeamsCheck")
    $SevenZipCheck = $SoftwareWindow.FindName("SevenZipCheck")
    $WinRARCheck = $SoftwareWindow.FindName("WinRARCheck")
    $NotepadPlusCheck = $SoftwareWindow.FindName("NotepadPlusCheck")
    $VSCodeCheck = $SoftwareWindow.FindName("VSCodeCheck")
    $GitCheck = $SoftwareWindow.FindName("GitCheck")
    $DockerCheck = $SoftwareWindow.FindName("DockerCheck")
    $InstallButton = $SoftwareWindow.FindName("InstallButton")

    # Define Install Button Click Event
    $InstallButton.Add_Click({
        if ($WingetRadio.IsChecked) {
            $PackageManager = "winget"
        } elseif ($ChocoRadio.IsChecked) {
            $PackageManager = "choco"
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a package manager!", "Error")
            return
        }

        # Define the script block for installation
        $ScriptBlock = {
            param ($PackageManager, $Selections)
            foreach ($item in $Selections.GetEnumerator()) {
                if ($item.Value) {
                    Write-Host "Installing $($item.Key) using $PackageManager..."
                    if ($PackageManager -eq "winget") {
                        winget install $item.Key
                    } else {
                        choco install $item.Key -y
                    }
                }
            }
            Write-Host "Installation complete!"
        }

        # Prepare selections
        $Selections = @{
            "Google.Chrome" = $ChromeCheck.IsChecked
            "Mozilla.Firefox" = $FirefoxCheck.IsChecked
            "Microsoft.Edge" = $EdgeCheck.IsChecked
            "Zoom.Zoom" = $ZoomCheck.IsChecked
            "SlackTechnologies.Slack" = $SlackCheck.IsChecked
            "Microsoft.Teams" = $TeamsCheck.IsChecked
            "7zip.7zip" = $SevenZipCheck.IsChecked
            "RARLab.WinRAR" = $WinRARCheck.IsChecked
            "Notepad++.Notepad++" = $NotepadPlusCheck.IsChecked
            "Microsoft.VisualStudioCode" = $VSCodeCheck.IsChecked
            "Git.Git" = $GitCheck.IsChecked
            "Docker.DockerDesktop" = $DockerCheck.IsChecked
        }

        # Run the installation task in the background
        Invoke-BackendTask -ScriptBlock $ScriptBlock -ArgumentList $PackageManager, $Selections
    })

    # Show the Software Installation Submenu
    $SoftwareWindow.ShowDialog() | Out-Null
})

# Define Tweaks Submenu
$TweaksButton.Add_Click({
    # Define the XAML for the Tweaks Submenu
    [xml]$TweaksXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Tweaks" Height="400" Width="600" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <Label Content="Select Tweaks to Apply:" HorizontalAlignment="Left" Margin="20,20,0,0" VerticalAlignment="Top" FontSize="16"/>
        <CheckBox x:Name="DisableCortanaCheck" Content="Disable Cortana" HorizontalAlignment="Left" Margin="20,60,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="DisableTelemetryCheck" Content="Disable Telemetry" HorizontalAlignment="Left" Margin="20,90,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="EnableDarkModeCheck" Content="Enable Dark Mode" HorizontalAlignment="Left" Margin="20,120,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="DisableDefenderCheck" Content="Disable Windows Defender" HorizontalAlignment="Left" Margin="20,150,0,0" VerticalAlignment="Top" FontSize="14"/>
        <CheckBox x:Name="DisableBingSearchCheck" Content="Disable Bing Search in Start Menu" HorizontalAlignment="Left" Margin="20,180,0,0" VerticalAlignment="Top" FontSize="14"/>
        <Button x:Name="ApplyTweaksButton" Content="Apply" HorizontalAlignment="Center" Margin="0,270,0,0" VerticalAlignment="Top" Width="100" Height="30" FontSize="14"/>
    </Grid>
</Window>
"@

    # Load the Tweaks Submenu XAML
    $TweaksReader = (New-Object System.Xml.XmlNodeReader $TweaksXAML)
    $TweaksWindow = [Windows.Markup.XamlReader]::Load($TweaksReader)

    # Connect to Tweaks Submenu UI elements
    $DisableCortanaCheck = $TweaksWindow.FindName("DisableCortanaCheck")
    $DisableTelemetryCheck = $TweaksWindow.FindName("DisableTelemetryCheck")
    $EnableDarkModeCheck = $TweaksWindow.FindName("EnableDarkModeCheck")
    $DisableDefenderCheck = $TweaksWindow.FindName("DisableDefenderCheck")
    $DisableBingSearchCheck = $TweaksWindow.FindName("DisableBingSearchCheck")
    $ApplyTweaksButton = $TweaksWindow.FindName("ApplyTweaksButton")

    # Define Apply Button Click Event
    $ApplyTweaksButton.Add_Click({
        if ($DisableCortanaCheck.IsChecked) {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
            Write-Host "Cortana disabled."
        }
        if ($DisableTelemetryCheck.IsChecked) {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
            Write-Host "Telemetry disabled."
        }
        if ($EnableDarkModeCheck.IsChecked) {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
            Write-Host "Dark mode enabled."
        }
        if ($DisableDefenderCheck.IsChecked) {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
            Write-Host "Windows Defender disabled."
        }
        if ($DisableBingSearchCheck.IsChecked) {
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
            Write-Host "Bing search in Start Menu disabled."
        }

        [System.Windows.Forms.MessageBox]::Show("Tweaks applied successfully!", "Success")
    })

    # Show the Tweaks Submenu
    $TweaksWindow.ShowDialog() | Out-Null
})

# Define Exit Button Click Event
$ExitButton.Add_Click({
    $MainMenuWindow.Close()
})

# Show the Main Menu
$MainMenuWindow.ShowDialog() | Out-Null
