#!/bin/bash

# Title: Package Installer (Beginner Level)
# Purpose: Check and install missing packages one by one.

# 1. Check if the user is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this script with sudo." >&2
    exit 1
fi

PACKAGES=("nginx" "curl" "wget")

# 2. Detect Package Manager
if command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    echo "Detected OS: Debian/Ubuntu family"
    # Refresh package database once before proceeding
    apt-get update -y >/dev/null 2>&1
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
    echo "Detected OS: RHEL/Fedora family (dnf)"
elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="yum"
    echo "Detected OS: RHEL/CentOS family (yum)"
else
    echo "Error: Supported package manager not found." >&2
    exit 1
fi

# 3. Check and install packages
FAILED=0

for PKG in "${PACKAGES[@]}"; do
    # Check if installed
    if [ "$PKG_MANAGER" = "apt" ]; then
        dpkg -s "$PKG" >/dev/null 2>&1
        INSTALLED=$?
    else
        rpm -q "$PKG" >/dev/null 2>&1
        INSTALLED=$?
    fi

    if [ $INSTALLED -eq 0 ]; then
        echo "[INSTALLED] $PKG is already present."
    else
        echo "[MISSING] Installing $PKG..."
        if [ "$PKG_MANAGER" = "apt" ]; then
            DEBIAN_FRONTEND=noninteractive apt-get install -y -- "$PKG"
        else
            $PKG_MANAGER install -y "$PKG"
        fi

        if [ $? -eq 0 ]; then
            echo "[SUCCESS] Installed $PKG"
        else
            echo "[ERROR] Failed to install $PKG" >&2
            FAILED=1
        fi
    fi
done

if [ $FAILED -ne 0 ]; then
    echo "Error: One or more packages failed to install." >&2
    exit 1
fi

echo "All packages successfully checked and installed."
exit 0