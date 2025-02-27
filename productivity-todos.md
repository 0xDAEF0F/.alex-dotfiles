### Todos

- when ai gives commands always give the full name flags. (no shorthands)
- move the zmk stuff to `.dotfiles`
- vim registers (again)
- quit vim with ctrl-q
- tmux start in home unless specified otherwise
- Nvim-vscode cmd+bspc => ctrl+u
- Figure out how the jumplist works exactly in vscode-nvim.
- search backwards in fish in insert mode, too
- Fix karabiner mod-morph issue
- ctrl-q in nvim exits with `zz`
- Google chrome open a new tab and jump into it with cmd + click
- Two finger gesture to switch tabs would be awesome!
- Research for: `BetterTouchTool` for mouse selection words delimiters.
- Detect when there are more than one tmux pane and if so make font smaller.
- List on terminal the files I edit the most and just enter to go in nvim to them.
- fish/ghostty cursor issues.
- Highlight incrementally on search in TMUX.
- Whatsapp aerospace to 4
- better touch command abbrv
- change gutter colors in vscode to identify which operation is which
- focus parts of windows fast
- Toggle the bar on/off in vscode that appears at the bottom of the screen.
- Investigate on: `autoparse-inline-edit-links` and "Character Level Diffs" `cursor.diffs.useCharacterLevelDiffs`
- color scheme eza
- highlight on the browser double click (words should count as such with special characters)
- focus to text efficiently
- More vertical space vs code
- Check out zen browser.
- Clear the scroll bar on the files panel vscode.
- How to change models with keyboard shortcuts.

### Links

- Vim registers:
  [vim-register-tutorial](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/copy-paste/)
- Vscode Neovim:
  [vscode-neovim]("https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim")
- Karabiner Elements:
  [karabiner-elements]("https://karabiner-elements.pqrs.org/docs/")
- Fish vi mode docs:
  [fish-vi-mode-docs]("https://fishshell.com/docs/current/interactive.html#command-mode")
- Better touch tool docs:
  [docs on better touch tool]("https://docs.folivora.ai/")

### commands

- (cli) Look for all the process under: `pstree -s fish`
- (cli) Register a default opening of an text file: `duti -s {app.id} {file.extension} {operation}`
- (nvim) Yank file name "nvim": full path `:let @+ = expand('%:p')` only file `:let @+ = expand('%:t')`
- (vimium) Copy url of a website to clipboard: `yf` and the current url is `yy`
- (cli) Get id of app: `osascript -e 'id of application "Google Chrome"'`

### Notes

- `ctrl+l` forces neovim to redraw in vscode.
- Mac key bindings location: `~/Library/Keybindings/DefaultKeyBinding.dict`
- The unnamed register `"` is where you copy and cut stuff to. The default register.
- `a-z` are registers you can use explicitly to copy and cut text.
- The yank register `0` stores the last thing you have yanked.
- The cut registers `1-9` store the last 9 things you deleted/cut.
- Functionality I want for the registers:
  - Delete/Change should send to the "1 register.
  - Yank should put it in the + and " register (as now).
  - Put/Paste should paste from the +/" register (as now).
