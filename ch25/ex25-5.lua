--[[
	Exercise 25.5
	
	Improve the previous exercise to handle updates, too.
]]

local get_vt = require "ex25-3" -- 'getvarvalue', but compiles a table
--local getvarvalue = require "ex25-1"
local setvarvalue = require "ex25-2b"

--local locals, upvalues = require("modules.var_it").locals, require("modules.var_it").upvalues
function debug_lex (chunk_name, level, co)
	level = level or 1
	
	if co == nil then
		level = level + 1
	end
	
	local vt = get_vt(level, co)

	local read_write = {
		__index = function (_, word)
			return vt.locals[word] or vt.upvalues[word] or vt.globals[word]
		end,
		
		__newindex = function (_, word, value)
			print("triggered __newindex")
			-- NB: globals in vt are automatically handled, thanks to inheritance.
			--setvarvalue(word, value, level + 6) -- technically, we need to fix for coroutines. 
			setvarvalue(word, value, level + 2)
			
			if vt.locals[word] then
				vt.locals[word] = value
			elseif vt.upvalues[word] then
				vt.upvalues[word] = value
			else
				error("Assignment to nonexistent variable", 2)
			end
		end,
	}
	
	local env = setmetatable({_G=_G}, read_write)
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
