#!/bin/bash

# Get the Bitcoin price
source ~/.bashrc

BTC_PRICE=$(btc-price)

if [ -n "$BTC_PRICE" ]; then
    # Format with % sign and color based on positive/negative
    if [[ $BTC_PRICE == -* ]]; then
        # For negative values
        sketchybar --set btc icon="₿" label="${BTC_PRICE}%" label.color=0xFFE57373
    else
        # For positive values
        sketchybar --set btc icon="₿" label="+${BTC_PRICE}%" label.color=0xFF4BFF4B
    fi
else
    # For error state
    echo "Error getting BTC price" >>/tmp/sketchybar_btc_debug.log
    sketchybar --set btc icon="₿" label="Error" label.color=0xFFFF0000
fi
