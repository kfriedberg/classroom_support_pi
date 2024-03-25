#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

. $SOURCEDIR/classroom_support_pi.conf

xset s off
xset s noblank
xset -dpms
unclutter -idle 0.5 -root &

MAC=$(ip -o link show dev eth0 | grep -Po 'ether \K[^ ]*')

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/$USER/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/$USER/.config/chromium/Default/Preferences

if command -v chromium-browser >/dev/null 2>&1; then
  chromium-browser --noerrdialogs --disable-infobars --no-first-run --kiosk --app=$HOST/local/roomsupport/client/?mac=$MAC
else
  chromium --noerrdialogs --disable-infobars --no-first-run --kiosk --app=$HOST/local/roomsupport/client/?mac=$MAC
fi
