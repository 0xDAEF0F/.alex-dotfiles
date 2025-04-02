#!/bin/bash

# Get the Bitcoin price
source ~/.bashrc

PRICES=$(crypto-prices)

BTC_PRICE=$(echo $PRICES | jq ".btc.priceAbbr" | sed 's/"//g')
BTC_PRICE_CHANGE=$(echo $PRICES | jq ".btc.priceChangePct")

SOL_PRICE=$(echo $PRICES | jq ".sol.price")
SOL_PRICE_CHANGE=$(echo $PRICES | jq ".sol.priceChangePct")

if [ -n "$BTC_PRICE" ]; then
    # Format with % sign and color based on positive/negative
    if [[ $BTC_PRICE_CHANGE == -* ]]; then
        # For negative values - red color
        BTC_PERCENT_COLOR=0xFFE57373
    else
        # For positive values - green color
        BTC_PERCENT_COLOR=0xffa6da95
    fi

    if [[ $SOL_PRICE_CHANGE == -* ]]; then
        # For negative values - red color
        SOL_PERCENT_COLOR=0xFFE57373
    else
        # For positive values - green color
        SOL_PERCENT_COLOR=0xffa6da95
    fi

    # Set the price with default color
    sketchybar --set btc label="$BTC_PRICE/"
    sketchybar --set solana label="\$$SOL_PRICE/"

    # Set the percentage with colored text
    sketchybar --set btcPct label="$BTC_PRICE_CHANGE%" \
        label.color=$BTC_PERCENT_COLOR
    sketchybar --set solanaPct label="$SOL_PRICE_CHANGE%" \
        label.color=$SOL_PERCENT_COLOR
else
    # For error state
    echo "Error getting BTC price" >>/tmp/sketchybar_btc_debug.log
    sketchybar --set btc icon="₿" label="Error" label.color=0xFFFF0000
    sketchybar --remove btcPct
fi
