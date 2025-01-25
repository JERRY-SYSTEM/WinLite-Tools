@net.exe session >nul 2>&1
@if ErrorLevel 1 (echo "以管理员身份运行" & pause && exit)
@start /b "NSudo - TrustedInstaller" "%~dp0_Helper\NsudoC%PROCESSOR_ARCHITECTURE%.exe" -U:T "%~dp0_Helper\SxSExport.cmd"