--[[
	Exercise 8.2

	Describe four different ways to write an unconditional loop in Lua.
Which one do you prefer?
]]

--[[
	Depending on things, I'd go with either while true, or repeat-until false,
though the curve example for the math.huge for-loop was interesting.
	I wouldn't rule out the others, though :)
--]]

-- Refactor each introduction into a function using 'string.format'.
local function message(loop_type)
	local message = [[
	Inside %s;
	Type any character (then Enter), or else q+Enter to exit:
]]

	print(string.format(message, loop_type))
end

assert(io.input() == io.stdin)
io.write(
	[[
		1: Use math.huge
		2: Use while true
		3: Use infinite tail-recursion
		4: Use a cyclic goto
		5: Use repeat-until false
]])

selection = io.read("n")
assert(math.type(selection) == "integer" and
	selection >= 1 and
	selection <= 5)

function math_huge()
	message("'math.huge' for-loop")

	for i = 1, math.huge do
		local char = io.read(1)
		if char == "q" then break end
	end
end

function while_true()
	message("'while true' loop")

	while true do
		local char = io.read(1)
		if char == "q" then break end
	end
end

function infinite_tail_recursion()
	message("infinite tail recursion")

	local function engine()
		local char = io.read(1)
		if char == "q" then return end
		return engine()
	end

	-- Don't forget to actually call the function!
	engine()
end

function cyclic_goto()
	message("cyclic goto")

	::cycle:: local char = io.read(1)

	if char == "q" then
		goto _end
	else
		goto cycle
	end

	::_end::
end

function repeat_until_false()
	message("repeat-until false")

	repeat
		local char = io.read(1)

		if char == "q" then break end
	until false
end

if selection == 1 then
	math_huge()
elseif selection == 2 then
	while_true()
elseif selection == 3 then
	infinite_tail_recursion()
elseif selection == 4 then
	cyclic_goto()
elseif selection == 5 then
	repeat_until_false()
else
	error("Help! Something went really wrong with your input checking.")
end


