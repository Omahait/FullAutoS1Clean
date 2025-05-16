@echo off
cls
 
:: Disable Safe Mode
bcdedit /deletevalue {default} safeboot

:: Disable auto-logon 
del C:\TEMP\AutoLogon64.exe /f
 
:: Reboot the system
shutdown /r /f /t 600
