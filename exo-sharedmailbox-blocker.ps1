##sharedmailbox blocker
# Import the required module
Import-Module ExchangeOnlineManagement, AzureAD

<#Prompt for credentials (deprecated to account for mfa)
$credential = Get-Credential#>

#Connect modules 
Connect-ExchangeOnline #-Credential $credential
Connect-AzureAD #-Credential $credential

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
