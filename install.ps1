function Install {
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
}

Install
pause
