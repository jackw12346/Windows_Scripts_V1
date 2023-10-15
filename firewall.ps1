$folderPath = "C:\firewall"
if (!(Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

$firewallUrl = "https://drive.google.com/uc?export=download&id=19H7gjJwNEBiurXWIxspulDdAa-TqD0lo"
$firewallFile = Join-Path -Path $folderPath -ChildPath "firewall.wfw"
Invoke-WebRequest -Uri $firewallUrl -OutFile $firewallFile

$importFirewallPolicy = Read-Host "Do you want to import Firewall settings? (yes/no)"
if ($importFirewallPolicy -eq "yes") {
    Start-Process -FilePath "netsh" -ArgumentList "advfirewall import `"$firewallFile`"" -Verb RunAs
}