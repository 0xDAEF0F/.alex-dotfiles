#!/bin/sh

COINS_INFO=$($HOME/.local/bin/prices info btc)

BTC_PRICE=$(echo "$COINS_INFO" | jq -r '.[0].price | ((tonumber/1000) * 10 | round) / 10 | tostring + "k"')
BTC_CHANGE=$(echo $COINS_INFO | jq -r '.[0].one_day_change_pct')

sketchybar --set $NAME label="\$$BTC_PRICE $BTC_CHANGE%"



