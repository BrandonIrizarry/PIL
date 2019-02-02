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

function basicSerialize (o)
	-- assume 'o' is a number or a string
	return string.format("%q", o)
end

Buffer = require("str_buffer").Buffer

buffer = Buffer()

function save (name, value, saved)
	saved = saved or {} -- initial value
	
	buffer.add("%s = ", name)
	
	if type(value) == "number" or
		type(value) == "string" or
		type(value) == "boolean" or
		type(value) == "nil" then
		
		buffer.add("%s\n", basicSerialize(value))
	elseif type(value) == "table" then
		if saved[value] then -- value already saved?
			buffer.add("%s\n", saved[value]) -- use its previous name
		else
			saved[value] = name -- save name for next time
			buffer.add("{}\n") -- create a new table
			
			for k,v in pairs(value) do -- save its fields
				k = basicSerialize(k)
				local fname = string.format("%s[%s]", name, k)
				save(fname, v, saved)
			end
		end
	else
		error("cannot save a " .. type(value))
	end
end	



-- All arrays should be named "a".
local examples = {
	function ()
		local a = {x=1, y=2; {3,4,5}}
		a[2] = a -- cycle
		a.z = a[1] -- shared subtable
		return a
	end,
	
	function ()
		local a = {{{}}}
		return a
	end,
	
	function ()
		local a = {{{1,2,3}}, "a"}
		return a
	end,
}


save("a", examples[1]())
print(buffer.flush())

--[[
for k,v in pairs(assignments) do
	print(k,v)
end
--]]

function run_tests_io ()
	for _, ex in ipairs(examples) do
		save("a", ex()) 
		io.write("\n")
	end
end