#!/bin/bash

# Demonstrate separate output and error streams.

echo "Starting health check"
echo "Practice warning: service unavailable" >&2
exit 1

