[CmdletBinding()]
Param(
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

Import-Module Module200494890

if (!$System -and !$Disks -and !$Network) {
    Write-Host "Full System Report:" -ForegroundColor Red
    CPUInfo
    OSInfo
    RAMInfo
    GPUInfo
    DiskInfo
    IPReport
}
else {
    if ($System) {
        Write-Host "System Information:" -ForegroundColor Red
        CPUInfo
        OSInfo
        RAMInfo
        GPUInfo
    }

    if ($Disks) {
        Write-Host "Disk Information:" -ForegroundColor Red
        DiskInfo
    }

    if ($Network) {
        Write-Host "Network Information:" -ForegroundColor Red
        IPReport
    }
}
