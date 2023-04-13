Function IPReport { 

Write-Host "Network Adapters" -ForegroundColor Red 
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled | format-table Description, Index, Ipaddress, Ipsubnet, Dnsdomain
} 