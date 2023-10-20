##SID checker
$SID = "S-1-5-21-1634599995-1460617952-441284377-1124"

try {
    $user = Get-ADUser -Filter {SID -eq $SID}
    if ($user) {
        Write-Host "Username: $($user.SamAccountName)"
        Write-Host "Display Name: $($user.DisplayName)"
    } else {
        Write-Host "User not found."
    }
} catch {
    Write-Host "Error: $_"
}