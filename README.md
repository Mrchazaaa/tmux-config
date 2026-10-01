# tmux-config

Small tmux configuration with mouse support and vi-style copy mode.

## Install

The installers require `git`. The Linux installer can offer to install missing
`tmux` packages on supported Linux package managers and Homebrew.

### Linux

Run this one-liner in a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/Mrchazaaa/tmux-config/master/install.sh | bash
```

Update later with `cd ~/.config/tmux/tmux-config && git pull`.

### Windows

With [psmux](https://github.com/psmux/psmux) already installed, run this one-liner
in PowerShell:

```powershell
irm https://raw.githubusercontent.com/Mrchazaaa/tmux-config/master/install.ps1 | iex
```

The Windows installer clones to `$HOME\.config\tmux\tmux-config` and writes
`$HOME\.tmux.conf`, which psmux loads automatically. Pull updates from the
checkout with `cd $HOME\.config\tmux\tmux-config; git pull`, then restart psmux.
