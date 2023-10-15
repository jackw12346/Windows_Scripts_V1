cmd.exe /c "bcdedit /set {current} nx OptOut"

$scriptContent = @"
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun", &Hff, "REG_DWORD"
WshShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun", &Hff, "REG_DWORD"
WshShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\DisableAutoplay", 1, "REG_DWORD"
"@

$scriptContent | Out-File -FilePath "disable_autoplay.vbs" -Force

cscript.exe disable_autoplay.vbs

Remove-Item disable_autoplay.vbs -Force

$ipv4Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$ipv6Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"

Set-ItemProperty -Path $ipv4Path -Name "DisableIPSourceRouting" -Value 2
Write-Host "IP source routing disabled for IPv4."

Set-ItemProperty -Path $ipv6Path -Name "DisableIPSourceRouting" -Value 2
Write-Host "IP source routing disabled for IPv6."

Write-Host "IP source routing has been successfully disabled for both IPv4 and IPv6."

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 1

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -Name "fAllowToGetHelp" -Value 0

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "UsrRemoteInitialProgram" -Value ''

Write-Host "Remote Desktop and Remote Assistance have been successfully disabled, and all Remote Desktop users have been removed."

Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name SCRNSAVE.EXE -Value "Bubbles.scr"

Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaveTimeOut -Value 600

Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaverIsSecure -Value 1

Write-Host "Screen saver settings have been successfully applied for the current user."

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel\"

$mitigationOptions = [byte[]] (0x11, 0x12, 0x11, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)

if (Test-Path $regPath) {
    if (!(Get-ItemProperty -Path $regPath -Name "MitigationOptions")) {
        New-ItemProperty -Path $regPath -Name "MitigationOptions" -PropertyType "Binary" -Value $mitigationOptions
    } else {
        Set-ItemProperty -Path $regPath -Name "MitigationOptions" -Value $mitigationOptions
    }
} else {
    Write-Host "Registry path does not exist."
}

Write-Host "Exploit Protection Settings Enabled..."

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3' -Name "1A10" -Value 0x00000003
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2' -Name "1A10" -Value 0x00000003
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\New Windows' -Name "PopupMgr" -Value 1
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name "PrivacyAdvanced" -Value 1
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name "1C00" -Value 0x00000003
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3' -Name "2500" -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1' -Name "2500" -Value 0
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2' -Name "2500" -Value 0

Write-Host "Internet Options Configured..."
