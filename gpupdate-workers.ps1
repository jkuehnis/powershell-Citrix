#This Script will invoke an “GPupdate /force”  command on all CitrixWorker Machines.

#12.03.2018 J.Kühnis Updates GPO on all Workermachines
#Ensure that you are running this Script on a Citrix DeliveryController, otherwise you have to enter an Adminadress like '(Get-BrokerMachine -AdminAddress "FQDN of your DeliveryController").DNSName'  (modify Line 13)


IF(!(Get-PSSnapin -Name "Citrix.Broker.Admin.V2" -ErrorAction SilentlyContinue)){
    Add-PSSnapin *
        IF(!(Get-Command -Name "Get-BrokerMachine" -ErrorAction SilentlyContinue)){
         Write-Warning "Could not find/load CitrixPSSnapin 'Citrix.Broker.Admin.V2' or the Cmdlet 'Get-BrokerMachine' is not available. Ensure that you are running this Script on a DeliveryController Server."
         return
        }
    }

(Get-BrokerMachine).DNSName | % {
      Invoke-Command -ComputerName $_ -ScriptBlock {gpupdate /force} -AsJob  
}

Get-Job
