--[[
	Exercise 25.5
	
	Improve the previous exercise to handle updates, too.
]]

-- tbc we have to call the original debug set functions to do what we want.
-- won't be too hard, but for that we need to track writes to E, meaning
-- that we'll need to set it up as a proxy table. But E starts out as empty,
-- so that shouldn't be too hard, you just attach __newindex to the metatable.
-- hm, but you should allow multiple writes (as __newindex isn't triggered on
-- existing keys), so E has to then stay empty. Read that part about proxy
-- tables, then. track. tbc.

local gvv = require "ex25-3" -- 'getvarvalue', but compiles a table
local locals = require "modules.local_it"
 
function debug_lex (co, chunk_name)
	local var_t = gvv(co, 2)
	
	local env = {} -- for 'load'
	
	-- NB: We're only looking at variables in the current scope, that is, level 1.
	local read_write = {
		__index = function (_, word)
			return var_t.locals[1][word] or var_t.upvalues[1][word] or var_t.globals[word]
		end,
		
	--	__newindex = function (_, word, value)
		--[[
			-- prototype joint for ordinary functions ("test")
			-- you have to both call "setlocal", and update var_t as well, 
			-- so that your __index metamethod works properly.
			-- you're going to need to save the index info somehow in var_t, 
			-- perhaps revert to the original implementation - or use a dual
			-- representation for the iterator modules. tbc.
			debug.setlocal(4, 1, "foo")
			var_t.locals[1]["x"] = "foo"

			for l, lt in locals(nil, 3) do
				print("LEVEL: ", l - 3, lt)
				for name, value in pairs(lt) do
					print(name, value)
				end
			end
		end
		]]
		
		--[[
			--prototype joint for coroutines ("spelunker")
			-- moral of the story: associate variables with their indices.
			debug.setlocal(co, 1, 1, "bottom")
			var_t.locals[1]["top"] = "bottom"
			
			for l, lt in locals(co) do
				print("LEVEL: ", l)
				for name, value in pairs(lt) do
					print(name, value)
				end
			end
		end,
			-- for 'local' iterator with a co, you don't need a level parameter.
			-- 
		]]
	}
	
	setmetatable(env, read_write)


	--[[
	local env = setmetatable(redirect, {__index = function (_, word)
		return var_t.locals[1][word] or var_t.upvalues[1][word] or var_t.globals[word]
	end})
	]]
		
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
