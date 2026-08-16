#!/bin/bash

# Title: Cross-Distribution Package Installer (Intermediate Level)
# Purpose: Check and install missing packages efficiently using functions.

# Ensure root privileges
if (( EUID != 0 )); then
    echo "Error: Run this script with sudo." >&2
    echo "Usage: sudo $0" >&2
    exit 1
fi

packages=("nginx" "curl" "wget")
missing_packages=()

# Detect Distribution Family and define handler functions
if command -v dpkg >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
    distribution_family="Debian/Ubuntu"

    is_installed() {
        dpkg -s "$1" >/dev/null 2>&1
    }

    update_repo() {
        echo "Updating package lists..."
        DEBIAN_FRONTEND=noninteractive apt-get update -y >/dev/null 2>&1
    }

    install_packages() {
        DEBIAN_FRONTEND=noninteractive apt-get install -y -- "$@"
    }

elif command -v rpm >/dev/null 2>&1; then
    distribution_family="RHEL"

    if command -v dnf >/dev/null 2>&1; then
        pkg_cmd="dnf"
    elif command -v yum >/dev/null 2>&1; then
        pkg_cmd="yum"
    else
        echo "Error: Neither dnf nor yum is available." >&2
        exit 1
    fi

    is_installed() {
        rpm -q "$1" >/dev/null 2>&1
    }

    update_repo() {
        : # No-op for RHEL family
    }

    install_packages() {
        "$pkg_cmd" install -y "$@"
    }
else
    echo "Error: Supported package management tools were not found." >&2
    exit 1
fi

echo "Detected system family: $distribution_family"

# Identify missing packages
for package in "${packages[@]}"; do
    if is_installed "$package"; then
        echo "[INSTALLED] $package is already installed."
    else
        echo "[MISSING] $package needs to be installed."
        missing_packages+=("$package")
    fi
done

# Install all missing packages in a single transaction
if (( ${#missing_packages[@]} > 0 )); then
    update_repo
    echo "Installing: ${missing_packages[*]}..."
    
    if install_packages "${missing_packages[@]}"; then
        echo "[SUCCESS] All missing packages were successfully installed."
    else
        echo "[ERROR] Installation failed." >&2
        exit 1
    fi
else
    echo "All packages are already installed. Nothing to do."
fi

exit 0