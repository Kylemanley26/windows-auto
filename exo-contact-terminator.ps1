import-module ExchangeOnlineManagement

$UserCredential = Get-Credential

Connect-ExchangeOnline -Credential $UserCredential

$contactEmail = Read-Host -Prompt 'Input the contact email address'
$groups = Get-DistributionGroup

foreach ($group in $groups) {
    Remove-DistributionGroupMember -Identity $group.Identity -Member $contactEmail -Confirm:$false -ErrorAction SilentlyContinue
}

Remove-MailContact -Identity $contactEmail -Confirm:$false -ErrorAction SilentlyContinue

Disconnect-ExchangeOnline
