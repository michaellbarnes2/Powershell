
	
	
	Add-Type -AssemblyName System.Windows.Forms
	
	$Form = New-Object System.Windows.Forms.Form
	$Form.Text = 'Comission S3 Upload'
	$Form.Size = '400, 300'
	$Form.StartPosition = 'CenterScreen'
	$Form.KeyPreview=$true
	$Form.Add_KeyDown({
		if ($_.KeyCode -eq 'Escape'){
			$script:Canceling=$true
			[System.Windows.Forms.Application]::DoEvents()
			$this.Close()
		}
    })
	
	
	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = '75, 200'
	$OKButton.Size = '75, 23'
	$OKButton.Text = 'OK'
	$OKButton.DialogResult='Ok'
	$Form.Controls.Add($OKButton)
	$Form.AcceptButton=$OKButton
	
	$CancelButton = New-Object System.Windows.Forms.Button
	$Form.Controls.Add($CancelButton)
	$CancelButton.Location = '150, 200'
	$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
	$CancelButton.Text = 'Cancel'
	$CancelButton.DialogResult='Cancel'
	$CancelButton.add_Click({
			Write-Host 'Cancelling' -Fore green
			$script:Canceling=$true
			[System.Windows.Forms.Application]::DoEvents()
			$Form.Close()
		})
	
	
	$Label = New-Object System.Windows.Forms.Label
	$Form.Controls.Add($Label)
	$Label.Location = '60, 30'
	$Label.Size = '280, 20'
	$Label.Text = 'AWS ACESS KEY ID:'
	
	$TextBox = New-Object System.Windows.Forms.TextBox
	$Form.Controls.Add($TextBox)
	$TextBox.Location = '45, 60'
	$TextBox.Size = '200, 20'
	
	
	$Label1 = New-Object System.Windows.Forms.Label
	$Form.Controls.Add($Label1)
	$Label1.Location = '60, 90'
	$Label1.Size = '280, 20'
	$Label1.Text = 'AWS SECRET ACCESS KEY:'
	
	$TextBox1 = New-Object System.Windows.Forms.TextBox
	$Form.Controls.Add($TextBox1)
	$TextBox1.PasswordChar = '*'
	$TextBox1.Location = '45, 120'
	$TextBox1.Size = '200, 20'
	




	$Form.Topmost = $True
	
	[void]$Form.ShowDialog()
	if(-not $cancelling) {$TextBox.Text,$TextBox1.Text}




$Env:AWS_ACCESS_KEY_ID=$TextBox.Text
$Env:AWS_SECRET_ACCESS_KEY=$TextBox1.Text
$Env:AWS_DEFAULT_REGION="us-east-1"



Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'SpreadSheet (*.xlsx)|*.xlsx'
}
$null = $FileBrowser.ShowDialog()

$uploadfile = $FileBrowser.FileName
$filename = Split-Path $uploadfile -Leaf
Write-Host $uploadfile
Write-Host $dafilename



aws s3 cp $uploadfile s3://<INSERT BUCKET NAME HERE>/$filename