--[[
	Exercise 15.1
	
	Modify the code in Listing 15.2 so that it indents nested tables.
	(Hint: add an extra parameter to 'serialize' with the indent string.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch15/ex15-1.lua"] = nil
	dofile("/home/brandon/PIL/ch15/ex15-1.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

function serialize (obj)
	local type_obj = type(obj)
	
	if type_obj == "number" or
		type_obj == "string" or
		type_obj == "boolean" or
		type_obj == "nil" then
		
		fmt_write("%q", obj)
	elseif type_obj == "table" then
		io.write("{\n")
		
		for k,v in pairs(obj) do
			io.write(" ", k, " = ")
			serialize(v)
			io.write(",\n")
		end
		
		io.write("}\n")
	else
		error("cannot serialize a " .. type_obj)
	end
end
