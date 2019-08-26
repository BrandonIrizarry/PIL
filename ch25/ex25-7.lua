--[[
	Exercise 25.7
	
	Write a library for breakpoints. It should offer at least two functions:
	
	setbreakpoint(function, line) --> returns handle
	removebreakpoint(handle)
	
	We specify a breakpoint by a function and a line inside that function.
When the program hits a breakpoint, the library should call debug.debug.

	(Hint: For a basic implementation, use a line hook that checks whether
it is in a breakpoint; to improve performance, use a call hook to trace program
execution and only turn on the line hook when the program is running the target
function.)


	NB: Only one hook can be active at a time; so each hook, when activated,
has to "pass the baton" to the hook the programmer wants activated next.
]]

--[[ The 'H' table indexes unique table-keys (see PIL 4, p. 193) to our
registered "target" functions; such keys are the breakpoint handles. The
'F' table allows the call hook to know that the program is running a target function.
Furthermore, each key in 'F' (that is, each registered function) points to a table
that allows the line hook to know which lines need breakpoints. ]]
local F = {}
local H = {}

local M = {} -- the module.

-- For kicks, let's use the one we designed for Exercise 25-5.
local debug_lex = require "ex25-5"

--[[ Register the function and line number for the hook to pick up. 
Then create, register, and return the handle.
	Also, give the breakpoint an optional name, to know which 
breakpoint we're looking at! ]]
function M.setbreakpoint (fn, line, name)
	F[fn] = F[fn] or {}
	
	-- Instead of 'true', set existence is via a string (truthy), which
	-- we'll use as the breakpoint's name.
	F[fn][line] = assert(type(name) == "string") and name or "breakpoint"
	
	local hdl = {}
	H[hdl] = fn
	
	return hdl
end

--[[ Grab the registered function, delete it from the hook's search 
space, and then unregister the given handle. ]]
function M.removebreakpoint (hdl)
	local fn = H[hdl]
	F[fn] = nil
	H[hdl] = nil
end

--[[ This function defines the hook mechanism, and sets it in motion. 
In other words, the user must explicitly activate breakpoints by first 
calling this function. ]]
function M.init ()
	local callh 
	
	callh  = function ()
		local info = debug.getinfo(2, "Sf")
		local line_0, line_n, fn = info.linedefined, info.lastlinedefined, info.func
	
		local function lineh (_, line)			
			local name = F[fn][line - line_0]
			
			if name then
				print(debug.getlocal(2, 1))
				debug_lex(name, 2)
			end
			
			if line == line_n then
				debug.sethook(callh, "c")
			end
		end
				
		if F[fn] then 
			debug.sethook(lineh, "l")
		end
	end
	
	debug.sethook(callh, "c")
end

return M
