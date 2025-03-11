# Interactive Windows Setup Script

# Function to Display Menu
function Show-Menu {
    Clear-Host
    Write-Host "==================================="
    Write-Host "  Windows Custom Setup & Tweaks  "
    Write-Host "==================================="
    Write-Host "1. Install Essential Software"
    Write-Host "2. Apply Windows Tweaks"
    Write-Host "3. Optimize System Performance"
    Write-Host "4. Exit"
}

# Function to Install Software
function Install-Software {
    Write-Host "Installing Essential Software..."
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    $softwareList = @("googlechrome", "vscode", "7zip", "notepadplusplus", "git", "python", "spotify", "vlc")
    foreach ($software in $softwareList) {
        choco install $software -y
    }
    Write-Host "Software installation completed!"
}

# Function to Apply Windows Tweaks
function Apply-Tweaks {
    Write-Host "Applying Windows Tweaks..."
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
    Write-Host "Tweaks Applied Successfully!"
}

# Function to Optimize System
function Optimize-System {
    Write-Host "Optimizing System Performance..."
    powercfg -h off  # Disables hibernation
    bcdedit /set disabledynamictick yes
    Write-Host "System Optimization Completed!"
}

# Main Execution Loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-4)"
    switch ($choice) {
        "1" { Install-Software }
        "2" { Apply-Tweaks }
        "3" { Optimize-System }
        "4" { Write-Host "Exiting..."; break }
        default { Write-Host "Invalid option! Please select again." }
    }
    Read-Host "Press Enter to continue..."
}
  
