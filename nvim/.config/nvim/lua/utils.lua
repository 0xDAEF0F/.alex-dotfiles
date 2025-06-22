return {
  -- Just a little helper function to center the cursor on the screen on vscode
  centerScreenOnCursor = function()
    require("vscode").eval_async([[
            const editor = vscode.window.activeTextEditor;
            if (editor) {
              const cursorPosition = editor.selection.active;
              const range = new vscode.Range(cursorPosition, cursorPosition);
              editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
            }
          ]])
  end,
  -- Registers the jump to the jumplist 1 in vscode
  registerJump = function()
    require("vscode").call("jumplist.registerJump", { args = { 1 } })
  end,
  -- Feedkeys for vscode
  nvimFeedkeys = function(keys)
    local feedable_keys =
      vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(feedable_keys, "n", false)
  end,
}
