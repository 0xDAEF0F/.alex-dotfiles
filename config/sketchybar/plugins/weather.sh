sketchybar --set $NAME \
  label="Loading..." \

LOCATION="Ciudad Juárez"
REGION="Mexico"
LANG="en"

LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?0pq&format=j1&lang=$LANG")

if [ -z $WEATHER_JSON ]; then
  sketchybar --set $NAME label="$LOCATION"
  return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq '.current_condition[0].temp_C' | tr -d '"')

sketchybar --set $NAME \
  label="$TEMPERATURE$(echo '°')C • "
