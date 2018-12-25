ACCESS_TOKEN_URL="https://accounts.spotify.com/api/token"
RECENTLY_PLAYED_URL="https://api.spotify.com/v1/me/player/recently-played"

set_spotify_access_token(){
  export ACCESS_TOKEN=$(curl -X POST $ACCESS_TOKEN_URL -d grant_type=refresh_token  -u $SPOTIFY_CLIENT_ID:$SPOTIFY_CLIENT_SECRET -d refresh_token=$SPOTIFY_REFRESH_TOKEN | jq -r '.access_token')
}

save_recent_played_songs(){
  set_spotify_access_token
  curl -X GET "${RECENTLY_PLAYED_URL}?limit=50" -H "Authorization: Bearer $ACCESS_TOKEN" > spotify_recently_played_$(date +'%s').json
}

pid=$(< ./spotify.sh.pid)
#state=[[ -n $pid ]] && ps -p $pid > /dev/null


if [[ -n $pid ]] && ps -p $pid > /dev/null
then
  echo "$pid is running"
   # Do something knowing the pid exists, i.e. the process with $PID is running
else
  while true;do
    save_recent_played_songs
    sleep 1500
  done &!
  echo $! > ./spotify.sh.pid
fi

