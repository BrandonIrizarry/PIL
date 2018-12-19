--[[
	Exercise 7.1

	Write a program that reads a text file and rewrites it with its lines
sorted in alphabetical order. When called with no arguments, it should read
from standard input and write to standard output. When called with one file-name
argument, it should read from that file and write to standard output. When called
with two file-name arguments, it should read from the first file and write to
the second.
]]

local M = {}

-- Handle setting the default arguments for the file-sorting function.
function M.fix_streams (infile, outfile)

	-- Set and return the necessary I/O streams.
	if not infile then
		return io.stdin, io.stdout
	else
		local fstream_in = assert(io.open(infile, "r"))

		if not outfile then
			return fstream_in, io.stdout
		else
			local fstream_out = assert(io.open(outfile, "w"))
			return fstream_in, fstream_out
		end
	end
end

-- Rewrites a text file with its lines sorted in alphabetical order.
function M.sort_file (instream, outstream)
	local lines = {}

	-- Read the lines into the table LINES.
	for line in instream:lines() do
		lines[#lines + 1] = line
	end

	-- Sort the lines in alphabetical order.
	table.sort(lines)

	-- Now, do the writing to the output stream.
	for _, l in ipairs(lines) do
		outstream:write(l, "\n")
	end

	-- Clean up: reset the input stream's file pointer to the beginning.
	instream:seek("set")
end

M.doc = [[

EXERCISE 7.1 DOCUMENTATION

-- Handle setting the default arguments for the file-sorting function.
function fix_streams (infile, outfile)

-- Rewrites a text file with its lines sorted in alphabetical order.
function sort_file (instream, outstream)
]]


-- Return our functions for testing.
return M
