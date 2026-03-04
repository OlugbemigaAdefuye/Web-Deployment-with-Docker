#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "=== Updating system ==="
apt-get update -y

echo "=== Installing prerequisites ==="
apt-get install -y ca-certificates curl gnupg

echo "=== Adding Docker’s official GPG key ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== Adding Docker repository ==="
ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

echo "=== Updating package index again ==="
apt-get update -y

echo "=== Installing Docker Engine, CLI, containerd, buildx & compose plugin ==="
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Enabling and starting Docker service ==="
systemctl enable --now docker

# Add the default Ubuntu user (common on EC2 Ubuntu AMIs) if present
TARGET_USER="${SUDO_USER:-ubuntu}"
if id -u "$TARGET_USER" >/dev/null 2>&1; then
  usermod -aG docker "$TARGET_USER"
  echo "Added $TARGET_USER to docker group. This takes effect on next login."
else
  echo "User $TARGET_USER not found; skipped docker group assignment."
fi

echo "=== Docker installation complete ==="
docker --version
docker compose version || true
