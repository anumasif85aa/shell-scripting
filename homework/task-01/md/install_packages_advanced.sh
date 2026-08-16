#!/bin/bash

# Title: Enterprise Cross-Distro Package Provisioner (Advanced Level)
# Features: Strict mode, logging, multi-distro, single-transaction batching, dry-run mode.

set -euo pipefail

# Configuration & State
READONLY_PACKAGES=("nginx" "curl" "wget")
DRY_RUN=0

# Parse optional arguments (e.g., --dry-run)
for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            echo "[INFO] Running in DRY-RUN mode. No changes will be applied."
            ;;
        *)
            ;;
    esac
done

# Logging Helper
log() {
    local level="$1"
    shift
    printf "[%s] [%s] %s\n" "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$level" "$*"
}

# Root Privilege Verification
if (( EUID != 0 )) && (( DRY_RUN == 0 )); then
    log "ERROR" "Root privileges required. Run with sudo or pass --dry-run." >&2
    exit 1
fi

# Environment Abstraction Layer
detect_package_manager() {
    if [[ -f /etc/os-release ]]; then
        # Load OS metadata safely
        # shellcheck disable=SC1091
        source /etc/os-release
        OS_NAME="${PRETTY_NAME:-Linux}"
    else
        OS_NAME="Generic Linux"
    fi

    log "INFO" "Detected System: $OS_NAME"

    if command -v apt-get >/dev/null 2>&1; then
        PKG_CHECK_CMD=("dpkg" "-s")
        PKG_UPDATE_CMD=("apt-get" "update" "-y")
        PKG_INSTALL_CMD=("env" "DEBIAN_FRONTEND=noninteractive" "apt-get" "install" "-y" "--")
    elif command -v dnf >/dev/null 2>&1; then
        PKG_CHECK_CMD=("rpm" "-q")
        PKG_UPDATE_CMD=("true")
        PKG_INSTALL_CMD=("dnf" "install" "-y")
    elif command -v yum >/dev/null 2>&1; then
        PKG_CHECK_CMD=("rpm" "-q")
        PKG_UPDATE_CMD=("true")
        PKG_INSTALL_CMD=("yum" "install" "-y")
    elif command -v pacman >/dev/null 2>&1; then
        PKG_CHECK_CMD=("pacman" "-Qq")
        PKG_UPDATE_CMD=("pacman" "-Sy")
        PKG_INSTALL_CMD=("pacman" "-S" "--noconfirm")
    elif command -v apk >/dev/null 2>&1; then
        PKG_CHECK_CMD=("apk" "info" "-e")
        PKG_UPDATE_CMD=("apk" "update")
        PKG_INSTALL_CMD=("apk" "add")
    else
        log "ERROR" "Unsupported package management tool." >&2
        exit 1
    fi
}

is_installed() {
    "${PKG_CHECK_CMD[@]}" "$1" >/dev/null 2>&1
}

# Execution Pipeline
main() {
    detect_package_manager

    local missing_packages=()

    for pkg in "${READONLY_PACKAGES[@]}"; do
        if is_installed "$pkg"; then
            log "INFO" "Package '$pkg' is already installed."
        else
            log "WARN" "Package '$pkg' is missing."
            missing_packages+=("$pkg")
        fi
    done

    if (( ${#missing_packages[@]} == 0 )); then
        log "INFO" "All required packages are satisfied."
        exit 0
    fi

    log "INFO" "Missing packages to provision: ${missing_packages[*]}"

    if (( DRY_RUN == 1 )); then
        log "INFO" "[DRY-RUN] Would run update: ${PKG_UPDATE_CMD[*]}"
        log "INFO" "[DRY-RUN] Would run install: ${PKG_INSTALL_CMD[*]} ${missing_packages[*]}"
        exit 0
    fi

    log "INFO" "Updating repository metadata..."
    "${PKG_UPDATE_CMD[@]}" >/dev/null 2>&1 || {
        log "ERROR" "Failed to update package repositories." >&2
        exit 1
    }

    log "INFO" "Executing batch package installation..."
    if "${PKG_INSTALL_CMD[@]}" "${missing_packages[@]}"; then
        log "INFO" "Successfully provisioned missing packages."
    else
        log "ERROR" "Package installation process failed." >&2
        exit 1
    fi
}

main "$@"