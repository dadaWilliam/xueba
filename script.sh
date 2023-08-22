#!/bin/bash
#echo "# xueba_app" >> README.md
#git init
#git add README.md
#git commit -m "first commit"
#git branch -M main
#git remote add origin git@github.com:dadaWilliam/xueba_app.git
#git push -u origin main
# Check for "-n" command-line argument
if [[ $1 == "-n" ]]; then
    echo "Running script immediately."
else
    echo "Delaying script for 5 s."
    sleep 5
fi

# Check if gunicorn is running. Repeat the check every 5 seconds until it is.
while ! (pstree -ap | grep -q "gunicorn")
do
    echo "Waiting for gunicorn to start..."
    sleep 5
done


# Find gunicorn processes
processes=$(pstree -ap | grep gunicorn)

# Check if any processes were found
if [[ -z "$processes" ]]; then
    echo "No gunicorn processes found."
else
    echo "Found gunicorn processes. "

    # Kill gunicorn processes
    echo "Killing them now."
    pkill -f gunicorn
    echo "Waiting 2 s now."
    sleep 2
fi

echo "Change to the project directory"
echo "/home/sites/edu.iamdada.xyz/videoproject-master"
cd /home/sites/edu.iamdada.xyz/videoproject-master

echo "Run gunicorn"
# Run gunicorn
nohup /home/sites/edu.iamdada.xyz/env/bin/gunicorn --bind unix:/tmp/xueba.ca.socket videoproject.wsgi:application &

echo "Gunicorn process started."
