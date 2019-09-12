local debug_lex = require "ex25-4b"

local nice = "I am a nice upvalue."
local a = 9

local function test ()
	print("Inside 'test'!")
	local x, y, z, w, q = 0, 1, 2, nice, a
	debug_lex("flevel_test")
	debug_lex("flevel_test2, from test", 2)
end

--test()

local function test2 ()
	print("Inside 'test2'!")
	print("We've got _ENV here now.")
	debug_lex("flevel_test2")
	test()
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
	debug_lex("coroutine_spelunker", 1, co)
else
	print(result1)
end

local status2, result2 = coroutine.resume(co)

if status2 then
	debug_lex("coroutine_cave", 1, co)
	debug_lex("coroutine_sp-from-cv", 2, co)
end
