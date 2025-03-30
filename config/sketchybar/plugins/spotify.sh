#!/bin/sh

# Get Spotify information using AppleScript
SPOTIFY_INFO=$(osascript -e 'if application "Spotify" is running then
  tell application "Spotify"
    if player state is playing then
      set currentTrack to name of current track
      set currentArtist to artist of current track
      return currentArtist & " @ " & currentTrack
    else
      return "Paused"
    end if
  end tell
else
  return "Not playing"
end if')

# Update sketchybar
sketchybar --set $NAME label="$SPOTIFY_INFO"

# Handle click to toggle play/pause
if [ "$BUTTON" = "left" ]; then
  osascript -e 'tell application "Spotify" to playpause'
fi
