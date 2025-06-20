#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the top bar
polybar top -c ~/.config/polybar/config.ini &

# Launch the bottom bar
polybar bottom -c ~/.config/polybar/config.ini &

echo "Polybar launched..."
