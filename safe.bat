@echo off
cls
 
:: Disable Safe Mode
bcdedit /deletevalue {default} safeboot

:: Disable auto-logon 
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUsername /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
 
:: Reboot the system
shutdown /r /f /t 600
