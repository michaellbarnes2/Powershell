
<#   
Michael Barnes
9-21-2017

This script will start ans service with the word apache in the displayname.
script will be ran as part of the Local group policy located in
Computer Configuration\Windows Settings\Scripts (Startup/Shutdown)

NOTE: YOU WILL NEED TO ENSURE THE VARIABLE $STATEBUCKET HAS BEEN UPDATED TO INCLUDE THE STATE YOU ARE UPLOADING TO  
#> 


# function funcstartservice will start the service and verify that the service is running before moving to the next"
function funcstartservice{
 param($servicename)

Do
 {
 $arrservice = Get-Service -Name $servicename
     if ($arrService.Status -eq "running")
     { 
     Write-Host "$serviceName service is already started"
     }
     else
	{
	Start-Service $servicename
	}
 Start-Sleep 5
 
 } until ($arrservice.Status -eq "Running")
 }

 # Get a list of service diplay names where the name matches apache
$servicename = (Get-Service | Where-Object {$_.displayName -like "Apache*"})


# place all services display names that have the word Apache aand place into an array
foreach ($service in $servicename)
{

# concvert the service display name to the service name
$value = ($service.Name)

#call the fuction to start the services
funcstartservice $value
}