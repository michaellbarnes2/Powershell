
#clear


[int]$serverapplication = 0
while ( $serverapplication -lt 1 -or $serverapplication -gt 4 ){
  Write-host "1. All"
  Write-host "2. Marketing"
  Write-host "3. Genysys"
  Write-host "4. Quit and exit"
  [Int]$serverapplication = read-host "Select the servers for verification Please enter an option 1 to 4..." 
}
if ($serverapplication = 1 )
{
$appenv = "All.txt"
}

[int]$verificationtype = 0
while ( $verificationtype -lt 1 -or $verificationtype -gt 4 ){
  Write-host "1. Server Online verification"
  Write-host "2. PORT STATUS"
  Write-host "3. SERVICES"
  Write-host "4. Quit and exit"
  [Int]$verificationtype = read-host "Select the servers for verification Please enter an option 1 to 4..." 
}


Write-Host " The server is $serverapplication"
Write-Host " The verification type is $verificationtype"

#start-sleep -30 

if ($verificationtype -eq 1)
{
$command = "C:\Users\da_mlbarnes\Desktop\Final_patch_verification\serverup_verification.ps1 –listlocation 'C:\temp\$appenv ' "
Invoke-Expression $command

}

if ($verificationtype -eq 3)
{
$command = "C:\Users\da_mlbarnes\Desktop\Final_patch_verification\services_verification1_4.ps1 –listlocation 'C:\temp\$appenv ' "
Invoke-Expression $command

}

