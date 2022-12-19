param(
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Server
    )

//$serversOuPath = 'OU=Servers,DC=local'
//$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name

    foreach ($server in $servers) {
        $output = [ordered]@{
            'ServerName'         = $server
			'CPU'         = (Get-CimInstance -ComputerName $server -ClassName Win32_Processor).Caption
            'OperatingSystem'    = (Get-CimInstance -ComputerName $server -ClassName Win32_OperatingSystem).Caption
            'FreeDiskSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk | Measure-Object -Property FreeSpace -Sum).Sum / 1GB),1)
            'Memory (GB)'        = (Get-CimInstance -ComputerName $server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
        }
        [pscustomobject]$output
		//New-Object psobject -Property $props
    }
)


//PS51> .\Get-SrvInv.ps1 -Server (Get-Content -Path 'servers.txt')

New-Object psobject -Property $props

foreach ($server in $servers) {
} | export-csv $fpath\result.csv -notype

-----------------------------------------------------------
$fpath = "D:\AutomationScripts\Framework"

gc $fpath\servers.txt | % {

$computerSystem = Get-CimInstance CIM_ComputerSystem -computer $_ 
$computerBIOS = Get-CimInstance CIM_BIOSElement -computer $_
$computerOS = Get-CimInstance CIM_OperatingSystem -computer $_
$computerCPU = Get-CimInstance CIM_Processor -computer $_
$computerHDD = Get-CimInstance Win32_LogicalDisk -computer $_ -Filter "DeviceID = 'C:'"

$props = [ordered] @{
"Machine: " = $computerSystem.Name
"Manufacturer: " = $computerSystem.Manufacturer
"Model: " = $computerSystem.Model
"SerialNumber: " = $computerBIOS.SerialNumber
"CPU: " = $computerCPU.Name
"RAM: " = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
"OperatingSystem: " = $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"LastReboot: " = $computerOS.LastBootUpTime
"HDD_Capacity: "  = "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
"HDD_Space: " = "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
}

New-Object psobject -Property $props

} | export-csv $fpath\result.csv -notype


-----------------------------------------------------------
cd D:\AutomationScripts\Framework
gc servers.txt |
ForEach-Object{
		$server=$_
		$computerSystem = Get-CimInstance CIM_ComputerSystem -computer $server #Fetching the machine details.
		$computerBIOS = Get-CimInstance CIM_BIOSElement -computer $server
		$computerOS = Get-CimInstance CIM_OperatingSystem -computer $server
		$computerCPU = Get-CimInstance CIM_Processor -computer $server
		$computerHDD = Get-CimInstance Win32_LogicalDisk -computer $server -Filter "DeviceID = 'C:'"
	
		'System Information for:' + $computerSystem.Name
		'Machine: ' + $computerSystem.Name
		'Manufacturer: ' + $computerSystem.Manufacturer
		'Model: ' + $computerSystem.Model
		'SerialNumber: ' + $computerBIOS.SerialNumber
		'CPU: ' + $computerCPU.Name
		'RAM:{0:N2}' -f ($computerSystem.TotalPhysicalMemory/1GB)
		'OperatingSystem: ' + $computerOS.caption + ', Service Pack: ' + $computerOS.ServicePackMajorVersion
		'LastReboot: ' + $computerOS.LastBootUpTime
		'HDD_Capacity: ' + '{0:N2}Gb' -f ($computerHDD.Size/1GB)
		'HDD_Space:{0:P2} Free ({0:N2}Gb)' -f ($computerHDD.FreeSpace/$computerHDD.Size),($computerHDD.FreeSpace/1GB)
		''
	} |	Out-File output.txt

-----------------------------------------------------------

Hi,

Execute the script like this:

.\ScriptName.ps1 > Results.txt

-----------------------------------------------------------
$fpath = "C:\Inventory"

gc $fpath\servers.txt | % {

$computerSystem = Get-CimInstance CIM_ComputerSystem -computer $_ 
$computerBIOS = Get-CimInstance CIM_BIOSElement -computer $_
$computerOS = Get-CimInstance CIM_OperatingSystem -computer $_
$computerCPU = Get-CimInstance CIM_Processor -computer $_
$computerRAM = Get-CimInstance CIM_PhysicalMemory -computer $_
$computerNWA = Get-CimInstance CIM_NetworkAdapter -computer $_
$computerHDD = Get-CimInstance Win32_LogicalDisk -computer $_ -Filter "DeviceID = 'C:'"

$props = [ordered] @{
"Machine: " = $computerSystem.Name
"CPU: " = $computerCPU.Name
"RAM: " = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB" + " Slots:" + $computerRAM.count
"HDD: " = $computerHDD.deviceid + " HDD_Capacity: {0:N2}" -f ($computerHDD.Size/1GB) + "GB" + " HDD_Space: {0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
"Network Interfaces: " = $computerNWA.InterfaceIndex
"Local Users: " + $computerSystem.UserName
"OperatingSystem: " = $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"LastReboot: " = $computerOS.LastBootUpTime
}

New-Object psobject -Property $props

} | export-csv $fpath\result.csv -notype
//} |	Out-File output.txt

-----------------------------------------------------------


    -------------------------------------------------------------------------------------------------------------------------------------------------------------

$bios = Get-WmiObject win32_OperatingSystem -ComputerName localhost | Select PSComputername
$Proc = Get-WmiObject Win32_processor -ComputerName localhost | Select-Object -First 1
$memory = Get-WmiObject Win32_physicalmemory -ComputerName localhost
$system= Get-WmiObject Win32_ComputerSystem -ComputerName localhost
$localdisk=Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName localhost

$Object = New-Object PSObject -Property @{
'ComputerName'         = $proc.SystemName
'Model'                = $system.Model
'Processor Number'     = $system.NumberOfProcessors
'Processor Name'       = $proc.name
'Logical Processeur'   = $system.NumberOfLogicalProcessors
'RAM (GB)'             = $system.TotalPhysicalMemory / 1GB -as [int]
'Used RAM slot'        = $memory.count
'Local Disk c'         = $localdisk.size / 1GB -as [int]
}
Write-Output $Object

----------------------------------------------------------------------------------------------------------------------------------------------------------------
