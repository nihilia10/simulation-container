#!/bin/bash
set -euo pipefail

echo 'Updating /etc/hosts file...'
HOSTNAME=$(hostname)
echo "127.0.1.1    $HOSTNAME" >> /etc/hosts

echo "Starting VNC server at $RESOLUTION..."
vncserver -kill :1 || true
vncserver -geometry $RESOLUTION :1 &
echo "VNC server started at $RESOLUTION!"

# Arranca noVNC (6080 -> 5901)
echo "Starting noVNC server..."
exec websockify --web=/usr/share/novnc 0.0.0.0:6080 localhost:5901
# /usr/share/novnc/utils/novnc_proxy \
#   --vnc localhost:5901 \
#   --listen 0.0.0.0:6080 \
#   --web /usr/share/novnc &

NOVNC_PID=$!
wait $NOVNC_PID
