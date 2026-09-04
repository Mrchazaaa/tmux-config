#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config="$repo_dir/.tmux.conf"
config_dir="$HOME/.config/tmux"
target="$config_dir/tmux.conf"

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

if [[ -L "$target" && "$(readlink -f "$target")" == "$config" ]]; then
  printf '%s is already linked to this repository.\n' "$target"
  exit 0
fi

if [[ -e "$target" || -L "$target" ]]; then
  backup="$target.backup.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  printf 'Backed up %s to %s\n' "$target" "$backup"
fi

ln -s "$config" "$target"
printf 'Linked %s to %s\n' "$target" "$config"
