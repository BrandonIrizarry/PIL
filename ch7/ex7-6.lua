--[[

	Exercise 7.6

	Using os.execute and io.popen, write functions to create a directory, to remove a directory,
and to collect the entries in a directory.
]]

function reload ()
  package.loaded["/home/brandon/PIL/ch7/ex7-6.lua"] = nil
  dofile("/home/brandon/PIL/ch7/ex7-6.lua")
end

function create_directory (dirname)
	os.execute("mkdir " .. dirname)
end

-- Assume the directory is empty.
function remove_directory (dirname)
	os.execute("rmdir " .. dirname)
end

-- Return a table of the directory entries.
function collect_dir_entries (dirname)
	local cmd_output_stream = io.popen("ls " .. dirname)
	local all_entries = {}

	for entry in cmd_output_stream:lines() do
		all_entries[#all_entries + 1] = entry
	end

	return all_entries
end

