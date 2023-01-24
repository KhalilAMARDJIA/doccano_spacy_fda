# Set path to virtual environment
$VENV_PATH = "$env:USERPROFILE\Documents\PROJECT\.spent_venv\Scripts\activate.ps1"

# Set path to backend directory
$BACKEND_PATH = "$env:USERPROFILE\Documents\PROJECT\.spent_venv\lib\site-packages\backend"

# select available port
for ($port = 8000; $port -le 9000; $port++) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $tcp.Connect("localhost", $port)
    } catch {
        break
    }
}

# Open first terminal window and activate virtual environment, change directory and run doccano webserver with selected port
Start-Process powershell.exe -ArgumentList "-NoExit", "-Command &{&'$VENV_PATH'; cd '$BACKEND_PATH'; doccano webserver --port $port;}"


# Open second terminal window and activate virtual environment, change directory and run doccano task
Start-Process powershell.exe -ArgumentList "-NoExit", "-Command &{&'$VENV_PATH'; cd '$BACKEND_PATH'; doccano task;}"


# open the website in the default browser
Start-Process "http://localhost:$port/"
