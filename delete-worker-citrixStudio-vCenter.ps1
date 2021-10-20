<#
With this script one or more servers can be deleted from the Citrix DeliveryController (Citrix Studio) and from the ESXi/vCenter.

To use The Script some variables and values need to be adjusted like the name of the Citrix DeliveryController and vCenter.
Vmware (PowerCLI) and Citrix (SDK) powershellmodules need to be installed.

This only works if the VM name is identical to the Worker Server DNS name. If this is the case, the following string can be deleted in the script [-replace “.FQDN.address”,””]

In my case, the name of the VM is only the “hostname” of the machine and not the DNSname. So the script removes the FQDN name, in order to use the script successfully, this must also be adjusted.
#>

Import-Module *
Add-PSSnapin *

$DeliveryController = "someBrokerDNSName"
Connect-viserver "some vCenter"


Get-BrokerMachine -DNSName anySevernames* -AdminAddress $DeliveryController |  %{
    
    #Delete &amp; Remove From Citrix Studio
    Remove-BrokerMachine $_ -DesktopGroup $_.DesktopGroupName
    Remove-BrokerMachine $_ -Force

    #Delete Permanently from vCenter
    remove-vm ($_.DNSName -replace ".FQDN.Adress","") -DeletePermanently -Confirm:$false

    write-host $_.DNSName -ForegroundColor Green  #Write ServerName

}
