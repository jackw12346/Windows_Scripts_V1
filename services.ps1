Write-Host "Starting the service auditing process. Please wait..."

$servicesToDisable = @(
    "BTAGService", "bthserv", "Browser", "MapsBroker", "lfsvc", 
    "IISADMIN", "irmon", "SharedAccess", "lltdsvc", "LxssManager", 
    "FTPSVC", "MSiSCSI", "sshd", "PNRPsvc", "p2psvc", "p2pimsvc", 
    "PNRPAutoReg", "Spooler", "wercplsupport", "RasAuto", "SessionEnv", 
    "TermService", "UmRdpService", "RpcLocator", "RemoteRegistry", 
    "RemoteAccess", "LanmanServer", "simptcp", "SNMP", "sacsvr", 
    "SSDPSRV", "upnphost", "WMSvc", "WerSvc", "Wecsvc", 
    "WMPNetworkSvc", "icssvc", "WpnService", "PushToInstall", 
    "WinRM", "W3SVC", "XboxGipSvc", "XblAuthManager", 
    "XblGameSave", "XboxNetApiSvc"
)

foreach($service in $servicesToDisable) {
    if (Get-Service $service -ErrorAction SilentlyContinue) {
        if((Get-Service $service).Status -eq 'Running') {
            Stop-Service $service -Force
        }
        Set-Service $service -StartupType Disabled
        Write-Host "Service $service has been stopped and disabled."
    } else {
        Write-Host "Service $service does not exist."
    }
}

$servicesToEnable = @(
    "EventLog", "MpsSvc", "WinDefend", "SamSs", 
    "gpsvc", "wuauserv", "CryptSvc", "wscsvc"
)

foreach($service in $servicesToEnable) {
    if (Get-Service $service -ErrorAction SilentlyContinue) {
        if((Get-Service $service).Status -ne 'Running') {
            Start-Service $service
        }
        Set-Service $service -StartupType Automatic
        Write-Host "Service $service has been started and set to automatic."
    } else {
        Write-Host "Service $service does not exist."
    }
}
