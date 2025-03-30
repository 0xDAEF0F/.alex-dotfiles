#!/bin/bash

# Get the Bitcoin price
source ~/.bashrc

PRICES=$(btc-price)

BTC_PRICE=$(echo $PRICES | jq ".btc.priceAbbr" | sed 's/"//g')
BTC_PRICE_CHANGE=$(echo $PRICES | jq ".btc.priceChangePct")

SOL_PRICE=$(echo $PRICES | jq ".sol.price")
SOL_PRICE_CHANGE=$(echo $PRICES | jq ".sol.priceChangePct")

if [ -n "$BTC_PRICE" ]; then
    # Format with % sign and color based on positive/negative
    if [[ $BTC_PRICE_CHANGE == -* ]]; then
        # For negative values - red color
        PERCENT_COLOR=0xFFE57373
    else
        # For positive values - green color
        PERCENT_COLOR=0xFF4BFF4B
    fi

    # Set the price with default color
    sketchybar --set btc label="$BTC_PRICE /"

    # Set the percentage with colored text
    sketchybar --set btc.percent label="$BTC_PRICE_CHANGE%" \
        label.color=$PERCENT_COLOR \
        icon.drawing=off \
        padding_left=0 \
        label.padding_left=0
else
    # For error state
    echo "Error getting BTC price" >>/tmp/sketchybar_btc_debug.log
    sketchybar --set btc icon="₿" label="Error" label.color=0xFFFF0000
    sketchybar --remove btc.percent 2>/dev/null || true
fi
