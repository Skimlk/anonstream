#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

SERVICE_NAME=anonstream.service

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SYSTEMD_DIR="/etc/systemd/system"

echo "Setting up $SERVICE_NAME..."

cat > "$SYSTEMD_DIR/$SERVICE_NAME" <<EOF
[Unit]
Description=anonstream daemon
After=network.target

[Service]
Type=simple
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/venv/bin/python3 -m anonstream
Restart=on-failure
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=default.target
EOF

systemctl daemon-reexec
systemctl daemon-reload

systemctl enable --now "$SERVICE_NAME"

echo "Systemd service '$SERVICE_NAME' is now active."
