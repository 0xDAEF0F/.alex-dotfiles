#!/bin/bash

output=$(tmux-mem-cpu-load) # Example output: "13/64GB [          ]   7.7% 3.22 3.26 3.07"

# 13/64GB
mem=$(echo "$output" | awk '{print $1}')

# 7.7%
cpu=$(echo "$output" | awk '{print $4}')

sketchybar --set cpu label="$cpu"
sketchybar --set ram label="$mem"
