$fpath = "C:\Inventory"

gc $fpath\servers.txt | % {

$computerSystem = Get-WmiObject Win32_ComputerSystem -ComputerName $_ 
$computerOS = Get-WmiObject win32_OperatingSystem -ComputerName $_
$computerCPU = Get-WmiObject Win32_processor -ComputerName $_
$computerRAM = Get-WmiObject Win32_physicalmemory -ComputerName $_
$computerNAC = Get-WmiObject Win32_NetworkAdapterConfiguration -computer $_  |
    Where-Object {
        $_.IPEnabled -and 
        $_.Description -notmatch $ExcludedNetAdapterList
        }
$computerHDD = Get-WMIObject Win32_Logicaldisk -filter "DeviceID = 'C:'" -ComputerName $_

$Object = New-Object PSObject -Property @{
"Machine: " = $computerSystem.Name
"CPU: " = $computerCPU.Name
"RAM: " = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" + " Slots:" + $computerRAM.count
"HDD: " = $computerHDD.deviceid + " HDD_Capacity: {0:N2}" -f ($computerHDD.Size/1GB) + "GB" + " HDD_Space: {0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"

"Local Users: " = $computerSystem.UserName
"OperatingSystem: " = $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"LastReboot: " = $computerOS.LastBootUpTime
}


} | export-csv $fpath\result.csv -notype