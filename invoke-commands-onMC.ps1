<#
The nice thing about Powershell and the modules/API to other technologies is that you can do simple queries and have a big effect.
The following example starts a service for specified machines in a Citrix 7.x environment.
#>


#by J.Kühnis 06.03.2019
Add-PSSnapin *
$MC = "mycatalog"
$DG = "mydg"
$Broker = "my.broker.fqdn"
$machines = (Get-BrokerMachine * -AdminAddress $Broker |
 where-object {($_.CatalogName -match $MC) -and ($_.DesktopGroupName -eq $DG)}).DNSName

Foreach ($machine in $Machines)
 {Write-Host $machine -ForegroundColor Yellow
 invoke-command -ComputerName $machine -ScriptBlock {get-service -name cpsvc | Start-Service} }
