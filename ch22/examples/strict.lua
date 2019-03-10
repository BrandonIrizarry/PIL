local declaredNames = {} -- set containing the names of user-defined global variables.

-- Setting the error level gives me the right line number for the error - cool!
setmetatable(_G, {
	__newindex = function (g, name, value)
		if not declaredNames[name] then -- attempt to define a new global
			local where = debug.getinfo(2, "S").what

			if where ~= "main" and where ~= "C" then -- attempt is inside a function definition
				error("Attempt to write to undeclared variable " .. name, 2)
			end
			
			declaredNames[name] = true
		end
		
		rawset(g, name, value)
	end,
	
	__index = function (_, name)
		if not declaredNames[name] then
		
			error("Attempt to read undeclared variable " .. name, 2)
		else
			return nil
		end
	end,
})

ok_global = "Alice"

function trip_error ()
	local something
	somethng = 42 -- misspelled; would create an accidental global.
end

local status, msg = pcall(trip_error)
assert(not status)
print(msg)
	
function trip_error2 ()
	local x = 12
	
	return X
end

status, msg =  pcall(trip_error2)
assert(not status)
print(msg)