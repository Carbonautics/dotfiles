#!/usr/bin/env bash

# dependencies: wpctl, awk, sed, notify-send (optional)

get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

is_mute() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED
}

volume_up() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
}

volume_down() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
}

toggle_mute() {
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

send_notification() {
  volume=$(get_volume)
  if is_mute; then
    notify-send -t 1000 -u low "Volume muted"
  else
    notify-send -t 1000 -u low "Volume: ${volume}%"
  fi
}

case "$1" in
  up)
    volume_up
    send_notification
    ;;
  down)
    volume_down
    send_notification
    ;;
  mute)
    toggle_mute
    send_notification
    ;;
  status)
    if is_mute; then
      echo ""
    else
      vol=$(get_volume)
      echo "$vol%"
    fi
    ;;
  *)
    echo "Usage: $0 {up|down|mute|status}"
    exit 1
    ;;
esac
