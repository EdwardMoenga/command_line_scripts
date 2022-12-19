
<#PSScriptInfo
 
.VERSION 1.0
 
.GUID 47155737-e504-46ff-89dd-316c420d16ba
 
.AUTHOR jdolsen
 
.COMPANYNAME
 
.COPYRIGHT
 
.TAGS
 
.LICENSEURI
 
.PROJECTURI
 
.ICONURI
 
.EXTERNALMODULEDEPENDENCIES
 
.REQUIREDSCRIPTS
 
.EXTERNALSCRIPTDEPENDENCIES
 
.RELEASENOTES
 
 
.PRIVATEDATA
 
#>

<#
 
.DESCRIPTION
Check computer information
 
#> 

Param()


function NetAdapter {
return Get-CimInstance win32_networkadapterconfiguration | where {$_.IPAddress -ne $null} | select MACAddress, IPAddress
}
$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
$config = NetAdapter
Clear-Host
Write-Host ""
Write-Host "___" -BackgroundColor DarkBlue -NoNewLine; Write-Host "___" -BackgroundColor DarkCyan -NoNewLine; Write-Host "___" -BackgroundColor DarkGreen -NoNewLine; Write-Host "___" -BackgroundColor DarkYellow -NoNewLine; Write-Host "___" -BackgroundColor DarkRed -NoNewLine; Write-Host "___" -BackgroundColor DarkMagenta;
Write-Host ""
Write-Host "System Information for: " $computerSystem.Name 
""
"Manufacturer: " + $computerSystem.Manufacturer
"Model: " + $computerSystem.Model
"Serial Number: " + $computerBIOS.SerialNumber
""
"CPU: " + $computerCPU.Name 
"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB" 
"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)" 
"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"  
"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion 
""
"User logged In: " + $computerSystem.UserName 
"Last Reboot: " + $computerOS.LastBootUpTime
write-host ""
write-host "MAC Address: " $config.MACAddress 
write-host "IP Address: " $config.IPAddress 
Write-Host ""
Write-Host "___" -BackgroundColor DarkBlue -NoNewLine; Write-Host "___" -BackgroundColor DarkCyan -NoNewLine; Write-Host "___" -BackgroundColor DarkGreen -NoNewLine; Write-Host "___" -BackgroundColor DarkYellow -NoNewLine; Write-Host "___" -BackgroundColor DarkRed -NoNewLine; Write-Host "___" -BackgroundColor DarkMagenta;



