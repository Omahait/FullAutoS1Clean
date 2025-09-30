@echo off
cls
 
:: Disable Safe Mode
bcdedit /deletevalue {default} safeboot
 
:: Reboot the system
shutdown /r /f /t 300

