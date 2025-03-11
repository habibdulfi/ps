# Interactive Windows Setup Script with UI and Package Selection

Add-Type -AssemblyName System.Windows.Forms

# Create the Main Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Windows Setup & Tweaks"
$Form.Size = New-Object System.Drawing.Size(500,400)
$Form.StartPosition = "CenterScreen"

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Select an option to proceed:"
$Label.AutoSize = $true
$Label.Location = New-Object System.Drawing.Point(30,20)
$Form.Controls.Add($Label)

$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Items.Add("1. Select and Install Software")
$ListBox.Items.Add("2. Select and Apply Windows Tweaks")
$ListBox.Items.Add("3. Select and Apply System Optimization")
$ListBox.Items.Add("4. Exit")
$ListBox.Size = New-Object System.Drawing.Size(400,100)
$ListBox.Location = New-Object System.Drawing.Point(30,50)
$Form.Controls.Add($ListBox)

$Button = New-Object System.Windows.Forms.Button
$Button.Text = "Proceed"
$Button.Location = New-Object System.Drawing.Point(200,180)
$Button.Add_Click({ Process-Selection $ListBox.SelectedIndex })
$Form.Controls.Add($Button)

$Form.ShowDialog()

# Function to Process Selection
function Process-Selection {
    param ($Selection)
    switch ($Selection) {
        0 { Select-Package-Manager }
        1 { Show-Tweaks-UI }
        2 { Show-Optimizations-UI }
        3 { Exit }
        default { Write-Host "Invalid option! Please select again." }
    }
}

# Function to Select Package Manager
function Select-Package-Manager {
    $choice = [System.Windows.Forms.MessageBox]::Show("Do you want to use Winget instead of Chocolatey?", "Package Manager Selection", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        Show-Software-UI -PackageManager "winget"
    } else {
        Show-Software-UI -PackageManager "choco"
    }
}

# Function to Show Software Selection UI
function Show-Software-UI {
    param ($PackageManager)
    $SoftwareForm = New-Object System.Windows.Forms.Form
    $SoftwareForm.Text = "Select Software to Install"
    $SoftwareForm.Size = New-Object System.Drawing.Size(400,400)
    
    $SoftwareList = @{
        "Google Chrome" = "googlechrome"
        "VS Code" = "vscode"
        "7-Zip" = "7zip"
        "Notepad++" = "notepadplusplus"
        "Git" = "git"
        "Python" = "python"
        "VLC Media Player" = "vlc"
        "Spotify" = "spotify"
        "Zoom" = "zoom"
        "Brave Browser" = "brave"
    }
    
    $Checkboxes = @()
    $y = 20
    foreach ($key in $SoftwareList.Keys) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $key
        $cb.Location = New-Object System.Drawing.Point(20, $y)
        $SoftwareForm.Controls.Add($cb)
        $Checkboxes += $cb
        $y += 30
    }
    
    $InstallButton = New-Object System.Windows.Forms.Button
    $InstallButton.Text = "Install Selected Software"
    $InstallButton.Location = New-Object System.Drawing.Point(120, $y + 20)
    $InstallButton.Add_Click({
        foreach ($cb in $Checkboxes) {
            if ($cb.Checked) {
                & $PackageManager install $SoftwareList[$cb.Text] -y
            }
        }
        $SoftwareForm.Close()
    })
    $SoftwareForm.Controls.Add($InstallButton)
    
    $SoftwareForm.ShowDialog()
}

# Function to Show Windows Tweaks UI
function Show-Tweaks-UI {
    $TweaksForm = New-Object System.Windows.Forms.Form
    $TweaksForm.Text = "Select Windows Tweaks"
    $TweaksForm.Size = New-Object System.Drawing.Size(400,300)
    
    $TweakOptions = @{
        "Disable OneDrive" = "reg add \"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive\" /v \"DisableFileSyncNGSC\" /t REG_DWORD /d 1 /f"
        "Disable Telemetry" = "reg add \"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection\" /v AllowTelemetry /t REG_DWORD /d 0 /f"
        "Enable Dark Mode" = "reg add \"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\" /v AppsUseLightTheme /t REG_DWORD /d 0 /f"
    }
    
    $Checkboxes = @()
    $y = 20
    foreach ($key in $TweakOptions.Keys) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $key
        $cb.Location = New-Object System.Drawing.Point(20, $y)
        $TweaksForm.Controls.Add($cb)
        $Checkboxes += $cb
        $y += 30
    }
    
    $ApplyButton = New-Object System.Windows.Forms.Button
    $ApplyButton.Text = "Apply Selected Tweaks"
    $ApplyButton.Location = New-Object System.Drawing.Point(120, $y + 20)
    $ApplyButton.Add_Click({
        foreach ($cb in $Checkboxes) {
            if ($cb.Checked) {
                Invoke-Expression $TweakOptions[$cb.Text]
            }
        }
        $TweaksForm.Close()
    })
    $TweaksForm.Controls.Add($ApplyButton)
    
    $TweaksForm.ShowDialog()
}

# Function to Show System Optimizations UI
function Show-Optimizations-UI {
    $OptForm = New-Object System.Windows.Forms.Form
    $OptForm.Text = "Select System Optimizations"
    $OptForm.Size = New-Object System.Drawing.Size(400,300)
    
    $OptOptions = @{
        "Disable Hibernation" = "powercfg -h off"
        "Speed up Boot Time" = "bcdedit /set disabledynamictick yes"
    }
    
    $Checkboxes = @()
    $y = 20
    foreach ($key in $OptOptions.Keys) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $key
        $cb.Location = New-Object System.Drawing.Point(20, $y)
        $OptForm.Controls.Add($cb)
        $Checkboxes += $cb
        $y += 30
    }
    
    $ApplyButton = New-Object System.Windows.Forms.Button
    $ApplyButton.Text = "Apply Selected Optimizations"
    $ApplyButton.Location = New-Object System.Drawing.Point(120, $y + 20)
    $ApplyButton.Add_Click({
        foreach ($cb in $Checkboxes) {
            if ($cb.Checked) {
                Invoke-Expression $OptOptions[$cb.Text]
            }
        }
        $OptForm.Close()
    })
    $OptForm.Controls.Add($ApplyButton)
    
    $OptForm.ShowDialog()
}
