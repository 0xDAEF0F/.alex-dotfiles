#!/bin/sh

# load dotenv
if [ -f "$HOME/.env" ]; then
   . "$HOME/.env"
fi

QUOTA_DATA=$($HOME/.local/bin/cursor_quota)

# Extract premium and free request counts using jq
PREMIUM_REQS=$(echo "$QUOTA_DATA" | jq -r '.premium_reqs.numRequestsTotal')
MAX_PREMIUM_REQS=$(echo "$QUOTA_DATA" | jq -r '.premium_reqs.maxRequestUsage')

LABEL="${PREMIUM_REQS}/${MAX_PREMIUM_REQS}"

sketchybar --set "$NAME" label="$LABEL"
