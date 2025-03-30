#!/bin/bash

btc=(
    icon="₿"
    icon.font="$FONT:Bold:14.0"
    icon.color="$ICON_COLOR"
    label.padding_left=4
    padding_left=5
    update_freq=60
    script="$PLUGIN_DIR/btc.sh"
)

# btc_bracket=(
#     background.color=0xFFFFFF
# )

# sketchybar --add bracket btc_bracket btc btc.percent \
#     --set btc_bracket "${btc_bracket[@]}"

# Add the btc.percent item
sketchybar --add item btc.percent right

# Add the main btc item
sketchybar --add item btc right \
    --set btc "${btc[@]}"
