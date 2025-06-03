#!/bin/sh

COINS_INFO=$($HOME/.local/bin/prices info sol)

SOL_PRICE=$(echo $COINS_INFO | jq -r '.[0].price | tonumber | round')
SOL_CHANGE=$(echo $COINS_INFO | jq -r '.[0].one_day_change_pct')

sketchybar --set $NAME label="\$$SOL_PRICE $SOL_CHANGE%"



