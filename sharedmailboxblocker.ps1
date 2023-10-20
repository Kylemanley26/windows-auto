##sharedmailbox blocker
# Import the required module
Import-Module ExchangeOnlineManagement, AzureAD

# Store your credentials
$UserCredential = Get-Credential

# Connect to Exchange Online
Connect-ExchangeOnline -Credential $UserCredential -ShowBanner:$false
Connect-AzureAD -Credential $UserCredential

# Get all shared mailboxes
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

# Loop through each shared mailbox and block sign-in
foreach ($Mailbox in $SharedMailboxes) {
    $User = Get-AzureADUser -ObjectId $Mailbox.WindowsLiveID
    if ($User.AccountEnabled -eq $true) {
        Set-AzureADUser -ObjectId $Mailbox.WindowsLiveID -AccountEnabled $false
        Write-Output "Sign-in is now blocked for shared mailbox: $($Mailbox.DisplayName)"
    } else {
        Write-Output "Sign-in was already blocked for shared mailbox: $($Mailbox.DisplayName)"
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
Disconnect-AzureAD -Confirm:$false
