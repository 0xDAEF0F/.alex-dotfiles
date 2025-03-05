### Todos

- nvim is tripping with the redraws
- `go hover` is not working properly on vscode. types should go before errors/warnings.
- Detect when there is more than one tmux pane and if so make font smaller in terminal.
- Vim highlight selected word in visual but case sensitive.
- install leap on normal neovim
- chill with the warning highlights in vscode.
- Fix `cmd+right` accept next word suggestion vscode.
- Add `-` to word delimiters on a system wide level.
- Folds are now working integrate them pls
- Modify font size so preview suggestions are not so big.
- Investigate on: `autoparse-inline-edit-links` and "Character Level Diffs" `cursor.diffs.useCharacterLevelDiffs`
- Add stylua `/Users/ale/.config/stylua/stylua.toml` to dotfiles
- Sketchybar

### Links

- Vscode Neovim:
  [vscode-neovim]("https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim")
  [keybindings]("https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim#explorerlist-navigation-bindings")
- Karabiner Elements:
  [karabiner-elements]("https://karabiner-elements.pqrs.org/docs/")
- Better touch tool docs:
  [docs on better touch tool]("https://docs.folivora.ai/")
- Vscode api docs:
  [vscode-docs]("https://code.visualstudio.com/api/references/vscode-api")
- Vscode commands docs:
  [vscode-commands-docs]("https://code.visualstudio.com/api/references/commands")

### commands

- (cli) Look for all the process under: `pstree -s fish`
- (cli) Register a default opening of an text file: `duti -s {app.id} {file.extension} {operation}`
- (nvim) Yank file name "nvim": full path `:let @+ = expand('%:p')` only file `:let @+ = expand('%:t')`
- (vimium) Copy url of a website to clipboard: `yf` and the current url is `yy`
- (cli) Get id of app: `osascript -e 'id of application "Google Chrome"'`

### Notes

- `ctrl+l` forces neovim to redraw in vscode.
- Mac key bindings location: `~/Library/Keybindings/DefaultKeyBinding.dict`
