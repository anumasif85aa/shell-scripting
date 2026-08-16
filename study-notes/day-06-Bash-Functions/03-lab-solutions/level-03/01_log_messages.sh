#!/bin/bash

# Task 1: Log message functions

log_info()
{
    echo "[INFO] $*"
}

log_error()
{
    echo "[ERROR] $*" >&2
}

log_info "Application check started"
log_error "Practice error message"

