--[[
	Exercise 25.5
	
	Improve the previous exercise to handle updates, too.
]]

local get_vt = require "ex25-3b" -- 'getvarvalue', but compiles a table
local setvarvalue = require "ex25-2b"


function debug_lex (chunk_name, level, co, use_dl)
	local dl 
	
	if use_dl then
		dl = require "ex25-4b" -- use original debug_lex, to help out here!
	else
		dl = function (...) end
	end
	
	level = level or 1
	
	if co == nil then
		level = level + 1
	end
	
	local vt = get_vt(level, co)

	local read_write = {
		__index = function (_, name)
			return vt[name]
		end,
		
		__newindex = function (_, name, value)
			print("triggered __newindex")
			
			-- Possibly run a diagnostic, in case things aren't setting, etc.
			local active = co and level or level + 3 -- I don't like this too much, but ok.
			dl("meta", active, co)
			
			setvarvalue(name, value, active, co)
			
			vt[name] = value
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
				for name, value in pairs(vt) do
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
