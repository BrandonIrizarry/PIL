--[[
	Exercise 15.2

	Modify the code of the previous exercise so that it uses the
syntax ["key"]=value, as suggested in Section 15.2.  
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch15/ex15-2.lua"] = nil
	dofile("/home/brandon/PIL/ch15/ex15-2.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

--[[
	obj: The Lua datatype we're serializing (stringifying) with this function.
	depth: The nesting depth of 'obj'.
	
	Returns nil.
]]

-- String buffer in which to store pieces of result string.
local ans = {}

function serialize (obj, depth)

	depth = depth or 0 -- when first invoked, there's no obligatory indentation.
	
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
		
		fmt_write("\n%s{\n", self_tabs)
		
		for k,v in pairs(obj) do
			local table_nl = type(v) == "table" and "\n" or ""
			fmt_write("%s[", el_tabs)
			serialize(k) -- differs from p. 142.
			fmt_write("] = ")
			serialize(v, depth + 1)
			fmt_write(",\n%s", table_nl)
		end
		
		fmt_write("%s}", self_tabs)
	else
		error("cannot serialize a " .. type_obj)
	end
end

local examples = {

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
}

for _, t in ipairs(examples) do
	serialize(t)
end