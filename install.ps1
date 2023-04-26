Add-Type -AssemblyName System.Windows.Forms
# Create a new form
$LocalPrinterForm                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$LocalPrinterForm.ClientSize         = '50,50'
$LocalPrinterForm.text               = "Hive installer"
$LocalPrinterForm.BackColor          = "#ffffff"
# Display the form
$InstallBtn                   = New-Object system.Windows.Forms.Button
$InstallBtn.BackColor         = "#a4ba67"
$InstallBtn.text              = "Compile"
$InstallBtn.width             = 90
$InstallBtn.height            = 30
$InstallBtn.location          = New-Object System.Drawing.Point(10,10)
$InstallBtn.Font              = 'Microsoft Sans Serif,10'
$InstallBtn.ForeColor         = "#ffffff"
$LocalPrinterForm.Controls.Add($InstallBtn )
$InstallBtn.Add_Click({ Install })
function Install {
$InstallBtn.Enabled = $false
    #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/thomasmaurer/demo-cloudshell/master/helloworld.ps1 ') }"
    #for scripts
    Invoke-WebRequest -Uri https://github.com/raslaniks/test/archive/refs/heads/main.zip -OutFile .\main.zip
    #for other
    Expand-Archive -Path .\main.zip -DestinationPath .\honey -Force
    #expand
    $A = Start-Process -FilePath .\honey\test-main\build-windows.bat -Wait -passthru;
    if ( $a.ExitCode -eq 0 )
{
    Write-Output "Installed sucsesfully"
}
else 
{
Write-Output "Not installed"
}
    Remove-Item .\honey -Recurse
    Remove-Item .\main.zip
    "You can close this window"
}
[void]$LocalPrinterForm.ShowDialog()
