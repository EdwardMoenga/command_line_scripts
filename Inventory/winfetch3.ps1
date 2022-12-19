function NetAdapter {
	return Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName localhost | where {$_.IPAddress -ne $null} | select MACAddress, IPAddress
}

$computerOS = Get-WmiObject Win32_OperatingSystem -ComputerName localhost
$computerSystem = Get-WmiObject Win32_ComputerSystem -ComputerName localhost
$computerCPU = Get-WmiObject Win32_processor -ComputerName localhost | Select-Object -First 1
$computerRAM = Get-WmiObject Win32_physicalmemory -ComputerName localhost
$computerHDD = Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName localhost
$computerNAC = NetAdapter

$Object = New-Object PSObject -Property @{
"Machine: " = $computerSystem.Name
"CPU: Cores:" = $computerCPU.NumberOfProcessors + ", Clock Speed: " + $computerCPU.ClockSpeed + ", Manufacturer: " + $computerCPU.Manufacturer
"RAM: Total Amount:" = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" + " Slots:" + $computerRAM.count
"HDD: " = $computerHDD.deviceid + ", HDD_Capacity: {0:N2}" -f ($computerHDD.Size/1GB) + "GB" + ", HDD_Space: {0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + ", Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
"Network Interfaces: IP Address:" = $computerNAC.IPAddress + ", MAC Address: " + $computerOS.ServicePackMajorVersion
"Local Users: " = $computerSystem.UserName + ", Workgroup: " + $computerSystem.Workgroup
"OperatingSystem: " = $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"Uptime: " = $computerOS.LastBootUpTime
}
Write-Output $Object