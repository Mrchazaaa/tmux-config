#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$HOME/.config/tmux"
repo_copy="$config_dir/tmux-config"
target="$config_dir/tmux.conf"
legacy="$HOME/.tmux.conf"

install_tmux() {
  command -v tmux >/dev/null 2>&1 && return

  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y tmux
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y tmux
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --needed tmux
  elif command -v brew >/dev/null 2>&1; then
    brew install tmux
  else
    printf 'Install tmux with your package manager, then rerun this script.\n' >&2
    exit 1
  fi
}

install_tmux

mkdir -p "$config_dir"

backup_if_present() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="$path.backup.$(date +%Y%m%d%H%M%S)"
    mv "$path" "$backup"
    printf 'Backed up %s to %s\n' "$path" "$backup"
  fi
}

backup_if_present "$repo_copy"
cp -R "$repo_dir" "$repo_copy"

write_source() {
  local path="$1" source="$2" line="source-file $2"
  if [[ -f "$path" ]] && [[ "$(<"$path")" == "$line" ]]; then
    return
  fi
  backup_if_present "$path"
  printf '%s\n' "$line" > "$path"
}

write_source "$target" "~/.config/tmux/tmux-config/.tmux.conf"
write_source "$legacy" "~/.config/tmux/tmux.conf"
printf 'Installed tmux config in %s\n' "$repo_copy"
