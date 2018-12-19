local M = {}

-- Create a file to be sorted with the given contents.
local function make_file (filename, contents)

	-- Open a file stream for writing.
	local outstream = assert(io.open(filename, "w"))

	for _, line in ipairs(contents) do
		outstream:write(line, "\n")
	end

	-- Stop using the stream; and write the file to disk.
	outstream:close()
end

-- Print a file's contents to stdout.
function M.print_file(filename)
	assert(io.output() == io.stdout) -- Make sure we're writing to stdout.
	local fstream_in = assert(io.open(filename, "r"))
	local text = fstream_in:read("a")
	io.write(text, "\n\n")
end



function M.prepare_files()
	local dir_prefix = "../local_data/"

	local stanzas = {
		love_poem  = {
			"roses are red,",
			"violets are blue,",
			"sugar is sweet,",
			"and so are you!"
		},

		notice = {
			"this annual",
			"calendar is subject",
			"to change.",
			"please see weekly",
			"bulletin for",
			"announcements."
		},
	}

	local inventory = {}
	for label, s in pairs(stanzas) do
		local filename = string.format("%s%s.txt", dir_prefix, label)
		make_file(filename, s)
		inventory[label] = filename
	end

	return inventory
end

M.doc =
[[
print_file(FILENAME)
- Display the contents of FILENAME to stdout.

prepare_files()
- Setup some dummy files for testing purposes.
- Return the list of names of the files created.
]]


return M
