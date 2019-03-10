local IDENTIFIER = "[%a_][%w_]*"

function get_innermost_field (address)
	local curr = _G
	
	for subdir in address:gmatch(IDENTIFIER) do
		curr = curr[subdir]
	end
		
	return curr
end

function set_innermost_field (address, value)
	local curr = _G
	
	for subdir, maybe_dot in address:gmatch("("..IDENTIFIER..")(%.?)") do
		if maybe_dot == "." then -- if not the last name
		
			-- "I'm listed as a key-value pair in _G, therefore I exist."
			-- Create the needed definition.
			curr[subdir] = curr[subdir] or {} 
			
			-- The next table in the address is a value keyed by 'subdir'.
			curr = curr[subdir] 
		else
			curr[subdir] = value
		end
	end
end

print(get_innermost_field("io.read"))

set_innermost_field("t.x.y", 10)

print(t.x.y)