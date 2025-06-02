#!/bin/sh


BTC_INFO=$($HOME/.local/bin/prices info btc)

BTC_PRICE=$(echo "$BTC_INFO" | jq -r '.[0].price | tonumber | floor')
BTC_CHANGE=$(echo "$BTC_INFO" | jq -r '.[0].one_day_change_pct | tonumber | . * 100 | round | . * 0.01')

LABEL="${BTC_PRICE} ${BTC_CHANGE}%"

sketchybar --set "$NAME" label="$LABEL"
