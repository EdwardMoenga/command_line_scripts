$computerOS = Get-WmiObject Win32_OperatingSystem -ComputerName localhost
$computerSystem = Get-WmiObject Win32_ComputerSystem -ComputerName localhost
$computerCPU = Get-WmiObject Win32_Processor -ComputerName localhost
$computerRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName localhost
$computerHDD = Get-WMIObject Win32_LogicalDisk -filter "deviceid='C:'" -ComputerName localhost

function NetAdapter {
	return Get-WmiObject win32_networkadapterconfiguration | where { $_.ipaddress -like "1*" } | select MACAddress, IPAddress | select -First 1
}
function UpTime {
	$LastBoot = (Get-WmiObject -ComputerName localhost -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem")
	$LastBootTime = $Lastboot.ConvertToDateTime($LastBoot.LastBootUpTime)
	return $Span = New-TimeSpan -Start $LastBootTime -End (Get-Date)
}

$computerNAC = NetAdapter
$computerUT = UpTime

$Object = New-Object PSObject -Property @{
	"Machine: " = $computerSystem.Name
	"CPU Cores: " = [String] $computerCPU.NumberOfCores + ", Clock Speed: " + [String] $computerCPU.MaxClockSpeed + ", Manufacturer: " + $computerCPU.Manufacturer
	"RAM: Total Amount:" = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" + ", Slots:" + $computerRAM.count
	"HDD: ID: " = $computerHDD.deviceid + ", HDD_Capacity: {0:N2}" -f ($computerHDD.Size/1GB) + "GB" + ", HDD_Space: {0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + ", Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
	"Network Interfaces: IP Address:" = $computerNAC.IPAddress + " MAC Address: " + $computerNAC.MACAddress
	"Local Users: " = $computerSystem.UserName + ", Workgroup: " + $computerSystem.Workgroup
	"OperatingSystem: " = $computerOS.caption + ", Version: " + $computerOS.Version
	"Uptime: " = $computerUT
}
Write-Output $Object