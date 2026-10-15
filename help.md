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
  Ctrl+b }       Swap pane with next (flip sides when 2 panes)
  Ctrl+b {       Swap pane with previous
  Ctrl+b Ctrl+o  Rotate panes
  Ctrl+b Space   Cycle layouts (side by side <-> stacked, etc.)

MY NOTES
  Ctrl+b d       Detach session
  Ctrl+b [       Enter copy mode
  Ctrl+b ?       Built-in key bindings
  Ctrl+b h       Open this help in a popup

BUFFERS (tmux's saved copies)
  Ctrl+b [       Enter copy mode; move with arrows or h/j/k/l
  Space          Start selection (in copy mode), then move to select text
  Enter          Copy selection into a buffer and leave copy mode
  Ctrl+b ]       Paste the most recent buffer into the current pane
  Ctrl+b =       Choose a buffer to paste (arrows, then Enter)
  Ctrl+b :  list-buffers          List saved buffers
  Ctrl+b :  show-buffer           Show the most recent buffer's contents
  Ctrl+b :  delete-buffer         Delete the most recent buffer
  Each copy creates a NEW buffer; copy several selections, then Ctrl+b =
  to pick which one to paste. Older automatic buffers eventually expire.

  Named buffers (kept until deleted; enter commands with Ctrl+b :)
    set-buffer -b notes 'hello'   Create notes, or replace its contents
    set-buffer -b todo 'ship it'  Create a second, independent buffer
    paste-buffer -b notes        Paste notes into the current pane
    show-buffer -b notes         View notes
    delete-buffer -b notes       Delete notes
    set-buffer -b buffer0000 -n notes
                                 Rename a copied buffer (use its list-buffers name)
                                 to an unused name to keep it
  Buffers are shared across sessions on the same tmux server.

SEARCH (in copy mode)
  Ctrl+b [       Enter copy mode
  ?              Search up (type text, Enter) - usual choice
  /              Search down
  n              Next match (in direction of last search)
  N              Previous match
  q              Leave copy mode
  Ctrl+b f       Find window by name/visible content

JOIN PANE FROM ANOTHER WINDOW
  Ctrl+b :  join-pane -s 2       Pull window 2's active pane in, split top/bottom
  Ctrl+b :  join-pane -h -s 2    Same, but split side by side
  Ctrl+b :  join-pane -s 2.1     Pull pane 1 of window 2 specifically
  Ctrl+b q                       Show pane numbers
  Ctrl+b !                       Send current pane back out to its own window
