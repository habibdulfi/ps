# Full System Toolkit with Software Installation, Tweaks, Optimization & Configuration

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Define Logging Function
$LogFile = "$env:USERPROFILE\SystemToolkit.log"
Function Log-Action {
    param ([string]$Message)
    "$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss")) - $Message" | Out-File -Append -FilePath $LogFile
}

# Define Function to View Logs with Filtering and Export Option
Function Show-LogWindow {
    [xml]$LogXAML = @"
<Window Title="System Toolkit Logs" Height="650" Width="850" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <ComboBox x:Name="LogFilter" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="200" Height="30" FontSize="14">
            <ComboBoxItem Content="All Logs"/>
            <ComboBoxItem Content="Software Installation"/>
            <ComboBoxItem Content="System Tweaks"/>
            <ComboBoxItem Content="System Optimization"/>
            <ComboBoxItem Content="Configuration"/>
        </ComboBox>
        <Button x:Name="FilterButton" Content="Filter" HorizontalAlignment="Left" Margin="220,10,0,0" VerticalAlignment="Top" Width="80" Height="30" FontSize="14"/>
        <Button x:Name="ExportLogsButton" Content="Export Logs" HorizontalAlignment="Left" Margin="310,10,0,0" VerticalAlignment="Top" Width="120" Height="30" FontSize="14"/>
        <TextBox x:Name="LogTextBox" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="10,50,10,10" FontSize="12" TextWrapping="Wrap" AcceptsReturn="True" IsReadOnly="True"/>
        <Button x:Name="CloseLogButton" Content="Close" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="10" Width="80" Height="30" FontSize="14"/>
    </Grid>
</Window>
"@
    $LogReader = (New-Object System.Xml.XmlNodeReader $LogXAML)
    $LogWindow = [Windows.Markup.XamlReader]::Load($LogReader)
    $LogTextBox = $LogWindow.FindName("LogTextBox")
    $LogFilter = $LogWindow.FindName("LogFilter")
    $FilterButton = $LogWindow.FindName("FilterButton")
    $ExportLogsButton = $LogWindow.FindName("ExportLogsButton")
    $CloseLogButton = $LogWindow.FindName("CloseLogButton")
    
    Function Update-LogView {
        if (Test-Path $LogFile) {
            $SelectedFilter = $LogFilter.SelectedItem.Content
            $Logs = Get-Content -Path $LogFile
            if ($SelectedFilter -ne "All Logs") {
                $Logs = $Logs | Where-Object { $_ -match $SelectedFilter }
            }
            $LogTextBox.Text = $Logs -join "`r`n"
        } else {
            $LogTextBox.Text = "No logs available."
        }
    }
    
    $FilterButton.Add_Click({ Update-LogView })
    $ExportLogsButton.Add_Click({ Copy-Item -Path $LogFile -Destination "$env:USERPROFILE\Desktop\SystemToolkit_Logs.txt"; [System.Windows.MessageBox]::Show("Logs exported to Desktop.", "Export Success") })
    $CloseLogButton.Add_Click({ $LogWindow.Close() })
    Update-LogView
    $LogWindow.ShowDialog() | Out-Null
}

# Define the XAML for the Main Menu with Animation
[xml]$MainMenuXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="System Toolkit" Height="750" Width="850" ResizeMode="NoResize" WindowStartupLocation="CenterScreen"
    Opacity="0">
    <Grid>
        <Label Content="Welcome to System Toolkit" HorizontalAlignment="Center" Margin="0,20,0,0" VerticalAlignment="Top" FontSize="24" FontWeight="Bold"/>
        <Button x:Name="SoftwareInstallButton" Content="Software Installation" HorizontalAlignment="Center" Margin="0,80,0,0" VerticalAlignment="Top" Width="400" Height="50" FontSize="16"/>
        <Button x:Name="TweaksButton" Content="System Tweaks" HorizontalAlignment="Center" Margin="0,140,0,0" VerticalAlignment="Top" Width="400" Height="50" FontSize="16"/>
        <Button x:Name="OptimizationButton" Content="System Optimization" HorizontalAlignment="Center" Margin="0,200,0,0" VerticalAlignment="Top" Width="400" Height="50" FontSize="16"/>
        <Button x:Name="ConfigButton" Content="System Configuration" HorizontalAlignment="Center" Margin="0,260,0,0" VerticalAlignment="Top" Width="400" Height="50" FontSize="16"/>
        <Button x:Name="ViewLogsButton" Content="View Logs" HorizontalAlignment="Center" Margin="0,320,0,0" VerticalAlignment="Top" Width="400" Height="50" FontSize="16"/>
        <Button x:Name="ExitButton" Content="Exit" HorizontalAlignment="Center" Margin="0,380,0,0" VerticalAlignment="Top" Width="150" Height="40" FontSize="14"/>
    </Grid>
</Window>
"@

# Load the Main Menu XAML
$MainMenuReader = (New-Object System.Xml.XmlNodeReader $MainMenuXAML)
$MainMenuWindow = [Windows.Markup.XamlReader]::Load($MainMenuReader)

# Apply Fade-in Animation
for ($i = 0; $i -le 1; $i += 0.1) {
    $MainMenuWindow.Opacity = $i
    Start-Sleep -Milliseconds 50
}

# Connect to Main Menu UI elements
$SoftwareInstallButton = $MainMenuWindow.FindName("SoftwareInstallButton")
$TweaksButton = $MainMenuWindow.FindName("TweaksButton")
$OptimizationButton = $MainMenuWindow.FindName("OptimizationButton")
$ConfigButton = $MainMenuWindow.FindName("ConfigButton")
$ViewLogsButton = $MainMenuWindow.FindName("ViewLogsButton")
$ExitButton = $MainMenuWindow.FindName("ExitButton")

# Define View Logs Button Action
$ViewLogsButton.Add_Click({
    Log-Action "Opened log viewer."
    Show-LogWindow
})

# Define Exit Button Click Event
$ExitButton.Add_Click({
    Log-Action "User exited the application."
    $MainMenuWindow.Close()
})

# Show the Main Menu
Log-Action "System Toolkit launched."
$MainMenuWindow.ShowDialog() | Out-Null
