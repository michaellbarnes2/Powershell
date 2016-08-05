
# This is code to remove spaces from the beggining and end of server names which causes RPC errors
$serverlist = Get-Content C:\temp\serverlist4.txt
$serverlist | Foreach {$_.Trim()} | Set-Content C:\temp\serverlist4.txt
$serverlist = Get-Content C:\temp\serverlist4.txt



# Specify the custom table format
$tableFormat =
	@{Expression={$_.SystemName};Label="Host";width=20},
	@{Expression={$_.DisplayName};Label="Service";width=50},
	@{Expression={$_.StartMode};Label="StartMode";width=15},
	@{Expression={$_.State};Label="State";width=15}

foreach ($target in $serverlist) 
{

          try {
          $ErrorActionPreference = "Stop"
	        Get-WmiObject Win32_Service -ComputerName $target -Filter "StartMode='Auto'" `
		        | Where-Object {$_.Started -eq $False} `
		        | Where-Object {$_.DisplayName -ne "PA Collector"} `
                | Where-Object {$_.DisplayName -ne "PA Alarm Generator"} `
		        | Where-Object {$_.DisplayName -ne "Software Protection"} `
                | Where-Object {$_.DisplayName -ne "Microsoft .NET Framework NGEN v4.0.30319_X86"} `
                | Where-Object {$_.DisplayName -ne "Microsoft .NET Framework NGEN v4.0.30319_X64"} `
                | Where-Object {$_.DisplayName -ne "Performance Logs and Alerts"} `
		        | Format-Table $tableFormat
             }
     
          catch {
                
                write-host "The server" $target "can not be reached; Verify that the server name is correct; Verify there are no spaces in the serverlist.txt files"
                }


}
