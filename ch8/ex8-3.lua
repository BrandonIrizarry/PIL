--[[
	Exercise 8.3

	Many people argue that 'repeat-until' is seldom used, and therefore it should
not be present in a minimalistic language like Lua. What do you think?
]]

--[[
	In the previous chapter exercises, I used the following function,
which I include outside of a comment so that editor syntax highlighting
enhances its readability. Also, make it local to hide it from the REPL:
]]

local function last_line(filename)
	local fstr = assert(io.open(filename, "r"))

	fstr:seek("end", -2) -- stop just before the nil, and final newline.

	local chars = {} -- collect the characters into a table.

	-- If seeking backward returns nil plus an error, then stop.
	repeat
		local c = fstr:read(1)
		local valid_move = fstr:seek("cur", -2)

		if c == "\n" then
			goto finish
		end

		chars[#chars + 1] = c
	until not valid_move

	::finish::
	print(string.reverse(table.concat(chars)))
end

--[[
	I could've written the repeat-until loop as a while loop:
]]

local function last_line_while(filename)
	local fstr = assert(io.open(filename, "r"))

	fstr:seek("end", -2) -- stop just before the nil, and final newline.

	local chars = {} -- collect the characters into a table.

	-- USE A WHILE LOOP: first, initialize state:
	local c = fstr:read(1)
	local valid_move = fstr:seek("cur", -2)

	-- Then, the loop itself:
	while valid_move do -- if seeking backward returns nil+error, stop.
		c = fstr:read(1)
		valid_move = fstr:seek("cur", -2)

		if c == "\n" then
			goto finish -- we've found the end of the second-to-last line...
		end

		chars[#chars + 1] = c -- keep building the last line.
	end
	-- END WHILE LOOP

	::finish::
	return string.reverse(table.concat(chars)) -- use 'return' for testing purposes.
end

-- Check if it still works :)
assert(last_line_while("../data/big.txt") == "  print [ord(c) for c in s")

--[[
	Notice that the second version is slightly more verbose, since the control
variable is initialized first before the loop itself, and also updated inside
the loop; not only does repeat-until obviate the initialization step, it also
keeps the control variables (and other variables it may depend on) within the
scope of the loop itself (without resorting to a do-block).
	This may make writing gotos easier (since gotos can't jump to a label inside the scope of a local variable defined afterwards), and in general keep the "namespace" easier to keep track of. ]]
]]
