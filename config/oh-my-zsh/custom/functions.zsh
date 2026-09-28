# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function show_colors {
  echo -e "$COL_GREEN COL_GREEN $COL_RESET"
  echo -e "$COL_RED COL_RED $COL_RESET"
  echo -e "$COL_YELLOW COL_YELLOW $COL_RESET"
  echo -e "$COL_BLUE COL_BLUE $COL_RESET"
  echo -e "$COL_MAGENTA COL_MAGENTA $COL_RESET"
  echo -e "$COL_CYAN COL_CYAN $COL_RESET"
}

function git_branch_name {
  val=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
  echo "$val"
}

function rrg {
  rake routes | grep $1
}

function chrome() {
  "$HOME/.config/zsh/scripts/chrome-session.sh" "$@"
}

function parse_git_branch {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function gbin {
  echo branch \($1\) has these commits and \($(parse_git_branch)\) does not
  git log ..$1 --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}

function gbout {
  echo branch \($(parse_git_branch)\) has these commits and \($1\) does not
  git log $1.. --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}

function box() {
  t="$1xxxx"
  c=${2:-=}
  echo ${t//?/$c}
  echo "$c $1 $c"
  echo ${t//?/$c}
}

# just puts the branch in the commit, lame
# function gjc {
#     echo
#     echo "==============================================================================="
#     echo "Your Commit Message: $(g rev-parse --abbrev-ref HEAD) - $1"
#     echo "==============================================================================="
#     echo
#     g commit -m "$(g rev-parse --abbrev-ref HEAD) - $1"
#     g commit --amend
# }

function st {
  echo -ne "\e]1;$1\a"
}

function paver {
  while true; do
    for i in 02E{{9..5},{6..8}}; do
      printf "\u${i}O=o>"
      sleep 0.09
      printf "\b\b\b\b\b"
    done
    printf "_"
  done
}

function french {
  t=$(($(tput cols) / 3))
  for FR in $(seq $(tput lines)); do
    printf "\e[44m%${t}s\e[47m%${t}s\e[41m%${t}s\e[0m\n"
  done
}

function tab_color {
  case $1 in
    green)
      echo -e "\033]6;1;bg;red;brightness;57\a"
      echo -e "\033]6;1;bg;green;brightness;197\a"
      echo -e "\033]6;1;bg;blue;brightness;77\a"
      ;;
    red)
      echo -e "\033]6;1;bg;red;brightness;270\a"
      echo -e "\033]6;1;bg;green;brightness;60\a"
      echo -e "\033]6;1;bg;blue;brightness;83\a"
      ;;
    orange)
      echo -e "\033]6;1;bg;red;brightness;227\a"
      echo -e "\033]6;1;bg;green;brightness;143\a"
      echo -e "\033]6;1;bg;blue;brightness;10\a"
      ;;
    blue)
      echo -e "\033]6;1;bg;red;brightness;30\a"
      echo -e "\033]6;1;bg;green;brightness;120\a"
      echo -e "\033]6;1;bg;blue;brightness;255\a"
      ;;
    purple)
      echo -e "\033]6;1;bg;red;brightness;150\a"
      echo -e "\033]6;1;bg;green;brightness;60\a"
      echo -e "\033]6;1;bg;blue;brightness;200\a"
      ;;
    reset)
      echo -e "\033]6;1;bg;*;default\a"
      ;;
  esac
}

# zsh hook for all directory changes
chpwd() {
  local pwd="$PWD"
  case "$pwd" in
    $HOME/Workspace/*)
      local project="${${pwd#$HOME/Workspace/}%%/*}"
      st "workspace/${project}"
      tab_color blue
      ;;
    $HOME/Workspace)
      st "workspace"
      tab_color blue
      ;;
    $HOME/Personal/*)
      local project="${${pwd#$HOME/Personal/}%%/*}"
      st "personal/${project}"
      tab_color purple
      ;;
    $HOME/Personal)
      st "personal"
      tab_color purple
      ;;
    *)
      st "${pwd##*/}"
      tab_color reset
      ;;
  esac
}

function gjc() {
  local branches_to_skip=(master dev develop)
  local branch_name=$(git symbolic-ref --short HEAD)
  branch_name="${branch_name##*/}"
  local branch_excluded=$(printf "%s\n" "${branches_to_skip[@]}" | grep -c "^$branch_name$")
  local branch_jira_key=$(echo "$branch_name" | grep -E -o '^([A-Za-z]+-[0-9]+)')

  if ! [[ $branch_excluded -eq 1 ]] && ! [[ $(cat "$1") == "$branch_jira_key"* ]] && [[ -n "$branch_jira_key" ]]; then
    echo "$branch_jira_key $(cat "$1")" >"$1"
  fi
}

function cal-today() {
  "$HOME/.config/zsh/scripts/cal-today.sh" "$@"
}

function cal-on() {
  "$HOME/.config/zsh/scripts/cal-on.sh" "$@"
}

function cal-upcoming() {
  "$HOME/.config/zsh/scripts/cal-upcoming.sh" "$@"
}

# Hazel rule builder - interactive setup for common automation rules
function hazel-setup() {
  if [ ! -f "$HOME/.config/zsh/hazel-rule-builder.sh" ]; then
    echo "Error: Hazel rule builder script not found"
    return 1
  fi
  bash "$HOME/.config/zsh/hazel-rule-builder.sh"
}

function rem-show() {
  if [ -z "$1" ]; then
    reminders show
  else
    reminders show "$1"
  fi
}

function rem-add() {
  "$HOME/.config/zsh/scripts/rem-add.sh" "$@"
}

function rem-done() {
  "$HOME/.config/zsh/scripts/rem-done.sh" "$@"
}

function rem-delete() {
  "$HOME/.config/zsh/scripts/rem-delete.sh" "$@"
}

function cal-delete() {
  "$HOME/.config/zsh/scripts/cal-delete.sh" "$@"
}

function cal-delete-pattern() {
  "$HOME/.config/zsh/scripts/cal-delete-pattern.sh" "$@"
}

function cal-create-recurring() {
  "$HOME/.config/zsh/scripts/cal-create-recurring.sh" "$@"
}

function cal-count() {
  "$HOME/.config/zsh/scripts/cal-count.sh" "$@"
}

claude-protect() {
  local target="${1:-.claude}"
  if [[ ! -d "$target" ]]; then
    echo "Directory $target does not exist"
    return 1
  fi
  if [[ -d "$target/.git" ]]; then
    echo "Already protected: $target"
    return 0
  fi
  (
    cd "$target"
    git init
    git add -A
    git commit -m "Initial protection snapshot"
  )
  echo "Protected: $target"
}

claude-protect-all() {
  local workspace="${WORKSPACE_ROOT:-$HOME/Workspace}"
  for dir in "$workspace"/*/.claude; do
    [[ -d "$dir" ]] || continue
    echo "--- $(dirname "$dir" | xargs basename) ---"
    claude-protect "$dir"
  done
}

claude-protect-status() {
  local workspace="${WORKSPACE_ROOT:-$HOME/Workspace}"
  for dir in "$workspace"/*/.claude; do
    [[ -d "$dir/.git" ]] || continue
    local project=$(dirname "$dir" | xargs basename)
    local changes=$(git -C "$dir" status --porcelain 2>/dev/null)
    if [[ -n "$changes" ]]; then
      echo "DIRTY: $project"
      echo "$changes" | sed 's/^/  /'
    else
      echo "CLEAN: $project"
    fi
  done
}

if (($+functions[command_not_found_handler])); then
  functions[_original_command_not_found_handler]=$functions[command_not_found_handler]
fi

command_not_found_handler() {
  local log_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >>"$log_dir/command-not-found.log"
  if (($+functions[_original_command_not_found_handler])); then
    _original_command_not_found_handler "$@"
  else
    echo "zsh: command not found: $1" >&2
    return 127
  fi
}

function git_private_indicator() {
  command -v gh &>/dev/null || return
  local remote_url
  remote_url=$(git config --get remote.origin.url 2>/dev/null) || return
  [[ "$remote_url" == *github.com* ]] || return

  local cache_dir="/tmp/gh-private-cache"
  local cache_key=$(echo -n "$remote_url" | md5)
  local cache_file="$cache_dir/$cache_key"

  if [[ -f "$cache_file" ]]; then
    local cache_age=$(($(date +%s) - $(stat -f %m "$cache_file")))
    if ((cache_age < 3600)); then
      cat "$cache_file"
      return
    fi
  fi

  mkdir -p "$cache_dir"
  {
    local is_private
    is_private=$(gh repo view --json isPrivate --jq .isPrivate 2>/dev/null)
    if [[ "$is_private" == "true" ]]; then
      printf '🔒' >"$cache_file"
    else
      printf '' >"$cache_file"
    fi
  } &|
}

add-sidekiq-container() {
  local compose_dir="$HOME/Workspace/tabz-dev-tools"
  local current
  current=$(docker compose -f "$compose_dir/compose.yml" -f "$compose_dir/compose.override.yml" ps -q sidekiq | wc -l | tr -d ' ')
  local new_count=$((current + 1))
  docker compose -f "$compose_dir/compose.yml" -f "$compose_dir/compose.override.yml" up -d --scale sidekiq="$new_count" --no-recreate
  echo "Sidekiq scaled: $current -> $new_count"
}

_check_port_usage() {
  echo "usage: check-port [-k] [port]"
  echo "  (no port)  list every listening TCP and UDP port"
  echo "  port       report what is holding that port"
  echo "  -k         prompt to kill the process holding the port"
}

_check_port_header() {
  if [[ -t 1 ]]; then
    echo -e "${COL_CYAN}$1${COL_RESET}"
  else
    echo "$1"
  fi
}

_check_port_squeeze() {
  local -a words
  words=(${=1})
  echo "${words[*]}"
}

_check_port_lsof_rows() {
  local line pid cmd login proto name state
  local -a rows=()

  while IFS= read -r line; do
    case "$line" in
      p*)
        [[ -n "$name" ]] && rows+=("${proto:-?}|${name}|${state:-n/a}|${pid}|${cmd}|${login}")
        proto="" name="" state=""
        pid="${line#p}"
        ;;
      c*)
        cmd="${line#c}"
        ;;
      L*)
        login="${line#L}"
        ;;
      f*)
        [[ -n "$name" ]] && rows+=("${proto:-?}|${name}|${state:-n/a}|${pid}|${cmd}|${login}")
        proto="" name="" state=""
        ;;
      P*)
        proto="${line#P}"
        ;;
      n*)
        name="${line#n}"
        ;;
      TST=*)
        state="${line#TST=}"
        ;;
    esac
  done < <(lsof -nP "$@" -FpcLPnT 2>/dev/null)

  [[ -n "$name" ]] && rows+=("${proto:-?}|${name}|${state:-n/a}|${pid}|${cmd}|${login}")
  ((${#rows})) && printf '%s\n' "${rows[@]}"
  return 0
}

_check_port_netstat_rows() {
  local port="$1" proto
  for proto in tcp udp; do
    netstat -an -p "$proto" 2>/dev/null |
      awk -v want="$port" '{
        n = split($4, a, ".")
        if (n > 1 && a[n] == want) printf "%-7s %-26s %-26s %s\n", $1, $4, $5, $6
      }'
  done
  return 0
}

_check_port_process_detail() {
  local pid="$1" lsof_name="$2"
  local basics ppid user etime ucomm lstart binary fullcmd cwd parent line
  basics="$(ps -o ppid=,user=,etime=,ucomm= -p "$pid" 2>/dev/null)"

  if [[ -z "$basics" ]]; then
    echo "  PID $pid is no longer running."
    return 0
  fi

  IFS=' ' read -r ppid user etime ucomm <<<"$basics"
  lstart="$(_check_port_squeeze "$(ps -o lstart= -p "$pid" 2>/dev/null)")"
  binary="$(ps -o comm= -p "$pid" 2>/dev/null)"
  fullcmd="$(ps -o args= -p "$pid" 2>/dev/null)"
  parent="$(_check_port_squeeze "$(ps -o ucomm= -p "$ppid" 2>/dev/null)")"

  for line in ${(f)"$(lsof -a -d cwd -p "$pid" -Fn 2>/dev/null)"}; do
    [[ "$line" == n* ]] && {
      cwd="${line#n}"
      break
    }
  done

  printf '  %-9s: %s\n' "PID" "$pid"
  printf '  %-9s: %s\n' "Command" "${lsof_name:-$ucomm}"
  printf '  %-9s: %s\n' "User" "$user"
  printf '  %-9s: %s (elapsed %s)\n' "Started" "${lstart:-unknown}" "$etime"
  printf '  %-9s: %s (%s)\n' "Parent" "$ppid" "${parent:-unknown}"
  printf '  %-9s: %s\n' "Binary" "${binary:-unknown}"
  printf '  %-9s: %s\n' "CWD" "${cwd:-unavailable}"
  printf '  %-9s: %s\n' "Full cmd" "${fullcmd:-unknown}"
}

_check_port_list_all() {
  local raw row proto name state pid cmd login port
  local -a rows=() table=()

  raw="$(_check_port_lsof_rows -iTCP -sTCP:LISTEN)"
  [[ -n "$raw" ]] && rows+=("${(f)raw}")
  raw="$(_check_port_lsof_rows -iUDP)"
  [[ -n "$raw" ]] && rows+=("${(f)raw}")

  for row in "${rows[@]}"; do
    IFS='|' read -r proto name state pid cmd login <<<"$row"
    port="${name##*:}"
    [[ "$port" == <-> ]] || continue
    table+=("${port}|${proto}|${pid}|${cmd}|${login}")
  done

  if ((${#table} == 0)); then
    echo "No listening ports found."
    return 0
  fi

  _check_port_header "LISTENING PORTS"
  printf '  %-7s %-6s %-8s %-26s %s\n' PORT PROTO PID PROCESS USER
  printf '%s\n' "${table[@]}" | sort -u | sort -t'|' -k1,1n -s |
    while IFS='|' read -r port proto pid cmd login; do
      printf '  %-7s %-6s %-8s %-26s %s\n' "$port" "$proto" "$pid" "$cmd" "$login"
    done
}

_check_port_wait_for_exit() {
  local pid="$1" seconds="$2" i
  for ((i = 0; i < seconds * 10; i++)); do
    ps -p "$pid" >/dev/null 2>&1 || return 0
    sleep 0.1
  done
  return 1
}

_check_port_force_kill() {
  local pid="$1" reply

  print -n "  PID $pid ignored SIGTERM. force with SIGKILL? [y/N] "
  read -r -u 0 reply
  if [[ "$reply" != [yY]* ]]; then
    echo "  left $pid running"
    return 1
  fi

  if ! kill -9 "$pid" 2>/dev/null; then
    echo "  could not SIGKILL $pid. try: sudo kill -9 $pid"
    return 1
  fi

  if _check_port_wait_for_exit "$pid" 3; then
    echo "  $pid killed"
    return 0
  fi

  echo "  $pid survived SIGKILL. try: sudo kill -9 $pid"
  return 1
}

_check_port_kill_one() {
  local pid="$1" reply name
  name="$(_check_port_squeeze "$(ps -o ucomm= -p "$pid" 2>/dev/null)")"

  if [[ -z "$name" ]]; then
    echo "  PID $pid has already exited."
    return 0
  fi

  print -n "  kill PID $pid ($name)? [y/N] "
  read -r -u 0 reply
  if [[ "$reply" != [yY]* ]]; then
    echo "  skipped $pid"
    return 0
  fi

  if ! kill "$pid" 2>/dev/null; then
    echo "  could not signal $pid (operation not permitted). try: sudo kill $pid"
    return 1
  fi
  echo "  sent SIGTERM to $pid"

  if _check_port_wait_for_exit "$pid" 5; then
    echo "  $pid exited"
    return 0
  fi

  _check_port_force_kill "$pid"
}

_check_port_kill() {
  emulate -L zsh
  local port="$1"
  shift
  local -a pids=("$@")
  local pid

  ((${#pids})) || return 0

  _check_port_header "KILL"

  if [[ ! -t 0 ]]; then
    echo "  -k needs an interactive terminal; nothing was killed."
    return 1
  fi

  for pid in "${pids[@]}"; do
    _check_port_kill_one "$pid"
  done

  echo
  if [[ -n "$(_check_port_lsof_rows -i ":$port")" ]]; then
    echo "  Port $port is still in use."
    return 1
  fi

  echo "  Port $port is now free."
  return 0
}

check-port() {
  emulate -L zsh

  local kill_mode=0
  while [[ "$1" == -* ]]; do
    case "$1" in
      -k)
        kill_mode=1
        shift
        ;;
      -h | --help)
        _check_port_usage
        return 0
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "check-port: unknown option: $1" >&2
        _check_port_usage >&2
        return 2
        ;;
    esac
  done

  if (($# == 0)); then
    if ((kill_mode)); then
      echo "check-port: -k requires a port number" >&2
      return 2
    fi
    _check_port_list_all
    return 0
  fi

  local port="$1"
  if [[ "$port" != <-> ]] || ((port < 1 || port > 65535)); then
    echo "check-port: port must be a number from 1 to 65535 (got: $port)" >&2
    _check_port_usage >&2
    return 2
  fi

  local raw_lsof raw_net row proto name state pid cmd login
  local -a lsof_rows=() net_rows=() pids=()
  local -A pid_names=()

  raw_lsof="$(_check_port_lsof_rows -i ":$port")"
  raw_net="$(_check_port_netstat_rows "$port")"
  [[ -n "$raw_lsof" ]] && lsof_rows=("${(f)raw_lsof}")
  [[ -n "$raw_net" ]] && net_rows=("${(f)raw_net}")

  _check_port_header "PORT $port"
  echo

  if ((${#lsof_rows} == 0 && ${#net_rows} == 0)); then
    echo "  Nothing is listening on port $port."
    return 1
  fi

  if ((${#lsof_rows})); then
    _check_port_header "SOCKETS"
    for row in "${lsof_rows[@]}"; do
      IFS='|' read -r proto name state pid cmd login <<<"$row"
      printf '  %-5s %-30s %-10s pid %-8s %s\n' "$proto" "$name" "$state" "$pid" "$cmd"
      pids+=("$pid")
      pid_names[$pid]="$cmd"
    done
    pids=(${(u)pids})
    echo
  fi

  if ((${#net_rows})); then
    _check_port_header "NETSTAT"
    printf '  %s\n' "${net_rows[@]}"
    echo
  fi

  if ((${#lsof_rows} == 0)); then
    _check_port_header "OWNER"
    echo "  Port $port is in use, but the owning process is not visible to you."
    echo "  It is most likely owned by root or another user."
    echo "  To see it, run:"
    echo "    sudo lsof -nP -i :$port"
    echo
    return 0
  fi

  _check_port_header "PROCESS DETAIL"
  for pid in "${pids[@]}"; do
    _check_port_process_detail "$pid" "${pid_names[$pid]}"
    echo
  done

  ((kill_mode)) && _check_port_kill "$port" "${pids[@]}"

  return 0
}

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
