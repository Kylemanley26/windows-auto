##sharedmailboxchecker

# Import the required module
Import-Module ExchangeOnlineManagement
Import-Module AzureAD

# Store your credentials
$UserCredential = Get-Credential

# Connect to Exchange Online
Connect-ExchangeOnline -Credential $UserCredential
Connect-AzureAD -Credential $UserCredential

# Get all shared mailboxes
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

# Loop through each shared mailbox and check if sign-in is blocked
foreach ($Mailbox in $SharedMailboxes) {
    $User = Get-AzureADUser -ObjectId $Mailbox.WindowsLiveID
    if ($User.AccountEnabled -eq $false) {
        Write-Output "Sign-in is blocked for shared mailbox: $($Mailbox.DisplayName)"
    } else {
        Write-Output "Sign-in is not blocked for shared mailbox: $($Mailbox.DisplayName)"
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
Disconnect-AzureAD
