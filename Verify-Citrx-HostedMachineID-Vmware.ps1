<#Sometimes the HostedMachineID of Citrix does not match that of VmWare. This is often the case when cloning or moving machines. In Citrix Studio you will see the Powerstate of this machines as unknow and you can’t do any VM actions like reboot in the console.

With this script snippet it can be checked. To do this the variable “Broker” must be adjusted in the Script and the PowerCli and CitrixModule (BrokerSnapIn) must be loaded. Furthermore, the connection to the vCenter must be initiated via “Connect-VIServer vCName“.
#>
#25.09.2019by J.Kühnis - Verfiy HostedMachineID with VmWare ESXi Hypervisoer

$Broker = "Enter your BrokerName"
$Brokermachines = Get-BrokerMachine -AdminAddress $Broker | Select MachineName,DNSName,HostedMachineID

Foreach ($Machine in $Brokermachines){
    IF(get-vm $Machine.DnsName -ErrorAction SilentlyContinue){
        IF($Machine.HostedMachineID -eq (Get-View -id (get-vm $machine.DNSName).id).config.uuid){
            Write-Host $Machine.DnsName "HostedMachineID is matching" $Machine.HostedMachineId -ForegroundColor Green
        }Else{
            Write-host $Machine.DnsName "Mismatch ID: VmWare UUID =" (Get-View -id (get-vm $machine.DNSName).id).config.uuid "; Citrix HostedMachineID =" $Machine.HostedMachineID -ForegroundColor Yellow
        }

    }Else{
        Write-host $Machine.DnsName "MachineName not Found on ESXi" -ForegroundColor Yellow
    }
}
<#
Now that the machines have been read out, the connections can be fixed.
vCenter Cert thumbprint update:
#>
# Open an admin POSH console, load the Citrix Modules (asnp citrix*) and cd to XDHyp:/Connections and run ls. Check the SSLThumbprints entry.
asnp citrix*
cd XDHyp:/Connections
ls

Set-Item -LiteralPath "XDHyp:\Connections\vCenters Name" -sslthumbprint "123456789ABCD123456789ABCDE123456789ABCD" -hypervisorAddress https://vcenter-name/sdk

