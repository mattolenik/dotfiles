#!/bin/zsh
# Sticky pane resize for a herdr popup: resizes the active pane once in the
# given direction, then keeps resizing on arrow keys / hjkl until Esc, q or Enter.
# A step is a percentage of the split ("3%") or a number of terminal cells
# (columns or rows, "1"). Shift+arrow / HJKL always step by 1 cell; plain keys
# use the starting step.
# usage: resize-mode.zsh <left|right|up|down> [step]
herdr=${HERDR_BIN_PATH:-herdr}
pane=${HERDR_ACTIVE_PANE_ID:?no active pane}
step=${2:-3%}
fine=1

layout() { "$herdr" pane layout --pane "$pane" 2>/dev/null }

# resize <direction> [step]
#
# A percentage step is passed straight to herdr as a ratio delta. For a cell
# step: herdr only resizes by a ratio delta, and a split's divider sits at
# round(size * ratio), so a fixed fraction doesn't always move a whole cell.
# Nudge by a fraction that can't overshoot, see which split moved, then top it
# up to land the divider exactly N cells from where it started.
resize() {
  local nav=$1 n=${2:-$step} axis sdir grows before after area extra
  if [[ $n == *% ]]; then
    "$herdr" pane resize --direction "$nav" --amount $(( ${n%\%} / 100.0 )) --pane "$pane" >/dev/null 2>&1
    return
  fi
  case $nav in
    left|right) axis=width; sdir=right ;;
    up|down) axis=height; sdir=down ;;
  esac
  [[ $nav == right || $nav == down ]] && grows=true || grows=false
  before=$(layout) || return
  area=$(jq -r ".result.layout.area.$axis" <<<"$before")
  (( area > 0 )) || return
  "$herdr" pane resize --direction "$nav" --amount $(( n / (area * 1.0) )) --pane "$pane" >/dev/null 2>&1 || return
  after=$(layout) || return
  extra=$(jq -rn --argjson b "$before" --argjson a "$after" \
    --arg axis "$axis" --arg sdir "$sdir" --argjson n "$n" --argjson grows "$grows" '
    ($b.result.layout.splits | map({key: .id, value: .ratio}) | from_entries) as $old
    | [$a.result.layout.splits[]
        | select(.direction == $sdir and $old[.id] != null and .ratio != $old[.id])][0]
    | if . == null then 0 else
        .rect[$axis] as $size
        | ($old[.id] * $size + 0.5 | floor) as $pos
        | ((if $grows then $pos + $n else $pos - $n end) / $size) as $target
        | if $grows then $target - .ratio else .ratio - $target end
      end')
  (( extra > 1e-6 )) && "$herdr" pane resize --direction "$nav" --amount "$extra" --pane "$pane" >/dev/null 2>&1
}

[[ -n $1 ]] && resize "$1"
print -n '\e[?25l'
print -n 'resize: ←↓↑→ / hjkl · esc or enter to exit'
while read -sk1 key; do
  case $key in
    $'\e')
      # A lone Esc exits. Arrows arrive as Esc [ A..D or Esc O A..D; modified
      # arrows carry parameters first, e.g. Shift+Up is Esc [ 1 ; 2 A.
      read -sk1 -t 0.05 intro || break
      [[ $intro == '[' || $intro == O ]] || continue
      params=''
      while read -sk1 -t 0.05 key && [[ $key == [0-9\;] ]]; do params+=$key; done
      n=$step
      [[ $params == *\;2 ]] && n=$fine
      case $key in
        A) resize up $n ;; B) resize down $n ;;
        C) resize right $n ;; D) resize left $n ;;
      esac ;;
    h) resize left ;; j) resize down ;; k) resize up ;; l) resize right ;;
    H) resize left $fine ;; J) resize down $fine ;; K) resize up $fine ;; L) resize right $fine ;;
    q|$'\n'|$'\r') break ;;
  esac
done
