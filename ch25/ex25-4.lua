--[[
	Exercise 25.4
	
	Write an improved version of debug.debug that runs the given commands as
if they were in the lexical scope of the calling function. (Hint: run the commands
in an empty environment and use the __index metamethod attached to the function
'getvarvalue' to do accesses to variables.
]]

local get_vt = require "ex25-3" -- 'getvarvalue', but compiles a table

function debug_lex (chunk_name, co)
	local vt = get_vt(co or 2)

	-- The current scope doesn't necessarily have an _ENV variable, and so
	-- 'print' may not be available, so include it manually, to facilitate
	-- inspection.
	local env = setmetatable({print=print}, {__index = function (_, word)
		-- Use "safe navigation" (see PIL 4, p.46)
		return 
			(vt.locals[word] or {}).value or 
			(vt.upvalues[word] or {}).value or 
			vt.globals[word] 		
	end})
		
	while true do
		io.write(string.format("debug:%s> ", chunk_name))
		local line = io.read()
		if line == "cont" or line == nil then break end
		
		chunk_name = chunk_name or "debug_lex"
		local prefix, suffix = "", ""
		
		-- Allow for certain invalid chunks, for quick variable inspection.
		-- Check for both compile- and runtime errors.
		::try_again::
		local f, err_msg = load(prefix..line..suffix, chunk_name, "t", env)
		
		if f then -- no syntax errors
			local status, result = pcall(f) -- catch runtime errors
			if not status then print(result) end
		elseif prefix ~= "" then
			print(err_msg) 
		else
			prefix = "print("
			suffix = ")"
			goto try_again
		end
	end
	
	io.write("\n") -- make space for the next debug REPL
end

return debug_lex
