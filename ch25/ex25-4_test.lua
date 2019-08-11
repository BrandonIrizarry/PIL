local debug_lex = require "ex25-4"
local getvarvalue = require "ex25-1"

function test ()
	local x = 0
	local y = 1
	local z = 2
	
	debug_lex(nil, "flevel_debug")
end

function cave ()
	local inside = "inside the cave"
	coroutine.yield()
end

function spelunker ()
	local top = "just outside the cave"
	coroutine.yield()
	cave()
end

test()

co = coroutine.create(spelunker)

coroutine.resume(co)

debug_lex(co, "coroutine_debug") -- need to debug this.