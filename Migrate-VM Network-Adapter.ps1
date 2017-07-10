######################################################################
# Created By @RicardoConzatti | June 2017
# www.Solutions4Crowds.com.br
######################################################################
$vCenter = 0#"lab-vcsa148.s4c.local" # Default = 0
$vCuser = 0#"administrator@vsphere.local" # Default = 0
######################################################################
cls
$S4Ctitle = "Migrate Virtual Machine Network Adapter v1.0"
$Body = 'www.Solutions4Crowds.com.br
=======================================================
'
write-host $S4Ctitle
write-host $Body
write-host "Connect to vCenter Server`n`n=======================================================`n"
if ($vCenter -eq 0) {
	$vCenter = read-host "vCenter Server (FQDN or IP)"
}
else {
	write-host "vCenter Server: $vCenter"
}
if ($vCuser -eq 0) {
	$vCuser = read-host "`nUsername"
}
else {
	write-host "`nUsername: $vCuser"
}
$vCpass = Read-Host -assecurestring "`nPassword"
$vCpass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($vCpass))
Connect-VIServer $vCenter -u $vCuser -password $vCpass | Out-Null
write-host "`nConnected to $vCenter`n" -foregroundcolor "green"
pause
cls
write-host $S4Ctitle
write-host $Body
write-host "Migrate Network Adapter - E1000 to VMXNET3 ($vCenter)`n`n=======================================================`n"
write-host "1 - Datacenter`n2 - Cluster`n3 - Resource Pool`n4 - Folder`n"
$QuestionLocation = read-host "Select Virtual Machines Location"

if ($QuestionLocation -eq 1) { # Datacenter
	$GetDC = Get-Datacenter | Get-View
	$ListDCtotal = 0
	write-host "`n=======================================================`n"
	if ($GetDC.Name.count -eq 1) {
		$VMLocation = $GetDC.Name
		write-host "Datacenter: $VMLocation"
	}
	else {
		while ($GetDC.Name.count -ne $ListDCtotal) {
			write-host "$ListDCtotal -"$GetDC.Name[$ListDCtotal]
			$ListDCtotal++;
		}
		$MyDC = read-host "`nDatacenter Number"
		$VMLocation = $GetDC.Name[$MyDC]
	}
}
if ($QuestionLocation -eq 2) { # Cluster
	$GetCluster = Get-Cluster | Get-View
	$ListClustertotal = 0
	write-host "`n=======================================================`n"
	if ($GetCluster.Name.count -eq 1) {
		$VMLocation = $GetCluster.Name
		write-host "Cluster: $VMLocation"
	}
	else {
		while ($GetCluster.Name.count -ne $ListClustertotal) {
			write-host "$ListClustertotal -"$GetCluster.Name[$ListClustertotal]
			$ListClustertotal++;
		}
		$MyCluster = read-host "`nCluster Number"
		$VMLocation = $GetCluster.Name[$MyCluster]
	}
}
if ($QuestionLocation -eq 3) { # Resource Pool
	$GetResourcePool = Get-ResourcePool | Get-View
	$ListResourcePooltotal = 0
	write-host "`n=======================================================`n"
	if ($GetResourcePool.Name.count -eq 1) {
		$VMLocation = $GetResourcePool.Name
		write-host "Resource Pool: $VMLocation"
	}
	else {
		while ($GetResourcePool.Name.count -ne $ListResourcePooltotal) {
			write-host "$ListResourcePooltotal -"$GetResourcePool.Name[$ListResourcePooltotal]
			$ListResourcePooltotal++;
		}
		$MyResourcePool = read-host "`nResource Pool Number"
		$VMLocation = $GetResourcePool.Name[$MyResourcePool]
	}
}
if ($QuestionLocation -eq 4) { # Folder
	$GetFolder = Get-Folder -Type VM | Get-View
	$ListFoldertotal = 0
	write-host "`n=======================================================`n"
	if ($GetFolder.Name.count -eq 1) {
		$VMLocation = $GetFolder.Name
		write-host "Folder: $VMLocation"
	}
	else {
		while ($GetFolder.Name.count -ne $ListFoldertotal) {
			write-host "$ListFoldertotal -"$GetFolder.Name[$ListFoldertotal]
			$ListFoldertotal++;
		}
		$MyFolder = read-host "`nFolder Number"
		$VMLocation = $GetFolder.Name[$MyFolder]
	}
}
$VMe1000total = Get-VM -Location $VMLocation | Get-NetworkAdapter | Where { $_.Type -eq "E1000"}
if ($VMe1000total.Count -eq 0) { # Check if there are VM e1000
	write-host "`nThere are no e1000 virtual machines in the $VMLocation`nSelect another Virtual Machines Location`n"
	exit
}
else {
	$MyVM = Get-VM -Location $VMLocation | sort-object
	$VMNum = $MyVM.Count
	$VMNumTotal = 0
	write-host "`n=======================================================`n$VMLocation - Total number of VM: $VMNum`n=======================================================`n"
	if ($VMNum -eq 1) {
		$VMe1000 = Get-NetworkAdapter -VM $MyVM.Name | Where { $_.Type -eq "E1000"} | sort-object
		if ($VMe1000.count -gt 0) {
				if ($MyVM.PowerState -eq "PoweredOn") { # Verifies that the VM is turned on
					$VMStatus = "red" 
					$VMmsg = "Not ready"
					$VMon = 1
				}
				if ($MyVM.PowerState[$VMNumTotal] -eq "PoweredOff") { # Verifies that the VM is turned off
					$VMStatus = "green"
					$VMmsg = "Ready"
					$VMoff = 1
				}
				write-host $MyVM.Name"$VMmsg" -foregroundcolor "$VMStatus"
			}
	}
	else {
		while ($VMNum -ne $VMNumTotal) { # List all VMs in the $VMLocation
				$VMe1000 = Get-NetworkAdapter -VM $MyVM.Name[$VMNumTotal] | Where { $_.Type -eq "E1000"} | sort-object
				if ($VMe1000.count -gt 0) {
					if ($MyVM.PowerState[$VMNumTotal] -eq "PoweredOn") { # Verifies that the VM is turned on
						$VMStatus = "red" 
						$VMmsg = "Not ready"
						$VMontemp = 1;$VMon = $VMontemp + $VMon
					}
					if ($MyVM.PowerState[$VMNumTotal] -eq "PoweredOff") { # Verifies that the VM is turned off
						$VMStatus = "green"
						$VMmsg = "Ready"
						$VMofftemp = 1;$VMoff = $VMofftemp + $VMoff
					}
					write-host $MyVM.Name[$VMNumTotal]"$VMmsg" -foregroundcolor "$VMStatus"
				}
				$VMNumTotal++
		}
	}
	$VMpowerstate = $VMoff + $VMon
	write-host "`nTotal number of E1000 VM: $VMpowerstate"
	if ($VMoff -gt 0 -And $VMon -le 0) {
		write-host "`n[ You can continue ]`n" -foregroundcolor "green"
		write-host "VM they are ready: $VMoff"
	}
	else {
		write-host "`n[ You can't continue ]`n" -foregroundcolor "red"
		write-host "VM must be turned off: $VMon"
		write-host "VM they are ready: $VMoff"
		exit
	}
	write-host "`n=======================================================`n"
	$QuestionMigration = read-host "Do you want to continue? (Y or N)"
	if ($QuestionMigration -eq "Y") {
		$VMNumTotal = 0
		write-host
		while ($VMNum -ne $VMNumTotal) {
			$VMe1000 = Get-NetworkAdapter -VM $MyVM.Name[$VMNumTotal] | Where { $_.Type -eq "E1000"} | sort-object
			if ($VMe1000.count -gt 0) {
				Get-VM $MyVM.Name[$VMNumTotal] -Location $VMLocation | Get-NetworkAdapter | Where { $_.Type -eq "E1000"} | Set-NetworkAdapter -Type "vmxnet3" -confirm:$false | Out-Null # migrate e1000 to vmxnet3
				write-host $MyVM.Name[$VMNumTotal]"changed to VMXNET 3"
			}
			$VMNumTotal++;
		}
		write-host "`nMigration OK!`n"
	}
}