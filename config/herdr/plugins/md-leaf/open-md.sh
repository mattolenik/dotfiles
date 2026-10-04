#!/bin/sh
# Opens a clicked file:// markdown link in leaf in a new split to the right
# of the pane that was clicked.
set -eu
herdr=${HERDR_BIN_PATH:-herdr}
url=${HERDR_PLUGIN_CLICKED_URL:?no clicked url}

# file://host/path#frag?q, vscode://file/path:line:col or
# http://md.localhost/path (Codex only links http URLs) -> /path, percent-decoded
case $url in
  file://*) path=${url#file://} ;;
  http://md.localhost/*|https://md.localhost/*) path=${url#*://md.localhost} ;;
  *://file/*) path=${url#*://file} ;;
  *) echo "md-leaf: unsupported url: $url" >&2; exit 1 ;;
esac
path=/${path#*/}
path=${path%%#*}
path=${path%%\?*}
path=$(printf '%s' "$path" | sed -E 's/(:[0-9]+){1,2}$//')
path=$(printf '%b' "$(printf '%s' "$path" | sed 's/%/\\x/g')")

[ -f "$path" ] || { echo "md-leaf: not a file: $path" >&2; exit 1; }

src=${HERDR_PANE_ID:-}
new=$("$herdr" pane split ${src:+--pane "$src"} --direction right --focus \
  --cwd "$(dirname "$path")" | jq -r '.result.pane.pane_id')

quoted=$(printf "'%s'" "$(printf '%s' "$path" | sed "s/'/'\\\\''/g")")
# exec so the pane closes when leaf quits
"$herdr" pane run "$new" "exec leaf --watch $quoted"
