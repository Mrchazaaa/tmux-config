#!/usr/bin/env bash

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"
  local reply
  local suffix

  if [[ "$default" == "y" ]]; then
    suffix="[Y/n]"
  else
    suffix="[y/N]"
  fi

  while true; do
    read -r -p "$prompt $suffix " reply || return 1
    reply="${reply:-$default}"
    case "$reply" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]) return 1 ;;
      *) log "Please answer yes or no." ;;
    esac
  done
}

run_with_sudo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "This command needs root privileges, but sudo is not installed: $*"
  fi
}

install_packages() {
  local packages=("$@")

  if command -v apt-get >/dev/null 2>&1; then
    run_with_sudo apt-get update
    run_with_sudo apt-get install -y "${packages[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    run_with_sudo dnf install -y "${packages[@]}"
  elif command -v yum >/dev/null 2>&1; then
    run_with_sudo yum install -y "${packages[@]}"
  elif command -v pacman >/dev/null 2>&1; then
    run_with_sudo pacman -Sy --needed --noconfirm "${packages[@]}"
  elif command -v zypper >/dev/null 2>&1; then
    run_with_sudo zypper install -y "${packages[@]}"
  elif command -v brew >/dev/null 2>&1; then
    brew install "${packages[@]}"
  else
    die "No supported package manager found. Please install: ${packages[*]}"
  fi
}

ensure_command() {
  local command_name="$1"
  local package_name="${2:-$1}"
  local prompt="$3"

  if command -v "$command_name" >/dev/null 2>&1; then
    return 0
  fi

  log "$command_name is not installed."
  if ask_yes_no "$prompt"; then
    install_packages "$package_name"
  else
    die "$command_name is required to continue."
  fi

  command -v "$command_name" >/dev/null 2>&1 || die "$command_name installation did not complete successfully."
}

backup_file() {
  local path="$1"
  local timestamp

  if [[ ! -e "$path" && ! -L "$path" ]]; then
    return 0
  fi

  timestamp="$(date +%Y%m%d%H%M%S)"
  mv "$path" "$path.backup.$timestamp"
  log "Backed up $path to $path.backup.$timestamp"
}

write_file_if_changed() {
  local path="$1"
  local content="$2"
  local tmp

  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' RETURN
  printf '%s\n' "$content" > "$tmp"

  if [[ -f "$path" ]] && cmp -s "$tmp" "$path"; then
    log "$path is already up to date."
    rm -f "$tmp"
    trap - RETURN
    return 0
  fi

  backup_file "$path"
  mkdir -p "$(dirname "$path")"
  mv "$tmp" "$path"
  trap - RETURN
  log "Wrote $path"
}
