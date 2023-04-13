
# Operating System name and version number 
function OSInfo {
    Write-Host "Operating System Information:" -ForegroundColor Red
    $os = Get-WmiObject win32_operatingsystem
    if ($os) {
        [PSCustomObject]@{
            "Caption" = $os.Caption
            "Version" = $os.Version
        } | Format-List "Caption", "Version"
    } else {
        Write-Host "Data unavailable"
    }
}


# CPU Information 
function CPUInfo {

Write-Host "Processor Information:" -ForegroundColor Red
$processor = Get-WmiObject -Class win32_processor | Select -First 1

New-Object -TypeName psobject -Property @{
    "Description" = $processor.Description
    "Speed(MHz)" = $processor.CurrentClockSpeed
    "Cores" = $processor.NumberOfCores
    "L1 Cache Size" = "$($_.L1CacheSize / 1KB) KB"
    "L2 Cache Size" = "$($_.L2CacheSize / 1MB) MB"
    "L3 Cache Size" = "$($_.L3CacheSize / 1MB) MB"
} | Format-List "Description", "Speed(MHz)", "Cores", "L1Size", "L2Size", "L3Size"
  }


# RAM Information 
function RAMInfo {
    Write-Host "RAM" -ForegroundColor Red
    $totalCapacity = 0
    $ram = Get-WmiObject -Class win32_physicalmemory
    if ($ram) {
        $ramInfo = $ram | ForEach-Object {
            $manufacturer = $_.Manufacturer
            $speed = "$($_.Speed/1000000) MHz"
            $size = "$($_.Capacity/1GB) GB"
            $bank = $_.BankLabel
            $slot = $_.DeviceLocator
            $totalCapacity += $_.Capacity
            [PSCustomObject]@{
                "Manufacturer" = $manufacturer
                "Speed" = $speed
                "Size" = $size
                "Bank" = $bank
                "Slot" = $slot
            }
        } | Format-Table -AutoSize "Manufacturer", "Size", "Speed", "Bank", "Slot" | Out-Host
        Write-Host "Total RAM: $($totalCapacity/1GB) GB"
        $ramInfo
    } else {
        Write-Host "Data unavailable"
    }
}


#Get Disk summary  

Function DiskInfo { 

Write-Host "Physical Disk Drives" -ForegroundColor Red

$diskdrives = Get-CIMInstance CIM_diskdrive 

  

    foreach ($disk in $diskdrives) { 

          $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition 

          foreach ($partition in $partitions) { 

                $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk 

                foreach ($logicaldisk in $logicaldisks) { 

                         new-object -typename psobject -property @{
                     
                         Manufacturer=$disk.Manufacturer 

                         Location=$partition.deviceid 

                         Drive=$logicaldisk.deviceid 

                         "Size(GB)"=$logicaldisk.size / 1gb -as [int] 

                      } | Out-Host

               } 

          } 

      } 

} 


# IP configuration report 
Function IPReport { 

Write-Host "Network Adapters" -ForegroundColor Red 
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | format-table Description, Index, Ipaddress, Ipsubnet, Dnsdomain
} 


function GPUInfo {

Write-Host "VideoCard:" -ForegroundColor Red
    $videoControllers = Get-CimInstance Win32_VideoController

    if ($videoControllers -ne $null) {
        $videoInfo = [PSCustomObject] @{
            "Vendor" = $videoControllers.VideoProcessor
            "Description" = $videoControllers.Description
            "Screen Resolution" = $videoControllers.CurrentHorizontalResolution.ToString() + " x " + $videoControllers.CurrentVerticalResolution.ToString()
        }
        return $videoInfo | Format-List *
    } else {
        Write-Warning "No video controllers found."
        return $null
    }
}

function Get-Systemreport{

OSInfo
CPUInfo
RAMInfo 
DiskInfo 
IPReport
GPUInfo

}