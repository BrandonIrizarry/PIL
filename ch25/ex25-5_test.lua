local debug_lex = require "ex25-5"

local nice = "I am a nice upvalue."


-- This is tricky - this function actually has no _ENV variable in it,
-- so when using getvarvalue (ex25-1) for a particular level, it won't find 'print'
-- here, and so will fail! If I declare a global 'a' just above here, and use it
-- in 'test', _then_ we've given 'test' an '_ENV', and then 'print' will work.
function test ()
	local x = 0
	local y = 1
	local z = 2
	local w = nice
	
	debug_lex(nil, "flevel_debug")
	--debug_lex(nil, "flevel_debug_pt2")
end

test()

--[=[
function cave ()
	local inside = "inside the cave"
	coroutine.yield()
end

function spelunker ()
	local top = "just outside the cave"
	coroutine.yield()
	cave()
end

co = coroutine.create(spelunker)

coroutine.resume(co)

debug_lex(co, "coroutine_debug")
--]=]