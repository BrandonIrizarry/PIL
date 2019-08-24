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


	Note that only one hook can be active at a time; so each hook, when activated,
has to "pass the baton" to the hook the programmer wants activated next. In that sense, 
hooks resemble return statements.

tbc -- Link this with what 'setbreakpoint' is supposed to be; for example, you could
be setting multiple breakpoints, and so e.g. do you need a table of all the breakpoints?
So, removing a handle is removing that entry from the table, for that file you're executing.
Also, will you be adding these lines directly into the file, or else load the file as a 
chunk (being able to inspect the source code), and set breakpoints from the outside 
(in the style of the previous exercise?) tbc.
]]

local callh

-- The call hook.
callh = function (fn, tline)
	local info = debug.getinfo(3, "Sfn")
	local first_line, last_line = info.linedefined, info.lastlinedefined
	
	-- The line hook.
	local function lineh (_, line_no)
		local idx_line = line_no - first_line
		
		print(tline, idx_line, idx_line == tline)
		if idx_line == tline then
			print("Ouch!")
		end
		
		if line_no == last_line then
			debug.sethook(function () callh(fn, tline) end, "c")
		end
	end
	
	if info.what == "Lua" then
		--print(info.name, info.func == fn)
		if info.func == fn then
			debug.sethook(lineh, "l")
		end
	end
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

debug.sethook(function () callh(test2, 4) end, "c")
test1()
test2()
test3()
test2()
debug.sethook()


