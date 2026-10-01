#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${TMUXCONFIG_REPO_URL:-https://github.com/Mrchazaaa/tmux-config.git}"
INSTALL_DIR="${TMUXCONFIG_INSTALL_DIR:-$HOME/.config/tmux/tmux-config}"
TMUX_CONF="${TMUX_CONF:-$HOME/.config/tmux/tmux.conf}"
LEGACY_CONF="${TMUX_LEGACY_CONF:-$HOME/.tmux.conf}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HELPER_PATH="$SCRIPT_DIR/scripts/lib/install-helpers.sh"
if [[ -f "$HELPER_PATH" ]]; then
  # shellcheck source=scripts/lib/install-helpers.sh
  source "$HELPER_PATH"
else
  command -v curl >/dev/null 2>&1 || {
    printf 'Error: curl is required when piping this installer from the network.\n' >&2
    exit 1
  }
  HELPER_TMP="$(mktemp)"
  trap 'rm -f "$HELPER_TMP"' EXIT
  curl -fsSL https://raw.githubusercontent.com/Mrchazaaa/tmux-config/master/scripts/lib/install-helpers.sh -o "$HELPER_TMP"
  source "$HELPER_TMP"
fi

usage() {
  printf 'Usage: ./install.sh [--help]\n'
}

install_or_update_repo() {
  mkdir -p "$(dirname "$INSTALL_DIR")"

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    log "Existing tmux-config Git checkout found at $INSTALL_DIR."
    if ask_yes_no "Pull the latest changes for the deployed tmux config?"; then
      git -C "$INSTALL_DIR" pull --ff-only
    fi
    return 0
  fi

  [[ ! -e "$INSTALL_DIR" ]] || die "$INSTALL_DIR already exists but is not a Git checkout."
  log "Cloning tmux-config into $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
}

write_tmux_shims() {
  write_file_if_changed "$TMUX_CONF" "source-file $INSTALL_DIR/.tmux.conf"
  write_file_if_changed "$LEGACY_CONF" "source-file $TMUX_CONF"
}

main() {
  case "${1:-}" in
    --help|-h) usage; return 0 ;;
    "") ;;
    *) usage >&2; die "Unknown option: $1" ;;
  esac

  ensure_command git git "Would you like to install git now?"
  ensure_command tmux tmux "Would you like to install tmux now?"
  install_or_update_repo
  write_tmux_shims
  log "Installation complete."
}

main "$@"
