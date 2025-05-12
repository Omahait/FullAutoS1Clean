if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator!" -ForegroundColor Red
    Start-Process powershell.exe "-File $PSCommandPath" -Verb RunAs
    exit
}
mkdir C:\TEMP
$ProgressPreference = "SilentlyContinue"
wget "https://is0s.file.core.windows.net/labtech/S1_24.2.exe?sv=2023-11-03&st=2025-05-09T22%3A20%3A32Z&se=2026-05-30T22%3A20%3A00Z&sr=f&sp=r&sig=V4M7qOd4Lg6ZcOBhYCSv9xJ2W3EAO752TwL1JVEtd3A%3D" -OutFile C:\TEMP\s1.exe

wget "https://is0s.file.core.windows.net/labtech/safe.bat?sv=2023-11-03&st=2025-05-09T22%3A40%3A27Z&se=2025-11-15T23%3A40%3A00Z&sr=f&sp=r&sig=J%2BrnJA2QKoATJ%2FDPK1CTGR7fpWEU4IMuAv5AjOm4P4o%3D" -OutFile C:\TEMP\safe.bat

cmd.exe /c "bcdedit /set {default} safeboot network"

powershell.exe -command "reg add 'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce' /v '*DisableSafeMode' /t REG_SZ /d 'C:\TEMP\safe.bat' /f"
powershell.exe -command "reg add 'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce' /v '*Cleanup' /t REG_SZ /d 'C:\TEMP\s1.exe -c -t `"1`"' /f"


shutdown /r /f /t 10