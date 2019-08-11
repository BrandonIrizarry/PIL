--[[
	Exercise 25.5
	
	Improve the previous exercise to handle updates, too.
]]

-- tbc: could you cache accesses as well?

local gvv = require "ex25-3" -- 'getvarvalue', but compiles a table

function debug_lex (co, chunk_name)
	local var_t = gvv(co, 2)

	-- NB: We're only looking at variables in the current scope, that is, level 1.
	local env = setmetatable({}, {__index = function (_, word)
		return var_t.locals[1][word] or var_t.upvalues[1][word] or var_t.globals[word]
	end})
		
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
