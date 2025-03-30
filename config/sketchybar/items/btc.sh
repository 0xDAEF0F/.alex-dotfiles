#!/bin/bash

btc=(
    icon="₿"
    icon.font="$FONT:Bold:14.0"
    icon.color="$ICON_COLOR"
    label.padding_left=4
    padding_right=5
    padding_left=5
    update_freq=60
    script="$PLUGIN_DIR/btc.sh"
)

sketchybar --add item btc right \
    --set btc "${btc[@]}"
