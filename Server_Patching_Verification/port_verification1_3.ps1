cd C:\Users\da_mlbarnes\Desktop\Final_patch_verification
 . .\Test-Port.ps1

$serverlist = Get-Content C:\temp\serverlist.txt
$serverlist | Foreach {$_.Trim()} | Set-Content C:\temp\serverlist.txt
$serverlist = Get-Content C:\temp\serverlist.txt

$tableFormat =
	@{Expression={$_.Server};Label="Server";width=30},
	@{Expression={$_.Port};Label="Port";width=20},
	@{Expression={$_.Open};Label="State";width=15}
	

foreach ($target in $serverlist) 
{
 Test-Port -computer $target -port @(3389)  | Where-Object {$_.Open -eq $False} ` |  Format-Table $tableFormat
  
 }