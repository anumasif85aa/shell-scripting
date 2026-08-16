#!/bin/bash

# Simulate common service actions with case.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 {start|stop|restart|status}" >&2
    exit 1
fi

case "$1" in
    start)
        echo "Service would be started."
        ;;
    stop)
        echo "Service would be stopped."
        ;;
    restart)
        echo "Service would be restarted."
        ;;
    status)
        echo "Service status would be checked."
        ;;
    *)
        echo "Error: unknown action: $1" >&2
        exit 1
        ;;
esac

