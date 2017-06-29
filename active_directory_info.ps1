#Created script to get users from active directory and and place in formated file
# Creted by Micheal Barnes


$struser = Get-Content c:\my_scripts\importadinfo.txt


$stream = [System.IO.StreamWriter] "c:\my_scripts\outputadinfo.txt"


$stream.writeline( "MANAGER," + "ACTIVE ,"+ "CAMPUSLOCATION, "+ "TELEPHONE, "+"SAMACCOUNTNAME, "+"EMPLOYEEID, "+"NAME, "+"EMAIL, "+"TITLE, "+" FAX")

foreach($User in $struser) 
{
$usernameimport = (Get-ADUser $User -Properties *)
$campusid = $usernameimport.l
$telephone = $usernameimport.telephoneNumber
$SamAccountName = $usernameimport.SamAccountName
$EmployeeID = $usernameimport.EmployeeID
$Name = $usernameimport.Name
$newname = $Name.Split(",")
$EmailAddress = $usernameimport.EmailAddress
$title = $usernameimport.Title
$fax = $usernameimport.Fax
$manager = $usernameimport.Manager 
$active = $usernameimport.Enabled

$updatemanager =$manager.Substring(3)

$b = $updatemanager.Split(",")
$c = $b.TrimEnd("\")
$d =  $c.TrimEnd("OU=Staff,OU=CS,OU=PIT,OU=ET,DC=admin,DC=edmc,DC=adm")


Write-host ( "$d","$active","$campusid","$telephone", "$SamAccountName","$EmployeeID ","$newname ","$EmailAddress ","$title "," $fax")


$stream.writeline( "$d," + "$active ,"+ "$campusid, "+ "$telephone, "+"$SamAccountName, "+"$EmployeeID, "+"$newname, "+"$EmailAddress, "+"$title, "+" $fax")


}


$stream.Close()
