TMUX CHEAT SHEET
================

WINDOWS
  Ctrl+b c       Create window
  Ctrl+b n       Next window
  Ctrl+b p       Previous window
  Ctrl+b ,       Rename window

PANES
  Ctrl+b %       Split vertically
  Ctrl+b "       Split horizontally
  Ctrl+b o       Switch pane
  Ctrl+b z       Zoom/unzoom pane

MY NOTES
  Ctrl+b d       Detach session
  Ctrl+b [       Enter copy mode
  Ctrl+b ?       Built-in key bindings

JOIN PANE FROM ANOTHER WINDOW
  Ctrl+b :  join-pane -s 2       Pull window 2's active pane in, split top/bottom
  Ctrl+b :  join-pane -h -s 2    Same, but split side by side
  Ctrl+b :  join-pane -s 2.1     Pull pane 1 of window 2 specifically
  Ctrl+b q                       Show pane numbers
  Ctrl+b !                       Send current pane back out to its own window
