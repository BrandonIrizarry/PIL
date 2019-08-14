local debug_lex = require "ex25-4"

local nice = "I am a nice upvalue."
local a = 9

local function test ()
	local x, y, z, w, q = 0, 1, 2, nice, a
	debug_lex("flevel_debug")
end

test()

local function test2 ()
	print("We've got _ENV here now.")
	debug_lex("flevel_test2")
end

test2()

local function cave ()
	local inside = "inside the cave"
	coroutine.yield()
end

local function spelunker ()
	local top = "just outside the cave"
	coroutine.yield()
	cave()
end


local co = coroutine.create(spelunker)

local status1, result1 = coroutine.resume(co)

if status1 then
	debug_lex("coroutine_debug", co)
else
	print(result1)
end
