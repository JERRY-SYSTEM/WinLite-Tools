@net.exe session >nul 2>&1
@if ErrorLevel 1 (echo "�Թ���Ա�������" & pause && exit)
@start /b "NSudo - TrustedInstaller" "%~dp0_Helper\NsudoC%PROCESSOR_ARCHITECTURE%.exe" -U:T "%~dp0_Helper\SxSExport.cmd"