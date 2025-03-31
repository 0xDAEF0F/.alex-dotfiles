#!/bin/sh

# Create a custom event for Spotify track changes
sketchybar --add event spotify_change com.spotify.client.PlaybackStateChanged

# Create an item for spotify and subscribe to events
sketchybar --add item spotify right \
    --set spotify \
    label="No music playing" \
    background.color=$BACKGROUND_1 \
    background.corner_radius=5 \
    background.drawing=on \
    background.padding_right=10 \
    icon=󰓃 \
    icon.color=$ICON_COLOR \
    icon.padding_left=10 \
    label.align=center \
    label.padding_right=10 \
    label.scroll_texts=on \
    label.max_chars=22 \
    label.scroll_duration=200 \
    script="$CONFIG_DIR/plugins/spotify.sh" \
    --subscribe spotify spotify_change mouse.clicked
