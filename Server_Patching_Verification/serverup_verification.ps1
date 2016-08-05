

$serverlist = Get-Content C:\temp\serverlist.txt
$serverlist | Foreach {$_.Trim()} | Set-Content C:\temp\serverlist.txt
$serverlist = Get-Content C:\temp\serverlist.txt

$serverlist = Get-Content C:\temp\serverlist.txt
 
foreach ($computer in $serverlist) 
{
   try {
          $ErrorActionPreference = "Stop"
                  if (test-connection $computer -count 1)
                {

                write-host "The computer $computer is pingable"

                }

                else 
                {

                write-host "Cannot contact $computer"

                }

        }       

    catch {
               

          write-host "$computer  is not available"

          }

}