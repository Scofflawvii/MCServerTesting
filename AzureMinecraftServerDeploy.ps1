New-Item -Path "C:\Users\MC_Admin\Downloads" -Name "MC_Server" -ItemType "directory"

$job = Start-Job {Invoke-WebRequest -Uri "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar" -OutFile "C:\users\MC_Admin\Downloads\MC_Server\server.jar"}
Wait-Job $job
Receive-Job $job

$job = Start-Job {[Net.ServicePointManager]::SecurityProtocol = "tls12"
Invoke-WebRequest -Uri "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=241534_1f5b5a70bf22433b84d0e960903adac8" -OutFile "C:\users\MC_Admin\Downloads\MC_Server\jre8.exe"}
Wait-Job $job
Receive-Job $job

$job = Start-Job {Start-Process 'C:\Users\MC_Admin\Downloads\MC_Server\jre8.exe' -ArgumentList '/s' -Wait -PassThru}
Wait-Job $job
Receive-Job $job

$job = Start-Job {New-NetFirewallRule -DisplayName "Minecraft_Port_25565" -Direction Inbound -LocalPort 25565 -Protocol TCP -Action Allow}
Wait-Job $job
Receive-Job $job

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")
$javaCommand = get-command java.exe
$javaPath = $javaCommand.Name
cd "C:\Users\MC_Admin\Downloads\MC_Server\"
out-file -filepath .\eula.txt -encoding ascii -inputobject "eula=true`n"
iex "$javaPath -Xmx1024M -Xms1024M -jar C:\Users\MC_Admin\Downloads\MC_Server\server.jar nogui"