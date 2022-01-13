<#
.SYNOPSIS
    .
.DESCRIPTION
    This script builds up a remote session. Conditions: remote commands must be activated on that device with Enable-PSRemoting -Force (needs admin-rights) + Devices must share the same domain
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    .\init_remote.ps1 "wind030502" "hiluser" "C:\Users\00067698\Desktop\SS2022 Einsatz\Projekt\mysecurestring.txt"
.NOTES
    Author: Gabriel Ott
    Date:   11.01.2021    
#>
Param(
    [Parameter(Position=0,mandatory=$true)]
    [String]$deviceName,   #Name with path and ".zip"-ending to the archive to be unzipped
    [Parameter(Position=1,mandatory=$true)]
    [String]$deviceUser,   #Name of the user you want to log in remote
    [Parameter(Position=2,mandatory=$true)]
    [String]$deviceCodeFile    #Path to secure-string password for the user you want to log in remote. Create it with "read-host -assecurestring | convertfrom-securestring | out-file mysecurestring.txt"
)


#check if enough arguments
if ($args.Count -eq 3){

    $deviceName = $argv[0]
    $deviceUser = $argv[1]
    $deviceCodeFile = $argv[2]

    $deviceCode = Get-Content $deviceCodeFile | ConvertTo-SecureString
    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $deviceUser, $deviceCode

    try {
        New-PSSession -ComputerName $deviceName -Credential $cred
    }
    catch{
        Write-Host "ERROR: could not establish remote connection. For more info call .\init_remote.ps1 -help"
    }
}
else{
    write-Host "ERROR: need 3 argument(s). For more info call .\init_remote.ps1 -help"
}

