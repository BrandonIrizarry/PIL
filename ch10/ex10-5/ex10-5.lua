--[[
	Exercise 10.5

	Write a function to format a binary string as a literal in Lua, using
the escape sequence \x for all bytes:

	print(escape("\0\1hello\200"))
	--> \x00\x01\x68\x65\x6C\x6C\x6F\xC8

	As an improved version, use also the escape sequence \z to break long lines.
]]

--[[
function reload ()
	package.loaded["/home/brandon/PIL/ch10/ex10-5.lua"] = nil
	dofile("/home/brandon/PIL/ch10/ex10-5.lua")
end
--]]

function hex_format (char)
	if type(char) ~= "string" then
		error("Invalid input to 'hex_format'", 2)
	end
	
	if char:len() ~= 1 then
		error("Invalid input length to 'hex_format'", 2)
	end
	
	return "\\x"..string.format("%02X", string.byte(char))
end
	
-- The first version of 'escape'.
function escape_v1 (str)
	return (str:gsub(".", function (w)
		return hex_format(w)
	end))
end

-- The improved version of 'escape', breaking long lines in 'str'.
function escape (str)
	return (str:gsub ("()(.)", function (index, char)
		local col_number = index % 20 -- fit output comfortably onto screen.
		local hf = hex_format(char)
		
		return (col_number == 0 and (hf.."\\z\n")) or hf
	end))
end

-- Create the contents of a Lua module.
-- The module's "text" field is the (non-empty) string 'str'.
function make_data_content (str)
	assert(type(str) == "string", "Parameter is not a string. \z
	Did you forget to pass it in? :)")

	local content =
[[
return {

text =

"%s"

}
]]
	return string.format(content, str)
end

-- Writes to disk the Lua module that 'make_data_content' creates.
function write_data_content (filename, str)
	assert(filename:match("%.lua$")) -- Lua source-code file
	local outstream = io.open(filename, "w")

	local file_contents = make_data_content(str)

	outstream:write(file_contents)
	outstream:close()
end

function main ()

	-- Example strings.
	local short_orig = "\0\1hello\200"
	local long_orig = string.rep(short_orig, 90)

	-- Create the escaped versions.
	local short_old = escape(short_orig)
	local long_old = escape(long_orig)

	-- The escaped versions have nothing to do with the originals...
	assert(short_old ~= short_orig)
	assert(long_old ~= long_orig)

	-- Show this a bit at stdout as well.
	print("After escaping:")
	print(short_old)
	print(long_old:sub(1,10) .. "<snip>")
	print()

	-- Write the escaped strings to disk as Lua data modules.
	write_data_content("short_str.lua", short_old)
	write_data_content("long_str.lua", long_old)

	-- Cull the escaped strings back from their modules.
	-- The double quotes they were placed in should now interpret the
	-- escaped characters, bringing them back :)
	short_new = require("short_str").text
	long_new = require("long_str").text

	-- This is what we wanted to prove.
	assert(short_new == short_orig)
	assert(long_new == long_orig)

	-- Show this fact in stdout as well.
	print("After recalling from the modules:")
	print(short_new)
	print(long_new)
	print("\nCool, right?")
	print()
end

-- Call the main routine.
main()


--[[

local fstream_example = io.open("lit_bin_str.lua", "w")
x = escape(example)
content = string.format('return { text = "%s" }', x)
fstream_example:write(content)
fstream_example:close()

text = require("lit_bin_str").text

print(text)


example_long = string.rep("a", 90)
print(escape_improved(example_long))





local fstream_example_improved = io.open("lit_bin_str_imp.lua", "w")
y = escape_improved(example_long)
content_improved = string.format('return { text = "%s" }', y)
fstream_example_improved:write(content_improved)
fstream_example_improved:close()

text_improved = require("lit_bin_str_imp").text

print(text_improved)
--]]


