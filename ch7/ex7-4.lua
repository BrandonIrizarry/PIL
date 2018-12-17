--[[
	Exercise 7.4

	Write a program that prints the last line of a text file. Try to avoid
reading the entire file when the file is large and seekable.


POSIX:
    3.206 Line
        A sequence of zero or more non- <newline> characters plus a terminating <newline> character.
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch7/ex7-4.lua"] = nil
  dofile("/home/brandon/PIL/ch7/ex7-4.lua")
end

function last_line(filename)
	local fstr = assert(io.open(filename, "r"))

	fstr:seek("end")
	fstr:seek("cur", -2) -- read past the nil, and final newline.

	-- Collect the characters into a table.
	local chars = {}

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

last_line("sample.txt")
