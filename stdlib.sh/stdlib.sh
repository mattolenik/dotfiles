# Note: POSIX doesn't define local, so either define functions with subshells
# or mangle the variable names to make them sufficiently unique.

println() {
  # shellcheck disable=SC2059
  printf "%s\\n" "$*"
}

# Like printf but outputs to stderr
errorf() {
  # shellcheck disable=SC2059
  printf "$@" >&2
}

# Like println but outputs to stderr
errorln() {
  # shellcheck disable=SC2059
  printf "%s\\n" "$*" >&2
}

# Prints a message and exits
# 1: exit code
# 2: message to print to stderr
exitf() {
  __exitf_status_code="$1" && shift
  # shellcheck disable=SC2059
  printf "$@" >&2
  exit "$__exitf_status_code"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

