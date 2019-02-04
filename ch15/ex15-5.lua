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


function write (depth, fmt, ...)
	local tabs = string.rep("\t", depth)
	return io.write(string.format(tabs .. fmt, ...))
end

function basic_serialize (obj)
	-- assume 'obj' is of one of the basic types
	return string.format("%q", obj)
end

local VALID = "^[_%a][_%w]*$"

function save (path, value, saved)

	local deferred = {""}
	
	local function defer (lhs, rhs)
		deferred[#deferred + 1] = string.format("%s = %s", lhs, rhs)
	end
	
	local saved = saved or {}
	
	write(0, "%s = ", path) -- needed, if we really want to read it back again.
	
	local function save_1 (path, value, depth)
		local t = type(value)
		
		if t == "string" or t == "number" or t == "boolean" or t == "nil" then
			write(0, "%s", basic_serialize(value))
		elseif t == "table" then
			write(0, "{\n")
			
			-- Save the table's path, for later.
			saved[value] = path
			
			for k,v in pairs(value) do
			
				local k_s = basic_serialize(k)
				local path = string.format("%s[%s]", path, k_s)
				
				-- Self-reference found: defer.
				if saved[v] then 
					defer(path, saved[v])
					goto continue
				end
					
				if type(k) == "string" and k:match(VALID) then
					write(depth + 1, "%s = ", k)
				elseif math.type(k) == "integer" then
					write(depth + 1, "")
				else
					write(depth + 1, "[%s] = ", k_s)
				end
				
				save_1(path, v, depth + 1)
				
				write(0, ",\n")
				
				::continue:: -- we came here to avoid a cycle/shared part.
			end
			
			write(depth, "}")
		else
			error("cannot save a " .. t)
		end
	end
			
	save_1(path, value, 0)
	
	deferred[#deferred + 1] = ""
	deferred[#deferred + 1] = ""
	io.write(table.concat(deferred, "\n"))
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

-- Examples that use shared parts.
a = {x=3, y=5, {3,4,5}}
a[2] = a
a.z = a[1]

b = { {1,2,3}, {4,5,6, ["."] = 4}, a[1]}

-- Use this as a control, to show that 'equal' below doesn't give false positives.
z = {}


-- Have 'save' write to an external file.
io.output("serialized_tables.lua")

local t = {}
save("E", examples)

-- Write out the special tables.
save("A", a, t)
save("B", b, t)


save("Z", z)

io.close() -- all done with writing!

z[1] = "gotcha!"

dofile("serialized_tables.lua")

print(E)

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
		
		if #o1 == 0 and #o2 == 0 then return true
		elseif #o1 == 0 then return false
		else
			for key, value in pairs(o1) do
				return equal(value, o2[key])
			end
		end
	else
		error("Can't make that comparison")
	end
end

-- These print out 'true'.
print(equal(E, examples))
print(equal(A, a))
print(equal(B, b))
print(equal(Z, z)) -- should output 'false'.


