#!/bin/bash
set -e

# Mount is read-only with host-side uid/gid; copy into place with correct perms
MOUNT_KEYS=/home/vpnuser/.ssh/authorized_keys
REAL_KEYS=/home/vpnuser/.ssh/authorized_keys.real
if [ -f "$MOUNT_KEYS" ]; then
    cp "$MOUNT_KEYS" "$REAL_KEYS"
    chown vpnuser:vpnuser "$REAL_KEYS"
    chmod 600 "$REAL_KEYS"
fi

ssh-keygen -A

exec /usr/sbin/sshd -D -e
