#!/bin/sh

COINS_INFO=$($HOME/.local/bin/prices info hype)

HYPE_PRICE=$(echo $COINS_INFO | jq -r '.[0].price')
HYPE_CHANGE=$(echo $COINS_INFO | jq -r '.[0].one_day_change_pct')

sketchybar --set $NAME label="\$$HYPE_PRICE $HYPE_CHANGE%"



