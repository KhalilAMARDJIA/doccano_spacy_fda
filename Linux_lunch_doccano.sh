#!/bin/bash
VENV_PATH="/home/spent/Documents/PROJECTS/.spent_venv/bin/activate"
BACKEND_PATH="/home/spent/Documents/PROJECTS/.spent_venv/lib/python3.10/site-packages/backend"

source $VENV_PATH
cd $BACKEND_PATH

# Find an available port
for port in {8000..9000}; do
    (echo >/dev/tcp/localhost/$port) &>/dev/null
    if [ $? -ne 0 ]; then
        break
    fi
done

echo "Starting server with port $port."
doccano webserver --port $port &


# open new terminal for doccano task
timeout 10 alacritty -e "bash -c \"source $VENV_PATH; cd $BACKEND_PATH; doccano task\""

# wait for the webserver to start
sleep 5

# open the website in the default browser
xdg-open "http://localhost:$port/"
