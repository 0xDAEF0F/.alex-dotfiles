--- @sync entry
return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			-- First enter the directory
			ya.manager_emit("enter", {})
			-- Then open nvim in that directory
			ya.manager_emit("shell", {
				"nvim .",
				block = true,
				confirm = false,
			})
		else
			-- If it's a file, just open it normally
			ya.manager_emit("open", {})
		end
	end,
}