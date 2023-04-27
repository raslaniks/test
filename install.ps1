Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# Create a new form
$CompileForm                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$CompileForm.ClientSize         = '200,50'
$CompileForm.text               = "Hive installer"
$CompileForm.BackColor          = "#ffffff"
$CompileForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow
# Display the form
$InstallBtn                   = New-Object system.Windows.Forms.Button
$InstallBtn.BackColor         = "#67ba9a"
$InstallBtn.text              = "Compile"
$InstallBtn.width             = 90
$InstallBtn.height            = 30
$InstallBtn.location          = New-Object System.Drawing.Point(10,10)
# $InstallBtn.DialogResult      = [System.Windows.Forms.DialogResult]::OK
$InstallBtn.Font              = 'Microsoft Sans Serif,10'
$InstallBtn.ForeColor         = "#ffffff"
$CompileForm.Controls.Add($InstallBtn )
$InstallBtn.Add_Click({ Load-N-Run("build-windows.bat") })


$SetUpBtn                   = New-Object system.Windows.Forms.Button
$SetUpBtn.BackColor         = "#a4ba67"
$SetUpBtn.text              = "SetUp"
$SetUpBtn.width             = 90
$SetUpBtn.height            = 30
$SetUpBtn.location          = New-Object System.Drawing.Point(100,10)
# $SetUpBtn.DialogResult      = [System.Windows.Forms.DialogResult]::OK
$SetUpBtn.Font              = 'Microsoft Sans Serif,10'
$SetUpBtn.ForeColor         = "#ffffff"
$CompileForm.Controls.Add($SetUpBtn )
$SetUpBtn.Add_Click({ Load-N-Run("setup-windows.bat")  })


# $textBox = New-Object System.Windows.Forms.TextBox
# $textBox.Location = New-Object System.Drawing.Point(10,40)
# $textBox.Size = New-Object System.Drawing.Size(260,20)
# $textBox.Enabled = $false
# $CompileForm.Controls.Add($textBox)

function Load-Files {
    Invoke-WebRequest -Uri https://github.com/raslaniks/test/archive/refs/heads/main.zip -OutFile .\main.zip
    #for other
    Expand-Archive -Path .\main.zip -DestinationPath .\honey -Force
}
function Remove-Files {
    Remove-Item .\honey -Recurse
    Remove-Item .\main.zip
}
function Run-Code {
    param (
        [string]$FileAddress
    )
    $A = Start-Process -FilePath $FileAddress -Wait -passthru
    Check-Error($A)
}

function Check-Error {
    param (
        [System.Diagnostics.Process]$Process
    )
    $wshell = New-Object -ComObject Wscript.Shell

    if ( $Process.ExitCode -eq 0 )
    {
        # $textBox.AppendText("Installed sucsesfully")
        $wshell.Popup("Installed sucsesfully",0x0,"Done",0x0)
    }
    else 
    {
        # $textBox.AppendText("Not installed")
        $wshell.Popup("Not installed",0x30,"Done",0x0)
    }
}

function Load-N-Run {
    param (
        [string]$name
    )
    if (-not(Test-Path -Path .\honey)){
        Load-Files
    }
    Run-Code(".\honey\test-main\$name")
    
}
# build-windows.bat
# function Compile {
# $InstallBtn.Enabled = $false
# Load-N-Run("build-windows.bat")
#     #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/thomasmaurer/demo-cloudshell/master/helloworld.ps1 ') }"
#     #for scripts
#     # Load-Files
#     # #expand
#     # # $A = Start-Process -FilePath .\honey\test-main\build-windows.bat -Wait -passthru
#     # Run-Code(".\honey\test-main\build-windows.bat")
#     # Remove-Files
#     # Start-Sleep -Seconds 1.5
#     # Stop-process -Id $PID
# }

$result = $CompileForm.ShowDialog()


if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    Write-Host "Canceling..."
    Remove-Files
}
