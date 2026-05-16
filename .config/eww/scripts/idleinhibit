#!/usr/bin/env sh
set -eu

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/eww-idle-inhibit.pid"

is_running() {
  [ -f "$PIDFILE" ] || return 1
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  [ -n "${pid:-}" ] || return 1
  kill -0 "$pid" 2>/dev/null
}

start_inhibit() {
  # Blocks "idle" while this process is alive.
  # sleep infinity is effectively zero-overhead.
  systemd-inhibit \
    --what=idle \
    --who="eww" \
    --why="manual idle inhibit from eww" \
    --mode=block \
    sh -c 'trap "exit 0" TERM INT; sleep infinity' >/dev/null 2>&1 &
  echo "$!" > "$PIDFILE"
  eww update idle_inhibit=true
}

stop_inhibit() {
  if is_running; then
    kill "$(cat "$PIDFILE")" 2>/dev/null || true
  fi
  rm -f "$PIDFILE"
  eww update idle_inhibit=false
}

cmd="${1:-toggle}"

case "$cmd" in
  status)
    if is_running; then echo "true"; else echo "false"; fi
    ;;
  start)
    start_inhibit
    ;;
  stop)
    stop_inhibit
    ;;
  toggle|*)
    if is_running; then
      stop_inhibit
    else
      start_inhibit
    fi
    ;;
esac