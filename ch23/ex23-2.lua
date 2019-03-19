--[[
	Exercise 23.2
	
	Consider the first example of Section 23.6, which creates a table with a
finalizer that only prints a message when activated. What happens if the 
program ends without a collection cycle? What happens if the program calls
os.exit? What happens if the program ends with an error?
]]

local chunk = 
[[
	local obj = {x = "hi"};
	local result;
	setmetatable(obj, {__gc = function (obj) io.write('\n', obj.x) end});
	obj = nil;
]] 

--load(chunk .. [[io.write("no forced gc cycle")]])()
--load(chunk .. [[error("an error")]])()
--load(chunk .. [[io.write("call os.exit"); os.exit()]])()
load(chunk .. [[io.write("call os.exit and close"); os.exit(false, true)]])()

--[[
	A bit strange here, but my summary:
	
	GC happens when the Lua state closes. If the program ends without an
explicit collection cycle, the finalizer is called.
	If the program calls os.exit, the Lua state isn't closed by default, so
the finalizer isn't called. However, if the second parameter to os.exit is
true, then the Lua state is closed, and the finalizer is therefore called.
	If the program ends with an error, the finalizer is called.
	
	Triggering an error in a chunk will trigger an error in the main program
as well. I'm not sure if this is also doing something strange with my terminal.
]]