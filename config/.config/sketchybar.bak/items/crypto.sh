#!/bin/bash

btcPct=(
    icon.padding_left=0
    icon.padding_right=0
    label.padding_left=0
    label.padding_right=6
)

sketchybar --add item btcPct right \
    --set btcPct "${btcPct[@]}"

btc=(
    icon="₿"
    icon.font="$FONT:Bold:14.0"
    icon.padding_left=6
    icon.color="$ICON_COLOR"
    label.padding_right=0
    background.padding_right=0
    update_freq=120
    script="$PLUGIN_DIR/btc.sh"
)

# Add the main btc item
sketchybar --add item btc right \
    --set btc "${btc[@]}"

btc_bracket=(
    background.color=$BACKGROUND_1
)

sketchybar --add bracket btc_bracket btc btcPct \
    --set btc_bracket "${btc_bracket[@]}"


# Now for solana
sketchybar --add item solanaPct right \
    --set solanaPct "${btcPct[@]}"

sketchybar --add item solana right \
    --set solana icon="󰰣" \
        icon.font="$FONT:Bold:14.0" \
        icon.padding_left=6 \
        icon.color="$ICON_COLOR" \
        label.padding_right=0 \
        background.padding_right=0

sketchybar --add bracket solana_bracket solana solanaPct \
     --set solana_bracket "${btc_bracket[@]}"
