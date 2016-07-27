REM Workaround for version Microsoft.Azure.ServiceFabric.WindowsServer.5.1.156.9590
REM The Visual C++ Redistributable Packages is not installed automatically with the current AddNode.ps1 script 

if not exist "C:\Windows\Temp\vcredist_x64.exe" (
	powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe', 'C:\Windows\Temp\vcredist_x64.exe')" <NUL
)
cmd /c ""C:\Windows\Temp\vcredist_x64.exe" /install /passive /norestart"