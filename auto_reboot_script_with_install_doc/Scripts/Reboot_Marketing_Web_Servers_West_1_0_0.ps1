# ------------------------------------------------------------------------------
# Author: Michael Barnes
# Date: 2013-9-10
# Version: 1.0.0
# 
# Script has been verified to run against Windows 2008 servers
# 
# Purpose: This script was designed to reboot servers one at a time. 
# The script reboots the first server and waits until a specific service is online before rebooting the next server.
# The script can be modified to verify if a web service or application service is running
# The script will not start rebooting unless all servers are online.
# and an email notification will be sent.
# The script will not continue if a server does not come back online after reboot
#  and an email notification will be sent.
#  
#  
#
# ------------------------------------------------------------------------------

clear



$serverlist = "<servername>", "<servername>","<servername>", "<servername>"
 
$server = "Marketing West"
$logdate = (get-date).tostring('yyyy-MM-dd')
$log = "D:\Scripts\'$server'_reboot-$logdate.log"
$now = (get-date).tostring('HH:mm:ss -')
$Group = "Marketing West"
$verification ="D:\Scripts\Marketing_Westconfirmreboot.txt"


if(test-path $verification)
{
remove-item $verification



    if(test-path $log)            
    {            
    remove-item $log            
    }  
    else
    {
    Write-host " Log does not exists"
    }

    $now = (get-date).tostring('HH:mm:ss -')
    add-content $log "$now Begin process to verify that every server is online before beginning the reboot process"
    Write-Host "Begin process to verify that every server is online before beginning the reboot process"



    foreach ($server in $serverlist) 
    { 
        # Test to verify all servers are online 
        if (test-Connection -ComputerName $server -Count 4 -Quiet ) 
        {  
        $now = (get-date).tostring('HH:mm:ss -')
        write-Host "$server is online " -ForegroundColor Green 
        add-content $log "$now $server is online "
        } #end if
        
        # If server is not online exit script
        else 
        {
        
        Write-Warning "$server appears to be off-line" 
        write-Host "$server appears to be off-line"

        $now = (get-date).tostring('HH:mm:ss -')
        add-content $log "$now $server is not online; no servers will be rebooted"
        $status=" NOT SUCCESFUL"

        $now = (get-date).tostring('HH:mm:ss -')            
        Send-MailMessage -to $emailrecipients -from $emailfrom -smtpserver $emailserver `
        -Subject "$Group servers reboot" `
        -Body "The automated reboot of $Group servers was $status. See attached job log." `
        -attachment $log 
        exit
        }   #end else  
       
    }  #End foreach


    foreach ($server in $serverlist) 

    {
        start-sleep -seconds 180 
        $checkcount=0 
        restart-computer -computername $server -force
        $now = (get-date).tostring('HH:mm:ss -')
        add-content $log "$now $server is being rebooted"
        start-sleep -seconds 30  
        Write-host "$server is in the process of being rebooted"
      
        
         while ( (get-service -Name W3SVC -ComputerName $server).Status -ne "Running" )   
           
        {

        $now = (get-date).tostring('HH:mm:ss -')
        add-content $log "$now $server Checking every 60 seconds to see if  nodestate is listed as up"
        write-host "Checking every 60 seconds to see if  nodestate is listed as up"
        start-sleep -seconds 60    
         
         
        $checkcount++     
      write-host  "The count check is now $checkcount"
             

             # Server did not respond in time
            if($checkcount -eq 5)  
            {
            
            $now = (get-date).tostring('HH:mm:ss -')
            add-content $log "$now $server The server did not respond in 5 minutes existing script"
            
            Write-host " The server did not respond in 5 minutes existing script"
            $status=" NOT SUCCESFUL"
            Send-MailMessage -to $emailrecipients -from $emailfrom -smtpserver $emailserver `
            -Subject "$Group servers reboot" `
            -Body "The automated reboot of $Group servers was $status. See attached job log." `
            -attachment $log 

            exit
            
            } #End if

         
         }  #end while
         
              
 
 

         $status="SUCCESFUL"



    } # End foreach
       add-content $log "$now server reboot has been completed"
        Write-host "server reboot has been completed"


 	$now = (get-date).tostring('HH:mm:ss -')            
        Send-MailMessage -to $emailrecipients -from $emailfrom -smtpserver $emailserver `
        -Subject "$Group servers reboot" `
        -Body "The automated reboot of $Group servers was $status. See attached job log." `
        -attachment $log 
        remove-item $log
 }       

else
{
$status=" NOT SUCCESFUL"
Write-Host " Warning!!!!. The script can only be ran from the reboot_server_withform_X_xx.ps1"
Write-host "This is done to prevent inadvertent rebooting of production servers"
Write-Host "Exiting script"
$now = (get-date).tostring('HH:mm:ss -')
    add-content $log "$now Warning!!!!. The script can only be ran from the reboot_server_withform_X_xx.ps1.. Server reboot will not occur"
  
Send-MailMessage -to $emailrecipients -from $emailfrom -smtpserver $emailserver `
        -Subject "$Group servers reboot" `
        -Body "The automated reboot of $Group servers was $status. See attached job log." `
        -attachment $log  
remove-item $log 
}