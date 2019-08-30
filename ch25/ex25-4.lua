--[[
	Exercise 25.4
	
	Write an improved version of debug.debug that runs the given commands as
if they were in the lexical scope of the calling function. (Hint: run the commands
in an empty environment and use the __index metamethod attached to the function
'getvarvalue' to do accesses to variables.
]]

local get_vt = require "ex25-3" -- 'getvarvalue', but compiles a table

-- Right now, this assumes that 'debug_lex' gets called at the exact same
-- level as the variables we want to inspect, but this approach doesn't
-- work when we want to include it in a debug hook.
function debug_lex (chunk_name, level, co)
	level = level or 1
	
	if co == nil then
		level = level + 1
	end
	
	local vt = get_vt(level, co)

	-- The current scope doesn't necessarily have an _ENV variable, and so
	-- 'print', 'pairs', 'ipairs' etc. may not be available, so include _G 
	-- in the chunk's environment to access these things, for inspecting
	-- variables and such.
	local env = setmetatable({_G=_G}, {__index = function (_, word)
		return vt.locals[word] or vt.upvalues[word] or vt.globals[word] 		
	end})
		
	chunk_name = chunk_name or "debug_lex"
	
	while true do
		io.write(string.format("debug:%s> ", chunk_name))
		local line = io.read()
	
		if line == nil then break end
		
		local asterisk, command = line:match("(*?)(.*)")
		if asterisk == "*" then
			if command == "cont" then
				break
			elseif command == "see" then
				print("\nlocals:")
				for name, value in pairs(vt.locals) do
					print(name, value)
				end
				print("\nupvalues:")
				for name, value in pairs(vt.upvalues) do
					print(name, value)
				end
				
				io.write("\n")
				goto continue
			else
				print("Invalid metacommand to debug REPL")
				goto continue
			end
		end
	
		-- Allow for certain invalid chunks, for quick variable inspection.
		-- Check for both compile- and runtime errors.
		local prefix, suffix = "", ""
		::try_again::
		local f, err_msg = load(prefix..line..suffix, chunk_name, "t", env)
		
		if f then -- no syntax errors
			local status, result = pcall(f) -- catch runtime errors
			if not status then print(result) end
		elseif prefix ~= "" then
			print(err_msg) 
		else
			prefix = "_G.print("
			suffix = ")"
			goto try_again
		end
		
		::continue::
	end
	
	io.write("\n") -- make space for the next debug REPL
end

return debug_lex
