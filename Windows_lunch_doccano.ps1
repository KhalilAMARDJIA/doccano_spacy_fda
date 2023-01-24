# activate virtual environment
& "$env:USERPROFILE\Documents\PROJECTS\.spent_venv\Scripts\activate.ps1"

# navigate to the backend directory
Set-Location "$env:USERPROFILE\Documents\PROJECTS\.spent_venv\lib\python3.10\site-packages\backend"

# start the doccano webserver on an available port
for ($port = 8000; $port -le 9000; $port++) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $tcp.Connect("localhost", $port)
    } catch {
        break
    }
}
Write-Host "Starting server with port $port."
Start-Process -FilePath "doccano" -ArgumentList "webserver --port $port" -NoNewWindow -Wait

# start the doccano task in a separate PowerShell window
Start-Process PowerShell -ArgumentList "-NoExit", "-Command", "& { & `"$env:USERPROFILE\Documents\PROJECTS\.spent_venv\Scripts\activate.ps1`"; Set-Location `"$env:USERPROFILE\Documents\PROJECTS\.spent_venv\lib\python3.10\site-packages\backend`"; & `"doccano task`"; }"

# wait for the webserver to start
Start-Sleep -s 5

# open the website in the default browser
Start-Process "http://localhost:$port/"