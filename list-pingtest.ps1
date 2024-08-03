# Required imports for the script
Import-Module Microsoft.PowerShell.Utility

# Define the IP list with descriptions
$ipList = @(
    @{IP = "8.8.8.8"; Description = "Google DNS"},
    @{IP = "1.1.1.1"; Description = "Cloudflare DNS"},
    @{IP = "192.168.1.1"; Description = "Local Router"}
)

# Function to perform ping test
function Test-Ping {
    param (
        [string]$IP,
        [string]$Description
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $pingResult = Test-Connection -ComputerName $IP -Count 1 -ErrorAction SilentlyContinue

    if ($pingResult) {
        $pingTime = $pingResult.ResponseTime
        Write-Host "$timestamp - $Description ($IP) - Ping Success: $pingTime ms"
    } else {
        Write-Host "$timestamp - $Description ($IP) - Ping Failed"
    }
}

# Iterate through the IP list and perform the ping test
foreach ($entry in $ipList) {
    Test-Ping -IP $entry.IP -Description $entry.Description
}
