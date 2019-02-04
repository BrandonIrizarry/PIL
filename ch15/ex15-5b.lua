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
	There's an "all-in-one" solution, but there's a better one if
you 
	1. Pass through the array first with the book's version of save;
	2. Keep that result in an array of strings;
	3. 'load' each non-cyclic/shared entry into memory as a new array
	(and delete it from the array);
	4. Use our ex15-4 version of 'serialize' to serialize that new array;
	5. Write the rest of the array of strings after that serialization.
--]]



--[[
function basicSerialize (o)
	-- assume 'o' is a number or a string
	return string.format("%q", o)
end
--]]

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


local Buffer = require("str_buffer").Buffer

function serialize_init (name, value, saved)

	local buffer = Buffer()
	local rsaved = {} -- save name --> value when array-part is reused
	
	saved = saved or {}
	
	--[[
		Generate the line-by-line serialization of 'value';
		adapted from Listing 15.3, p. 144.
	]]
	local function save (name, value)
		buffer.add("%s = ", name)
		
		local t = type(value)
		if t == "number" or t == "string" or t == "boolean" or t == "nil" then
			buffer.add("%q\n", value)
		elseif t == "table" then
			if saved[value] then
				rsaved[name] = true
				buffer.add("%s\n", saved[value])
			else
				saved[value] = name
				buffer.add("{}\n")
				
				for k,v in pairs(value) do
					local fname = string.format("%s[%q]", name, k)
					save(fname, v)
				end
			end
		else
			error("cannot save a " .. type(value))
		end
	end
	
	save(name, value)
	
	local result = buffer.flush()
	
	local for_later = {}
	-- Parse the result.
	for line in result:gmatch("(.-)\n") do
		local lhs = line:match("(%S+)%s*=")
		
		if not rsaved[lhs] then
			load(line)() -- we need this array back, but this doesn't look possible.
		else
			for_later[#for_later + 1] = line
		end
	end
	
	-- tbc - you would call the *ordinary* serialize function on the
	-- new array of name 'name', then write the lines indicated by rsaved.
	serialize(value, 0) -- will infinite loop, b/c 'value' is unaffected.
	
	for _, line in ipairs(for_later) do
		fmt_write("%s", line)
	end
end

a = {x=1, y=2, {3,4,5}}
a[2] = a
a.z = a[1]

serialize_init("a", a)

--[[
	Looks like there's no way to load the array in a nameable way, the way
we have it set up, reading statement by statement ('load' uses global environment).
	There could be a way to make this function line-aware, in which case
the lines added are still in our environment, all the separation of 
concerns is done in place, and we'll get a better solution!
--]]