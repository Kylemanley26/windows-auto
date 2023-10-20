# Define the path to the directory
$dirPath = "C:\Program Files (x86)\Kantech"

# Get all .exe files in the directory
$files = Get-ChildItem -Path $dirPath -Filter *.exe -Recurse

# Loop through each file
foreach ($file in $files) {
    # Define the rule name, replace '\' with '-' and remove ':' and '.'
    $ruleName = $file.FullName.Replace("\", "-").Replace(":", "").Replace(".", "")

    # Create the outbound rule
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Program $file.FullName -Action Allow
}
