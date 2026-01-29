#!/bin/bash
set -e

export DISPLAY=:1

echo "Cleaning up any existing VNC locks..."
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

echo "Starting TigerVNC server..."
tigervncserver :1 \
    -geometry 1920x1080 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None \
    --I-KNOW-THIS-IS-INSECURE &

sleep 3

echo "=========================================="
echo "VNC server ready!"
echo "Connect with VNC client to: localhost:5901"
echo "No password required"
echo "=========================================="

wait
