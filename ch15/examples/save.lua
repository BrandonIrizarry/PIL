--[[
	Mostly copied from Listing 15.3: Saving tables with cycles.
]]

local M = {}

local function basicSerialize (o)
	-- assume 'o' is a number or string
	return string.format("%q", o)
end

local out = io.stdout 

function M.output (filename)
	local outstream = assert(io.open(filename, "w"))
	out = outstream
end

function M.flush ()
	out:flush()
end
	
function M.save (name, value, saved)
	saved = saved or {}  -- initial value
	out:write(name, " = ")
	
	if type(value) == "number" or
		type(value) == "string" or
		type(value) == "boolean" or
		type(value) == "nil" then
		out:write(basicSerialize(value), "\n")
	elseif type(value) == "table" then
		if saved[value] then  -- value already saved?
			out:write(saved[value], "\n")  -- use its previous name
		else
			saved[value] = name  -- save name for next time
			out:write("{}\n")  -- create a new table
			
			for k,v in pairs(value) do  -- save its fields
				k = basicSerialize(k)
				local fname = string.format("%s[%s]", name, k)
				save(fname, v, saved)
			end
		end
	else
		error("cannot save a " .. type(value))
	end
end

return M