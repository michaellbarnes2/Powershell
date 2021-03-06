<#   
Michael Barnes
8-17-2017

This script compresses .txt and .log files into a .7zip file. 
Script looks for files that are older that five days.
Files are copied to archive directory 
You will need to update the variable $statebucket variable 

NOTE: YOU WILL NEED TO ENSURE THE VARIABLE $STATEBUCKET HAS BEEN UPDATED TO INCLUDE THE STATE YOU ARE UPLOADING TO  
#> 
 
 Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
  
#Check if 7zip is installed on the local system 
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
 
###### Global Variables ##############
$statebucket = "stc-tn-logs"
 
# Directory start path may need to be changed if other than location listed below
$filePath = "C:\apache-tomcat-8094-phcdev\Logs" 

# Directory where zip files will be located. 
$archive = "C:\Logs\Archive"

#if path does not exsist create directory
if(!(Test-Path -Path $archive ))
{
    New-Item -ItemType directory -Path $archive
}

# Establish date/time for file deletion 
 $LastWrite=(get-date).AddDays(-5).ToString("MM/dd/yyyy")
############################ 
 
 # need to add  statement for other file types "| Where-Object { $_.Extension -eq ".log"} "
 If ($Logs = get-childitem -Recurse $filepath | Where-Object {$_.LastWriteTime -le $LastWrite -and !($_.PSIsContainer)} | sort-object LastWriteTime)
{
 
foreach ($file in $Logs) 
    { 
                    $name = $file.name 
                    $directory = $file.DirectoryName 
                    # need to do replace on other log type
                    
                    if ($name -like "*.log")
                    {
                    $zipfile = $name.Replace(".log",".7z")
                     
                    sz a -t7z "$directory\$zipfile" "$directory\$name" 
                    
                     } #END IF
                      
                      
                    if ($name -like "*.txt")
                    {
                        $zipfile = $name.Replace(".txt",".7z")
                     
                        sz a -t7z "$directory\$zipfile" "$directory\$name" 
                    
                     } #END IF
                      
                      
                if ($zipfile -like "*.7z")
                {
                 write-host "The file name is $zipfile  has been copied to $ archive    "
                 Copy-Item "$directory\$zipfile" $archive  
                 Start-Sleep 10
                 Remove-Item "$directory\$zipfile"   
                 Remove-Item "$directory\$name"
                 }
                      
                                    
       } #END FOR

                
                
} #END IF

# upload all .7z files to S3 and delete after completed
foreach ($i in Get-ChildItem C:\Logs\Archive\*.7z)

{



            Write-S3Object -BucketName $statebucket -File $i.FullName -Key $i.name
            Start-Sleep 10
            Remove-Item $i

 

}


$Username = "place smtp username here";
$Password= "place smtp password here";

function Send-ToEmail([string]$email){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "noreply@stchome.com";
    $message.To.Add($email);
    $message.Subject = "Log files have been uploaded to S3 bucket $statebucket";
    $message.Body = "Log files have been uploaded to S3 bucket $statebucket";


    $smtp = new-object Net.Mail.SmtpClient("email-smtp.us-west-2.amazonaws.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 

 }
Send-ToEmail  -email "michael_barnes@stchome.com" ;
 
########### END OF SCRIPT ########## 