--[[
	Exercise 7.1

	Write a program that reads a text file and rewrites it with its lines
sorted in alphabetical order. When called with no arguments, it should read
from standard input and write to standard output. When called with one file-name
argument, it should read from that file and write to standard output. When called
with two file-name arguments, it should read from the first file and write to
the second.
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch7/ex7-1.lua"] = nil
  dofile("/home/brandon/PIL/ch7/ex7-1.lua")
end

-- Handle setting the default arguments for the file-sorting function.
function fix_streams (infile, outfile)

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

-- Create a file to be sorted in the current directory.
function make_file (filename, contents)

	-- Open a file stream for writing.
	local outstream = assert(io.open(filename, "w"))

	for _, line in ipairs(contents) do
		outstream:write(line, "\n")
	end

	-- Stop using the stream; and write the file to disk.
	outstream:close()
end

-- contents1, contents2: useful pieces of data for making sample files.
contents1 = {
	"roses are red,",
	"violets are blue,",
	"sugar is sweet,",
	"and so are you!"
}

-- This is used to test overwriting in ex7-2.
contents2 = {
	"this annual",
	"calendar is subject",
	"to change.",
	"please see weekly",
	"bulletin for",
	"announcements."
}

function sort_file (instream, outstream)
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

-- Test stdin -> stdout.
-- For ex7-2, tests will need to optionally know what version of fix_streams to use.
function test1(fs)
	local fs = fs or fix_streams
	s_in, s_out = fs()
	sort_file(s_in, s_out)
end

-- Test filename -> stdout.
function test2(fs)
	local fs = fs or fix_streams
	fstream, s_out = fs("sample.txt")
	sort_file(fstream, s_out)
end

-- Test filename1 -> filename2.
-- Optional infile parameter is used to test overwriting in ex7-2.
function test3(fs, infile)
	local fs = fs or fix_streams
	local infile = infile or "sample.txt"
	fstream1, fstream2 = fs(infile, "output.txt")
	sort_file(fstream1, fstream2)
	fstream2:close() -- write to see results mid-session.
end

function print_file(filename)
	assert(io.output() == io.stdout)
	local fstream_in = assert(io.open(filename, "r"))
	local text = fstream_in:read("a")
	io.write(text, "\n")
end

-- Export this as a module for use in ex7-2.
return {
	test1 = test1,
	test2 = test2,
	test3 = test3,
	sort_file = sort_file,
	contents1 = contents1,
	contents2 = contents2,
	make_file = make_file,
	print_file = print_file
}
