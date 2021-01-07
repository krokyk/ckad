#requires -Modules Hyper-V

$installIsoPath = "d:\VMs\ubuntu-18.04.5-desktop-amd64.iso"
$vmName = "master-desktop"
$startupMemory = 8GB
$cpuCount = 2
$vhdPath = "d:\VMs\$vmName\vm-hdd.vhdx"
$vhdMaxSize = 30GB

$switchName = 'vm-switch'
$staticMACAddress = "00:15:5d:00:27:11"


$vm = New-VM -Name $vmName -MemoryStartupBytes $StartupMemory -SwitchName 'Default Switch' -Generation 2 -NoVHD
Set-VMMemory -VM $vm -DynamicMemoryEnabled $false
Set-VMProcessor -VM $vm -Count $cpuCount
Add-VMNetworkAdapter -VM $vm -SwitchName $switchName -StaticMacAddress $staticMACAddress
$dvdDrive = Add-VMDvdDrive -VM $vm -ControllerNumber 0 -ControllerLocation 0 -Path $installIsoPath -Passthru
New-VHD -Path $vhdPath -SizeBytes $vhdMaxSize -Dynamic -BlockSizeBytes 1MB 
$vhdDrive = Add-VMHardDiskDrive -VM $vm -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1 -Path $vhdPath
$bootOrder = New-Object System.Collections.ArrayList
$bootOrder.Add($dvdDrive)
Set-VMFirmware -VM $VM -EnableSecureBoot Off -BootOrder $bootOrder