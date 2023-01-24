#!/bin/bash

VENV_PATH="/home/spent/Documents/PROJECTS/.spent_venv/bin/activate"
BACKEND_PATH="/home/spent/Documents/PROJECTS/.spent_venv/lib/python3.10/site-packages/backend"


# activate virtual environment
source $VENV_PATH

# navigate to the backend directory
cd $BACKEND_PATH

# start the doccano webserver on an available port
for port in {8000..9000}; do
    (echo >/dev/tcp/localhost/$port) &>/dev/null
    if [ $? -ne 0 ]; then
        break
    fi
done
echo "Starting server with port $port."
doccano webserver --port $port &

# start the doccano task in a separate terminal window
gnome-terminal -e "bash -c \"source /path/to/venv/bin/activate; cd /path/to/backend; doccano task\""

# wait for the webserver to start
sleep 5

# open the website in the default browser
xdg-open "http://localhost:$port/"
