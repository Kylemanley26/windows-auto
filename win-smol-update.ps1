#smol update
#installs windows updates aside from feature updates
# Check if NuGet provider is installed
if (-not(Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
    # Install NuGet provider
    Install-PackageProvider -Name NuGet -Force
}

# Check if the module is already installed
if (-not(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    # Install the module
    Install-Module PSWindowsUpdate -Force
}

# Import the module
Import-Module PSWindowsUpdate

# Get and install updates
Get-WindowsUpdate
Install-WindowsUpdate -NotCategory "Drivers" -AcceptAll -AutoReboot:$false
