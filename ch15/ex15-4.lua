--[[
	Exercise 15.4
	
	Modify the code of the previous exercise so that it uses the
constructor syntax for lists whenever possible. For instance, it 
should serialize the table {14, 15, 19} as {14, 15, 19}, not as
{[1] = 14, [2] = 15, [3] = 19}.
	(Hint: start by saving the values of the keys 1,2,..., as long
as they are not nil. Take care not to save them again when traversing
the rest of the table.)
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch15/ex15-4.lua"] = nil
	dofile("/home/brandon/PIL/ch15/ex15-4.lua")
end

--[[
	obj: The Lua datatype we're serializing (stringifying) with this function.
	depth: The nesting depth of 'obj'.
	
	This function writes the stringification of 'obj' to whatever the current
output stream is, but in the next exercise this function will merely build 
the string output in memory.
	
	Returns nil.
]]

local VALID_IDENTIFIER = "^[_%a][_%w]*$"


function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

function serialize (obj, depth)
	
	depth = depth or 0 
	
	local type_obj = type(obj)
	
	if type_obj == "number" or
		type_obj == "string" or
		type_obj == "boolean" or
		type_obj == "nil" then
		
		--return string.format("%q", obj)
		fmt_write("%q", obj)
	elseif type_obj == "table" then
	
		-- Calculate the proper indentation for this table's elements.
		local self_tabs = string.rep("\t", depth)
		local el_tabs = string.rep("\t", depth + 1)
		
		fmt_write("\n\n%s{\n", self_tabs)
		
		-- Print the sequence portion first, then record the sequence
		-- indices so that we can skip them when iterating across the
		-- rest of the table.
		local index_taken  = {} 
		
		fmt_write("%s", el_tabs)
		for i, s_item in ipairs(obj) do
			serialize(s_item, depth + 1)
			fmt_write(",")
			index_taken[i] = true
		end
		fmt_write("\n")
		
		
		-- Write out the rest (non-sequential) part of the table.
		for k,v in pairs(obj) do
			local table_nl = type(v) == "table" and "\n" or ""
			
			if not index_taken[k] then
				if type(k) == "string" and k:match(VALID_IDENTIFIER) then
					fmt_write("%s%s = ", el_tabs, k)
				else
					fmt_write("%s[", el_tabs)
					serialize(k)
					fmt_write("] = ")
				end
				
				serialize(v, depth + 1)
				fmt_write(",\n%s", table_nl)
			end
		end
		
		fmt_write("%s}", self_tabs)
	else
		error("cannot serialize a " .. type_obj)
	end
end

examples = {

	-- First multi-level table.
	{
		knuth = {
			author = "Donald E. Knuth",
			title = "Literate Programming",
			publisher = "CSLI",
			year = 1992,
			keywords = {k1 = "Algol", k2 = "TAOCP", k3 = "organ"},
		},
		
		bentley = {
			author = "Jon Bentley",
			title = "More Programming Pearls",
			publisher = "Addison-Wesley",
			year = 1990,
			keywords = {k1 = "programming", k2 = "tips", k3 = "oysters"}
		},
	},
	
	-- Add more tables here. Keys must be valid Lua identifiers.
	{
		"A", "B", "C"
	},
	
	{
		[1] = "a", [2] = "b", [3] = "c"
	},
	
	{
		punctuation = {["."] = true, [","] = true},
		words = {"apple", "orange", "table"},
		["cs,"] = "do something cool",
		[true] = false,
		"a", "b", "c"
	},
	
	{ "red", "green", "blue", [5] = "orange"},
	
	-- The second "[1]" isn't a part of the table.
	{author = "Knuth", "begin", book = "taocp", "second", year = 1999,
		"third", [1] = "didn't follow problem statement!"},
		
	-- The first "[1]" isn't a part of the table.
	{[1] = "o", "P", "q"},
	
	-- This one is ok. ipairs catches it, though.
	{[1] = 1, [2] = 2},
	
	-- t[1] == 3, the first "[1]" isn't a part of the table.
	{[1] = 1, [2] = 2, 3},
	
	{ {1,2,3}, {4,5,6}, {7,8,9} },
}

function equal (o1, o2)
	
	if type(o1) ~= type(o2) then
		return false
	end
	
	local T = type(o1)
	
	if T == "number" or 
		T == "string" or 
		T == "boolean" or
		T == "nil" then
		return o1 == o2
	elseif T == "table" then
		for key, value in pairs(o1) do
			return equal(value, o2[key])
		end
	else
		error("Can't make that comparison")
	end
end

-- See if what we serialize is deep-equal to the original.
function run ()

	for _, t in ipairs(examples) do
		local fstream = assert(io.tmpfile())
		io.output(fstream)
		serialize(t) 
		
		-- Check that our tables look good when stdout is the outstream
		local option = (io.output() ~= io.stdout) and "q" or io.read()
		if option ~= "q" then os.execute("clear") end
	
		fstream:seek("set")
		local back_table = load("return " .. fstream:read("a"))()
		
		print(equal(back_table, t))
	end
end

function test1 ()
	serialize({{1,2,3}, {4,5,6}, {7,8,9}}, 0)
end