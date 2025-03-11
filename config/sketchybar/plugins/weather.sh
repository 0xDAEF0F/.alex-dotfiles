sketchybar --set $NAME \
  label="Loading..." \

WEATHER_JSON=$(curl -s "https://wttr.in?format=j1")

if [ -z $WEATHER_JSON ]; then
  sketchybar --set $NAME label="$LOCATION"
  return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq '.current_condition[0].temp_C' | tr -d '"')

sketchybar --set $NAME \
  label="$TEMPERATURE$(echo '°')C • "
