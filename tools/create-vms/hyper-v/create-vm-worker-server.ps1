#requires -Modules Hyper-V

$vmName = "worker"
$staticMACAddress = "00:15:5d:00:27:13"
#######################################
$memory = 4GB
$cpuCount = 2
$vmPath = "d:\VMs"
$vhdPath = "$vmPath\$vmName\vm-hdd.vhdx"
$vhdMaxSize = 30GB
$installIsoPath = "d:\VMs\ubuntu-18.04.5-live-server-amd64.iso"


$vm = New-VM -Name $vmName -Path $vmPath -MemoryStartupBytes $memory -SwitchName 'Default Switch' -Generation 2 -NoVHD
Set-VM -VMName $vmName -AutomaticCheckpointsEnabled $false -AutomaticStartAction StartIfRunning -AutomaticStopAction Save
Set-VMMemory -VM $vm -DynamicMemoryEnabled $false
Set-VMProcessor -VM $vm -Count $cpuCount
Set-VMNetworkAdapter -VM $vm -StaticMacAddress $staticMACAddress
$dvdDrive = Add-VMDvdDrive -VM $vm -ControllerNumber 0 -ControllerLocation 0 -Path $installIsoPath -Passthru
New-VHD -Path $vhdPath -SizeBytes $vhdMaxSize -Dynamic -BlockSizeBytes 1MB 
$vhdDrive = Add-VMHardDiskDrive -VM $vm -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 1 -Path $vhdPath
$bootOrder = New-Object System.Collections.ArrayList
$bootOrder.Add($dvdDrive)
Set-VMFirmware -VM $VM -EnableSecureBoot Off -BootOrder $bootOrder