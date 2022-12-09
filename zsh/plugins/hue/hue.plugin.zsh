# vi: ft=zsh

warn() {
  print -P "$(pcolor WARNING: yellow none bold) $*"
}

error() {
  print -P "$(pcolor ERROR: red none bold) $*"
}

color() {
  print -nP "$(pcolor $@)"
}

acc() {
  print -n "$(pcolor "$*" green none)"
}

acc2() {
  print -n "$(pcolor "$*" blue none)"
}

cau() {
  print -n "$(pcolor "$*" yellow none)"
}

faint() {
  print -n "$(pcolor "$*" 8 none)"
}

faintacc() {
  print -n "$(pcolor "$*" 5 none)"
}

vfaint() {
  print -n "$(pcolor "$*" '#333333' none)"
}

pcolor() {
  local str=$1
  local fg=$2
  local bg=$3
  shift 3
  local attrs=$@
  local prefix="%F{$fg}"
  local suffix="%f"
  if [[ $bg != clear && $bg != none ]]; then
    prefix="$prefix%K{$bg}"
    suffix="%k$suffix"
  fi
  if (( attrs[(Ie)bold] )); then
    prefix="$prefix%B"
    suffix="%b$suffix"
  fi
  if (( attrs[(Ie)ul] )); then
    prefix="$prefix%U"
    suffix="%u$suffix"
  fi
  if (( attrs[(Ie)hl] )); then
    prefix="$prefix%S"
    suffix="%s$suffix"
  fi
  if (( attrs[(Ie)italic] )); then
    prefix="$prefix"'\e[3m'
    suffix='\e[0m'"$suffix"
  fi
  if (( attrs[(Ie)st] )); then
    prefix="$prefix"'\e[9m'
    suffix='\e[0m'"$suffix"
  fi
  print -n "%{$prefix%}$str%{$suffix%}"
}

