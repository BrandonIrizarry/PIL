--[[
	Exercise 7.2

	Change the previous program so that it asks for confirmation if the user gives the name
of an existing file for its output.
]]

local M = {}

-- Handle setting the default arguments for sort_file;
-- This time, ask for confirmation if writing over an existing file.
function M.fix_streams (infile, outfile)

	-- Set and return the necessary I/O streams.
	if not infile then
		return io.stdin, io.stdout
	else
		local fstream_in = assert(io.open(infile, "r"))

		if not outfile then
			return fstream_in, io.stdout
		else
			if io.open(outfile, "r") then
				io.write("Outfile exists. Overwrite? [y/n]: ")

				if io.read() == "y" then
					goto proceed_as_normal
				else
					io.write("Will not overwrite anything; displaying sorted output to stdout", "\n")
					return fstream_in, io.stdout
				end
			end

			::proceed_as_normal::
			local fstream_out = assert(io.open(outfile, "w"))
			return fstream_in, fstream_out
		end
	end
end

M.sort_file = require("ex7-1").sort_file -- use the previous definition of sort_file

M.doc = [[

EXERCISE 7.2 DOCUMENTATION

-- Handle setting the default arguments for the file-sorting function.
-- Ask for confirmation if writing over an existing file.
function fix_streams (infile, outfile)

-- Rewrites a text file with its lines sorted in alphabetical order.
function sort_file (instream, outstream)
]]

return M
