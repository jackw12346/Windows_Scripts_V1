# List all shares
Write-Host "Listing all shares..."
$Shares = Get-WmiObject -Class Win32_Share

foreach ($Share in $Shares) {
    Write-Host ("Share Name: " + $Share.Name + " | Path: " + $Share.Path + " | Description: " + $Share.Description)
}

$UserInput = Read-Host "Would you like to remove a share? (yes/no)"

if ($UserInput -eq "yes") {
    $ShareNameToDelete = Read-Host "Please type the share name that you want to delete:"

    try {
        $ShareToDelete = $Shares | Where-Object { $_.Name -eq $ShareNameToDelete }
        if ($ShareToDelete) {
            $ShareToDelete.Delete()
            Write-Host "Share $ShareNameToDelete has been deleted successfully."
        } else {
            Write-Host "No share with the name $ShareNameToDelete was found."
        }
    } catch {
        Write-Host "An error occurred while trying to delete share $ShareNameToDelete. Error details: $_"
    }
} else {
    Write-Host "Okay, no shares will be deleted."
}