--[[

	Exercise 7.5

	Generalize the previous program so that it prints the last n lines of a text file.
Again, try to avoid reading the entire file when the file is large and seekable.
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch7/ex7-5.lua"] = nil
  dofile("/home/brandon/PIL/ch7/ex7-5.lua")
end


function last_n_lines(filename, N)

	local N = N or 1 -- print last line by default.

	local fstr = assert(io.open(filename, "r")) -- fails if file is empty or nonexistent.

	fstr:seek("end") -- seek to the end.
	fstr:seek("cur", -2) -- read past the nil, and final newline.

	local chars = {} -- collect the characters seen.

	local num_newlines = 1 -- there's always at least one line in a nonempty file.

	repeat
		local c = fstr:read(1)
		local valid_move = fstr:seek("cur", -2) -- was our seek valid?

		if c == "\n" then
			if num_newlines == N then
				goto finish -- quota is met, so we're done.
			else
				num_newlines = num_newlines + 1 -- increment the number of newlines seen.
			end
		end

		chars[#chars + 1] = c -- keep building the answer
	until not valid_move -- if seeking backward returns nil plus an error, then stop.


	::finish::
	return string.reverse(table.concat(chars)) -- we had been adding them backwards
end
