$VENV_PATH = "C:\Users\spent\Documents\PROJECTS\.spent_venv\Scripts\Activate.ps1"
$BACKEND_PATH = "C:\Users\spent\Documents\PROJECTS\.spent_venv\Lib\site-packages\backend"

& $VENV_PATH
cd $BACKEND_PATH

# Find an available port
for ($port = 8000; $port -le 9000; $port++) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $tcp.Connect("localhost", $port)
    } catch {
        break
    }
}

Write-Host "Starting server with port $port."
& doccano webserver --port $port

# open new terminal for doccano task
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", "& $VENV_PATH; cd $BACKEND_PATH; doccano task"

# wait for the webserver to start
Start-Sleep -s 5

# open the website in the default browser
Start-Process "http://localhost:$port/"
