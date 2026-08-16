#!/bin/bash

: "${DEPLOY_APP:?DEPLOY_APP is required}"
: "${DEPLOY_ENV:?DEPLOY_ENV is required}"
: "${DEPLOY_OWNER:?DEPLOY_OWNER is required}"

echo "Application: $DEPLOY_APP"
echo "Environment: $DEPLOY_ENV"
echo "Owner: $DEPLOY_OWNER"
echo "Required variables are available."
