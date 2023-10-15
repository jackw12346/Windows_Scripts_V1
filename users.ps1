$authorizedUsers = Read-Host "Please enter the authorized users (comma-separated, no spaces)"
$authorizedAdmins = Read-Host "Please enter the authorized admins (comma-separated, no spaces)"

$authorizedUsers = $authorizedUsers.Split(",")
$authorizedAdmins = $authorizedAdmins.Split(",")

$defaultAccounts = "Administrator", "Guest", "DefaultAccount", "WDAGUtilityAccount"

$currentUsers = Get-LocalUser | Where-Object { $_.Enabled -eq $True -and $_.Name -notin $defaultAccounts } | ForEach-Object { $_.Name }
$currentAdmins = Get-LocalGroupMember -Group "Administrators" | Where-Object { $_.Name.Split('\')[-1] -notin $defaultAccounts } | ForEach-Object { $_.Name.Split('\')[-1] }

$unauthorizedUsers = $currentUsers | Where-Object { $_ -notin $authorizedUsers }
$missingUsers = $authorizedUsers | Where-Object { $_ -notin $currentUsers }

$unauthorizedAdmins = $currentAdmins | Where-Object { $_ -notin $authorizedAdmins }
$missingAdmins = $authorizedAdmins | Where-Object { $_ -notin $currentAdmins }

Write-Host "Unauthorized users: $unauthorizedUsers"
Write-Host "Missing users: $missingUsers"

Write-Host "Unauthorized admins: $unauthorizedAdmins"
Write-Host "Missing admins: $missingAdmins"

$consent = Read-Host "Would you like to fix these issues? (yes/no)"

if ($consent -eq "yes") {
    foreach ($user in $unauthorizedUsers) {
        Remove-LocalUser -Name $user
    }

    foreach ($admin in $unauthorizedAdmins) {
        Remove-LocalGroupMember -Group "Administrators" -Member $admin
    }

    foreach ($user in $missingUsers) {
        New-LocalUser -Name $user -NoPassword
    }

    foreach ($admin in $missingAdmins) {
        Add-LocalGroupMember -Group "Administrators" -Member $admin
    }

    foreach ($user in $authorizedUsers) {
        $localUser = Get-LocalUser -Name $user
        if ($localUser.Enabled -eq $false) {
            Enable-LocalUser -Name $user
            Write-Host "Enabled user: $user"
        }
    }
}

if (!(Test-Path -Path C:\Passwords )) {
    New-Item -ItemType directory -Path C:\Passwords
}

$newPassword = "ThisIsASecurePassword12345!"

$localUsers = Get-LocalUser

foreach($user in $localUsers) {
    try {
        $user | Set-LocalUser -Password (ConvertTo-SecureString -String $newPassword -AsPlainText -Force)

        Write-Output "Changed password for: $($user.Name)"
    } catch {
        Write-Output "Failed to change password for: $($user.Name)"
    }
}

Set-Content -Path C:\Passwords\new.txt -Value $newPassword

Write-Output "Saved the new password for all users to C:\Passwords\new.txt"

$localUsers = Get-LocalUser

foreach($user in $localUsers) {
    try {
        wmic USERACCOUNT WHERE "Name='$($user.Name)'" SET PasswordExpires=TRUE

        Write-Output "Disabled 'Password Never Expires' for: $($user.Name)"
    } catch {
        Write-Output "Failed to update: $($user.Name)"
    }
}
