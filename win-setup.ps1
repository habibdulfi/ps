# Interactive Windows Setup Script with UI and Package Selection

Add-Type -AssemblyName System.Windows.Forms
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
        1 { Apply-Tweaks }
        2 { Optimize-System }
        3 { Exit }
        default { Write-Host "Invalid option! Please select again." }
    }
}

# Function to Select Package Manager
function Select-Package-Manager {
    $choice = [System.Windows.Forms.MessageBox]::Show("Do you want to use Winget instead of Chocolatey?", "Package Manager Selection", 4)
    if ($choice -eq "Yes") {
        Install-Software -PackageManager "winget"
    } else {
        Install-Software -PackageManager "choco"
    }
}

# Function to Select and Install Software
function Install-Software {
    param ($PackageManager)
    
    $softwareList = @{ 
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
    
    $selectedSoftware = [System.Windows.Forms.MessageBox]::Show("Do you want to install all software?", "Software Installation", 4)
    
    if ($PackageManager -eq "choco" -and -Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    if ($selectedSoftware -eq "Yes") {
        foreach ($software in $softwareList.Values) {
            & $PackageManager install $software -y
        }
    }
    Write-Host "Software installation completed!"
}

# Function to Select and Apply Windows Tweaks
function Apply-Tweaks {
    Write-Host "Applying Windows Tweaks..."
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    Write-Host "Tweaks Applied Successfully!"
}

# Function to Select and Apply System Optimization
function Optimize-System {
    Write-Host "Optimizing System Performance..."
    powercfg -h off  # Disables hibernation
    bcdedit /set disabledynamictick yes
    Write-Host "System Optimization Completed!"
}
