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

	tbc - still buggy, b/c setting a second breakpoint on the same function will
overwrite the first breakpoint's hook.  tbc.
]]


local handles = {}
local func_record = {}

local function setbreakpoint (fn, target_line)
	local callh

	callh = function ()
		local info = debug.getinfo(2, "Sfn")
		print(info.name, info.namewhat)
		local first_line, last_line = info.linedefined, info.lastlinedefined
		
		-- The line hook.
		local function lineh (_, line_no)
			local idx_line = line_no - first_line
			
			--print(target_line, idx_line, idx_line == target_line)
			if idx_line == target_line then
				print("Ouch!")
			end
			
			if line_no == last_line then
				debug.sethook(callh, "c")
			end
		end
		
		if info.what == "Lua" then
			if func_record[info.func] then 
				debug.sethook(lineh, "l")
			end
		end
	end
	
	local handle = {}
	handles[handle] = fn
	func_record[fn] = true
	debug.sethook(callh, "c")
	
	return handle
end

local function removebreakpoint (handle)
	local fn = handles[handle]
	handles[handle] = nil
	func_record[fn] = nil
end



local function test1 ()
	local a = 2
	local b = 3
	
	local function inside ()
		local x = 'a'
		local y = 'b'
	end
	
	inside()
end

local function test2 ()
	local x = 0
	local y = 1
	
	for i = 1, 10 do
	end
end

local function test3 ()
	local _ = nil
	local _ = nil
	local _ = nil
end


local h1 = setbreakpoint(test2, 4)
local h2 = setbreakpoint(test2, 1) -- I knew it - this overwrites the first one, tbc.
test1()
test2()
test3()
removebreakpoint(h1)
test2()

