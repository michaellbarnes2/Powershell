[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

clear
Do
{

$name= read-host "User Name"
$dn= read-host "Domain"
$pw = Read-Host -assecurestring "Please enter your password"
$pw = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw))






$rebootdate =""
$reboottime =""

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Automated Server Reboot"
$objForm.Size = New-Object System.Drawing.Size(400,800) 
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True



$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,700)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$rebootdate=$textBoxdate.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)
$OKButton.Add_Click({$reboottime=$textBoxtime.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,700)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Select the servers that need to be rebooted:"
$objForm.Controls.Add($objLabel) 


$objMarkW = New-Object System.Windows.Forms.checkbox
$objMarkW.Checked = $false
$objMarkW.text = "Marketing Servers West"
$objMarkW.Location = New-Object System.Drawing.Size(10,40)
$objMarkW.Size = New-Object System.Drawing.Size(260,50)
$objForm.Controls.Add($objMarkW)

$objMarkE = New-Object System.Windows.Forms.checkbox
$objMarkE.Checked = $false
$objMarkE.text = "Marketing Servers East"
$objMarkE.Location = New-Object System.Drawing.Size(10,80)
$objMarkE.Size = New-Object System.Drawing.Size(260,60)
$objForm.Controls.Add($objMarkE)

$objEleads = New-Object System.Windows.Forms.checkbox
$objEleads.Checked = $false
$objEleads.text = "Eleads DMZ Servers"
$objEleads.Location = New-Object System.Drawing.Size(10,120)
$objEleads.Size = New-Object System.Drawing.Size(260,60)
$objForm.Controls.Add($objEleads)

$objSocrates = New-Object System.Windows.Forms.checkbox
$objSocrates.Checked = $false
$objSocrates.text = "Socrates"
$objSocrates.Location = New-Object System.Drawing.Size(10,160)
$objSocrates.Size = New-Object System.Drawing.Size(260,60)
$objForm.Controls.Add($objSocrates)

$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,270) 
$objLabel2.Size = New-Object System.Drawing.Size(280,20) 
$objLabel2.Text = "Select the date to reboot servers:"
$objForm.Controls.Add($objLabel2) 

# MonthCalendar
$monthCal = New-Object System.Windows.Forms.MonthCalendar
$monthCal.Location = "8,300"
$monthCal.MinDate = New-Object System.DateTime(2013, 1, 1)
$monthCal.MinDate = "01/01/2012"       # Minimum Date Dispalyed
$monthCal.MaxDate = "12/31/2019"       # Maximum Date Dispalyed
$monthCal.MaxSelectionCount = 1        # Max number of days that can be selected
$monthCal.ShowToday = $false           # Show the Today Banner at bottom
$monthCal.ShowTodayCircle = $true      # Circle Todays Date
$monthCal.FirstDayOfWeek = "Sunday"    # Which Day of the Week in the First Column
$monthCal.ScrollChange = 1             # Move number of months at a time with arrows
$monthCal.ShowWeekNumbers = $false     # Show week numbers to the left of each week
$objForm.Controls.Add($monthCal)



# Date Selected Label
$selectLabel = New-Object System.Windows.Forms.Label
$selectLabel.Location = "270,300"
$selectLabel.Height = 22
$selectLabel.Width = 300
$selectLabel.Text = "Date Selected"
$objForm.Controls.Add($selectLabel)

# Enter time label
$objLabel3 = New-Object System.Windows.Forms.Label
$objLabel3.Location = New-Object System.Drawing.Size(10,500) 
$objLabel3.Size = New-Object System.Drawing.Size(220,20) 
$objLabel3.Text = "Enter the time to reboot servers: HH:MM"
$objForm.Controls.Add($objLabel3)

# Text box used to enter time
$textBoxtime = New-Object System.Windows.Forms.TextBox
$textBoxtime.Location = "270,500"
$textBoxtime.Size = "75,30"
$objForm.Controls.Add($textBoxtime)



$textBoxdate = New-Object System.Windows.Forms.TextBox
$textBoxdate.Location = "270,330"
$textBoxdate.Size = "75,30"
$objForm.Controls.Add($textBoxdate)

# Select Button 1
$dateTimePickerButton = New-Object System.Windows.Forms.Button 
$dateTimePickerButton.Location = "270,380"
$dateTimePickerButton.Size = "75,23"
$dateTimePickerButton.Text = "<<<-- Select"
$dateTimePickerButton.add_Click({
    $textBoxdate.Text = $monthCal.SelectionStart
    $textBoxdate.Text = $textBoxdate.Text.Substring(0,10)
    })
$objForm.Controls.Add($dateTimePickerButton)


$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()





}
until ($reboottime ) ($rebootdate)




if($objMarkW.checked)
 {
write-host "Rebooting Marketing West"
 Schtasks /create /tn "Patching Marketing West Server Reboot" /ru "$dn\$name" /rp $pw /sc once /st $reboottime /sd $rebootdate /Z /V1 /tr " PowerShell -command C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe D:\Scripts\Reboot_Marketing_Web_Servers_West_1_0_0.ps1"
New-Item D:\Scripts\Marketing_Westconfirmreboot.txt -type file
 }
 
if($objMarkE.checked)
 {
write-host "Rebooting Marketing East"

Schtasks /create /tn "Patching Marketing East Server Reboot" /ru "$dn\$name" /rp $pw /sc once /st $reboottime /sd $rebootdate /Z /V1 /tr " PowerShell -command C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe D:\Scripts\Reboot_Marketing_Web_Servers_East_1_0_0.ps1"
New-Item D:\Scripts\Marketing_Eastconfirmreboot.txt -type file
 }
 
if($objEleads.checked)
{
write-host "Rebooting Eleads"

Schtasks /create /tn "Patching Eleads Server Reboot" /ru "$dn\$name" /rp $pw /sc once /st $reboottime /sd $rebootdate /Z /V1 /tr " PowerShell -command C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe D:\Scripts\Reboot_Eleads_Web_Servers_1_0_0.ps1"
New-Item D:\Scripts\Eleadsconfirmreboot.txt -type file
 
 }
 
if($objSocrates.checked)
{
write-host "Rebooting Socrates"

Schtasks /create /tn "Patching Socrates Server Reboot" /ru "$dn\$name" /rp $pw /sc once /st $reboottime /sd $rebootdate /Z /V1 /tr " PowerShell -command C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe D:\Scripts\Reboot_Socrates_Web_Servers_1_0_0.ps1"
New-Item D:\Scripts\Socratesconfirmreboot.txt -type file
 }
$rebootdate
$reboottime

