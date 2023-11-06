# Install required modules if not already installed
$requiredModules = "ExchangeOnlineManagement", "AzureAD" <#, "Pax8-API"#>
$requiredModules | ForEach-Object {
    if (-not (Get-Module -ListAvailable -Name $_)) {
        Install-Module -Name $_ -Force -AllowClobber
    }
}
# Import required modules
Import-Module ExchangeOnlineManagement, AzureAD <#, Pax8-API#>

<#Prompt for credentials (deprecated to account for mfa)
$credential = Get-Credential#>

#Connect modules 
Connect-ExchangeOnline #-Credential $credential
Connect-AzureAD #-Credential $credential

# Prompt for the UPN of the user to be terminated
$userUPN = Read-Host -Prompt "Enter the email of the user to be terminated"

# Block the user from signing in
Set-AzureADUser -ObjectId $userUPN -AccountEnabled $false

# Convert the user's mailbox to a shared mailbox
Set-Mailbox -Identity $userUPN -Type Shared

# Revoke Azure sessions
Revoke-AzureADUserAllRefreshToken -ObjectId $userUPN

#remove group memberships
$userid = (Get-AzureADuser -objectid $userUPN).objectid

$Groups = Get-AzureADUserMembership -ObjectId $userID 
foreach($Group in $Groups){ 
    try { 
        Remove-AzureADGroupMember -ObjectId $Group.ObjectID -MemberId $userID -erroraction Stop 
    }
    catch {
        write-host "$($Group.displayname) membership cannot be removed via Azure cmdlets."
        Remove-DistributionGroupMember -identity $group.mail -member $userid -BypassSecurityGroupManagerCheck # -Confirm:$false
    }
}

# Get the user
$User = Get-AzureADUser -ObjectId $userUPN

# Check if the user has any licenses
if ($User.AssignedLicenses) {
    # Create a new AssignedLicenses object
    $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

    # Loop through the current licenses
    foreach ($License in $User.AssignedLicenses) {
        # Add the license to the remove licenses list
        $Licenses.RemoveLicenses += $License.SkuId
    }

    # Set the user's licenses to the new AssignedLicenses object
    Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses
} else {
    Write-Output "The user does not have any licenses assigned."
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false