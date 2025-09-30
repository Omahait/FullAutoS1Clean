#This script will reboot a system into safe mode. After logging in with an admin account, it will remove S1, then reboot back into normal mode.

#Check for administrator elevated session
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator!" -ForegroundColor Red
    Start-Process powershell.exe "-File $PSCommandPath" -Verb RunAs
    exit
}

#Make a directory for file storage
mkdir C:\TEMP

#Add a local admin
net user S1RemovalAdmin @3sk23JSK23!* /add
net localgroup administrators S1RemovalAdmin /add

#Remove progress bar for faster download
$ProgressPreference = "SilentlyContinue"

#Pull down the S1 exe file from blob storage to be used for uninstall cleanup
wget "https://is0s.file.core.windows.net/labtech/S1_24.2.exe?sv=2023-11-03&st=2025-05-09T22%3A20%3A32Z&se=2026-05-30T22%3A20%3A00Z&sr=f&sp=r&sig=V4M7qOd4Lg6ZcOBhYCSv9xJ2W3EAO752TwL1JVEtd3A%3D" -OutFile C:\TEMP\s1.exe

#Pull down the script that disables safe mode and reboots the system on 10-minute timer
wget "https://github.com/Omahait/FullAutoS1Clean/raw/refs/heads/main/safe.bat" -OutFile C:\TEMP\safe.bat


# Set the system to boot in safe mode with networking
cmd.exe /c "bcdedit /set {default} safeboot network"
if ($LASTEXITCODE -ne 0) {
    Write-Host "SafeBoot Toggle Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

#Set the registry key to run the script that disables safe mode boot and starts the 10-minute reboot timer
powershell.exe -command "reg add 'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce' /v '*DisableSafeMode' /t REG_SZ /d 'C:\TEMP\safe.bat' /f"

#Set the registry key that runs S1 cleanup
powershell.exe -command "reg add 'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce' /v '*Cleanup' /t REG_SZ /d 'C:\TEMP\s1.exe -c -t `"1`"' /f"

#Reboots the system to allow safe mode to activate and the associated registry key actions to run
shutdown /r /f /t 5



