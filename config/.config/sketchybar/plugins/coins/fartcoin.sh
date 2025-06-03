#!/bin/sh

COINS_INFO=$($HOME/.local/bin/prices info fartcoin)

FARTCOIN_PRICE=$(echo "$COINS_INFO" | jq -r '.[0].price')
FARTCOIN_CHANGE=$(echo $COINS_INFO | jq -r '.[0].one_day_change_pct')

sketchybar --set $NAME label="\$$FARTCOIN_PRICE $FARTCOIN_CHANGE%"



