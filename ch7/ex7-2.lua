--[[
	Exercise 7.2

	Change the previous program so that it asks for confirmation if the user gives the name
of an existing file for its output.
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch7/ex7-2.lua"] = nil
  dofile("/home/brandon/PIL/ch7/ex7-2.lua")
end

m = require "ex7-1"

-- Handle setting the default arguments for sort_file;
-- This time, ask for confirmation if writing over an existing file.
function fix_streams (infile, outfile)

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
					io.write("Will not overwrite anything. Using stdout", "\n")
					return fstream_in, io.stdout
				end
			end

			::proceed_as_normal::
			local fstream_out = assert(io.open(outfile, "w"))
			return fstream_in, fstream_out
		end
	end
end
