--[[
	Exercise 15.5
	
	The approach of avoiding constructors when saving tables with cycles is too
radical. It is possible to save the table in a more pleasant format using 
constructors for the simple case, and to use assignments later only to fix sharing
and loops. Reimplement the function 'save' (Listing 15.3) using this approach.
Add to ot all the goodies that you have implemented in the previous exercises
(indentation, record syntax, and list syntax.)
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch15/ex15-5.lua"] = nil
	dofile("/home/brandon/PIL/ch15/ex15-5.lua")
end

--[[
	obj: The Lua datatype we're serializing (stringifying) with this function.
	depth: The nesting depth of 'obj'.
	
	Returns nil.
]]

local VALID_IDENTIFIER = "^[_%a][_%w]*$"

local Buffer = require("str_buffer").Buffer

function basic_serialize (obj)

	assert(
		(type(obj) == "number" or
		type(obj) == "string" or
		type(obj) == "boolean" or
		type(obj) == "nil"),
		"Are you trying to serialize a complicated key? ;)"
	)
	
	return string.format("%q", obj)
end

function serialize (obj, path, depth)
	
	local type_obj = type(obj)
	
	if type_obj == "number" or
		type_obj == "string" or
		type_obj == "boolean" or
		type_obj == "nil" then
	
		return basic_serialize(obj)
		
	elseif type_obj == "table" then
		local buffer = Buffer()
		
		-- Calculate the proper indentation for this table's elements.
		local self_tabs = string.rep("\t", depth)
		local el_tabs = string.rep("\t", depth + 1)
		
		buffer.add("\n%s{\n", self_tabs)
		
		-- Print the sequence portion first, then record the sequence
		-- indices so that we can skip them when iterating across the
		-- rest of the table.
		local index_taken  = {} 
		
		buffer.add("%s", el_tabs)
		
		for i, seq_item in ipairs(obj) do
			local sub_path = string.format("%s[%d]", path, i)
			buffer.add("%s,", serialize(seq_item, sub_path, 0))
			index_taken[i] = true
		end
		
		buffer.add("\n")
		
		-- Write out the rest (non-sequential) part of the table.
		for k,v in pairs(obj) do
			
			if not index_taken[k] then
		
				if type(k) == "string" and k:match(VALID_IDENTIFIER) then
					local sub_path = string.format("%s.%s", path, k)
					buffer.add("%s%s = %s", el_tabs, k, serialize(v, sub_path, depth + 1))
				else
					local bs_k = basic_serialize(k)
					local sub_path = string.format("%s[%s]", path, bs_k)
					buffer.add("%s[%s] = %s", el_tabs, bs_k, serialize(v, sub_path, depth + 1))
				end
				
				buffer.add(",\n%s", type(v) == "table" and "\n" or "")
			end
		end
		
		buffer.add("%s}", self_tabs)
		
		--return table.concat(result)
		return buffer.flush()
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
function test_equality ()

	for i, t in ipairs(examples) do
		local initial_path = string.format("examples[%d]", i)
		print(equal(t, load("return " .. serialize(t, initial_path, 0))())) 
	end
end