$driveLetter = "E:"
$fileName = "Favism - Arabic.docx"

# Check if the drive exists
if (Test-Path $driveLetter -PathType Container) {
    # Search for the file recursively in the drive
    $file = Get-ChildItem -Path $driveLetter -Filter $fileName -Recurse -ErrorAction SilentlyContinue

    # Check if the file is found
    if ($file) {
        Write-Host "File found: $($file.FullName)"
    }
    else {
        Write-Host "File not found."
    }
}
else {
    Write-Host "Drive '$driveLetter' does not exist."
}