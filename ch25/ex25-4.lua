--[[
	Exercise 25.4
	
	Write an improved version of debug.debug that runs the given commands as
if they were in the lexical scope of the calling function. (Hint: run the commands
in an empty environment and use the __index metamethod attached to the function
'getvarvalue' to do accesses to variables.

	It looks like, to use getvarvalue, you need to know the variable name you're looking up,
_outside_ of '__index', and make the call there - but you can't do that with ex25-1, so you
need ex25-3, to get everything in a table and look up what you need there.
]]

local gvv = require "ex25-3"
local getvarvalue = require "ex25-1"

function debug_lex (co, chunk_name)
	local var_t = gvv(co, 2)

	-- NB: We're only looking at variables in the current scope, '1'.
	local env = setmetatable({}, {__index = function (_, word)
		return var_t.locals[1][word] or var_t.upvalues[1][word] or var_t.globals[word]
	end})

	-- This is cool for when we need to debug for whatever reason, e.g.:
	-- 'globals.print(locals[1].x + locals[1].y)' for 'print(x + y)'.
	--local env = setmetatable({}, {__index = var_t})
		
	while true do
		io.write(string.format("debug:%s> ", chunk_name))
		local line = io.read()
		if line == "cont" or line == nil then break end
		
		chunk_name = chunk_name or "debug_lex"
		local prefix, suffix = "", ""
		
		-- Allow for certain invalid chunks, for quick variable inspection.
		::try_again::
		local f, err_msg = load(prefix..line..suffix, chunk_name, "t", env)
		
		if f then -- no syntax errors
			f() 
		elseif prefix ~= "" then
			io.write(err_msg, "\n") 
		else
			prefix = "print("
			suffix = ")"
			goto try_again
		end
	end
	
	io.write("\n") -- make space for the next debug REPL
end

return debug_lex
