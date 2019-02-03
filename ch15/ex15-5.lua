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
	The following is one solution, but there's a better one if
you 
	1. Pass through the array first with the book's version of save;
	2. Keep that result in an array of strings;
	3. 'load' each non-cyclic/shared entry into memory as a new array
	(and delete it from the array);
	4. Use our ex15-4 version of 'serialize' to serialize that new array;
	5. Write the rest of the array of strings after that serialization.
--]]
	

function write (depth, fmt, ...)
	local tabs = string.rep("\t", depth)
	return io.write(string.format(tabs .. fmt, ...))
end

local VALID = "^[_%a][_%w]*$"

function save (path, value, saved)

	local deferred = {}
	
	local function defer (lhs, rhs)
		deferred[#deferred + 1] = string.format("%s = %s", lhs, rhs)
	end
	
	local saved = saved or {}
	
	local function save_1 (path, value, depth)
		local t = type(value)
		
		if t == "string" or t == "number" or t == "boolean" or t == "nil" then
			write(depth, "%q\n", value)
		elseif t == "table" then
			saved[value] = path
			write(depth, "{\n")
			
			for k,v in pairs(value) do
				if type(k) == "string" and k:match(VALID) then
					local new_path = string.format("%s.%s", path, k)
					
					if saved[v] then 
						defer(new_path, saved[v])
					else
						write(depth + 1, "%s = ", k)
						save_1(new_path, v, depth + 1)
						io.write("\n")
					end
					
				elseif math.type(k) == "integer" then
					local new_path = string.format("%s[%s]", path, string.format("%q", k))
					
					if saved[v] then
						defer(new_path, saved[v])
					else
						save_1(new_path, v, depth + 1)
						io.write("\n")
					end
				else
					local new_path = string.format("%s[%s]", path, string.format("%q", k))
					
					if saved[v] then
						defer(new_path, saved[v])
					else
						write(depth + 1, "[%q] = ", k)
						save_1(new_path, v, depth  + 1)
						io.write("\n")
					end
				end
			end
			
			write(depth, "}\n")
		else
			error("cannot save a " .. t)
		end
	end
			
	save_1(path, value, 0)
	
	deferred[#deferred + 1] = ""
	io.write(table.concat(deferred, "\n"))
end
	
a = {x=3, y=5, {3,4,5}}
a[2] = a
a.z = a[1]

save("a", a)