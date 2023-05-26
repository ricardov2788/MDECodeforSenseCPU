# Variables
$ClientAnalyzer = "https://aka.ms/Betamdeanalyzer"
$DataCollectionScripts = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\DataCollection\"
$NamingMDECA = "MDEClientAnalyzerPreview.zip"
$universalPath = "$env:USERPROFILE\Downloads"
$EnumDir = Get-ChildItem $DataCollectionScripts | select -ExpandProperty Name

# This will only execute if the Invoke-WebRequest is successful.
try
{
    #It will download the client analyzer and leverage PsExec to elevate to system context and navigate to the required path
    Invoke-WebRequest -Uri $ClientAnalyzer -OutFile "$env:USERPROFILE\Downloads\$NamingMDECA"
    Expand-Archive "$universalpath\$NamingMDECA" -Force 
    Set-Location .\MDEClientAnalyzerPreview\Tools

    # Elevate to system context, navigate to the required path and collect a file with the script names to later display them in menu
    .\PsExec.exe -s -i cmd.exe /k powershell cd "$DataCollectionScripts\$EnumDir" ls Out-File "$universalpath\scriptnames.txt"
    # Display numbered menu
    Write-Host "Would you like to run 1 script or multiple scripts?"
    Write-Host "1. Run 1 script"
    Write-Host "2. Run multiple scripts"

    # Prompt user for choice
    $choice = Read-Host "Enter your choice (1 or 2)"

    # If user chooses to run 1 script
    if ($choice -eq "1") {
    # Display scripts from text file
    Write-Host "Select the script you would like to run:"
    $scripts = Get-Content "$universalPath\scriptnames.txt"
    for ($i=0; $i -lt $scripts.Count; $i++) {
    Write-Host ($i+1).ToString() + ". " + $scripts[$i]
    }
    # Prompt user for script number
    $scriptNumber = Read-Host "Enter the number of the script you want to run"
    # Execute selected script
    & $scripts[$scriptNumber-1]
    }
    # If user chooses to run multiple scripts
    elseif ($choice -eq "2") {
    # Prompt user for number of scripts to execute
    $numScripts = Read-Host "How many scripts would you like to execute?"
    # Display scripts from text file
    Write-Host "Select the scripts you would like to run:"
    $scripts = Get-Content "$universalPath\scriptnames.txt"
    for ($i=0; $i -lt $scripts.Count; $i++) {
    Write-Host ($i+1).ToString() + ". " + $scripts[$i]
    }
    # Prompt user for script numbers
    $scriptNumbers = Read-Host "Enter the numbers of the scripts you want to run, separated by commas"
    $scriptNumbersArray = $scriptNumbers.Split(",")
    # Execute selected scripts
    foreach ($scriptNumber in $scriptNumbersArray) {
    & $scripts[$scriptNumber-1]
    }
    }   
}
catch {
    Write-Error ""
}
