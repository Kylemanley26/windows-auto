Import-Module ExchangeOnlineManagement

# Prompt for Exchange environment credentials
$credential = Get-Credential

# Connect to Exchange Online using the provided credentials
Connect-ExchangeOnline -Credential $credential

# Create the GUI form
Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Exchange Online Contact Creator"
$Form.Size = New-Object System.Drawing.Size(400, 400)
$Form.StartPosition = "CenterScreen"

# Create labels and textboxes for input
$LabelName = New-Object System.Windows.Forms.Label
$LabelName.Location = New-Object System.Drawing.Point(20, 20)
$LabelName.Size = New-Object System.Drawing.Size(200, 20)
$LabelName.Text = "Contact Name:"
$Form.Controls.Add($LabelName)

$TextBoxName = New-Object System.Windows.Forms.TextBox
$TextBoxName.Location = New-Object System.Drawing.Point(220, 20)
$TextBoxName.Size = New-Object System.Drawing.Size(150, 20)
$Form.Controls.Add($TextBoxName)

$LabelEmail = New-Object System.Windows.Forms.Label
$LabelEmail.Location = New-Object System.Drawing.Point(20, 60)
$LabelEmail.Size = New-Object System.Drawing.Size(200, 20)
$LabelEmail.Text = "Contact Email:"
$Form.Controls.Add($LabelEmail)

$TextBoxEmail = New-Object System.Windows.Forms.TextBox
$TextBoxEmail.Location = New-Object System.Drawing.Point(220, 60)
$TextBoxEmail.Size = New-Object System.Drawing.Size(150, 20)
$Form.Controls.Add($TextBoxEmail)

$LabelGroups = New-Object System.Windows.Forms.Label
$LabelGroups.Location = New-Object System.Drawing.Point(20, 100)
$LabelGroups.Size = New-Object System.Drawing.Size(200, 20)
$LabelGroups.Text = "Select Groups:"
$Form.Controls.Add($LabelGroups)

$ListBoxGroups = New-Object System.Windows.Forms.ListBox
$ListBoxGroups.Location = New-Object System.Drawing.Point(220, 100)
$ListBoxGroups.Size = New-Object System.Drawing.Size(150, 150)
$ListBoxGroups.SelectionMode = "MultiExtended"
$Form.Controls.Add($ListBoxGroups)

$ButtonCreateContact = New-Object System.Windows.Forms.Button
$ButtonCreateContact.Location = New-Object System.Drawing.Point(135, 280)
$ButtonCreateContact.Size = New-Object System.Drawing.Size(130, 30)
$ButtonCreateContact.Text = "Create Contact"
$ButtonCreateContact.Add_Click({
    # Get selected groups
    $groups = Get-SelectedGroups
    
    # Create contact
    $contact = New-MailContact -Name $TextBoxName.Text -ExternalEmailAddress $TextBoxEmail.Text
    
    # Add contact to selected groups
    foreach ($group in $groups) {
        Add-DistributionGroupMember -Identity $group -Member $contact.Alias
    }
    
    # Show success message
    [System.Windows.Forms.MessageBox]::Show("Contact created and added to selected groups.", "Success")
})
$Form.Controls.Add($ButtonCreateContact)

# Function to get selected groups from the listbox
function Get-SelectedGroups {
    $selectedGroups = @()
    
    foreach ($item in $ListBoxGroups.SelectedItems) {
        $groupId = $item -replace ".*\((.*?)\).*", '$1'
        $selectedGroups += $groupId
    }
    
    return $selectedGroups
}

# Fetch groups from Exchange Online and populate the listbox
foreach ($group in Get-DistributionGroup) {
    $ListBoxGroups.Items.Add("$($group.DisplayName) ($($group.Identity))")
}

# Show the form
$Form.ShowDialog()

# Close the form
$Form.Close()

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

# Terminate the current process
Stop-Process -Id $PID
