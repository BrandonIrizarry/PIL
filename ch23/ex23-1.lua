--[[
	Exercise 23.1
	
	Write an experiment to determine whether Lua actually implements 
ephemeron tables. (Remember to call 'collectgarbage' to force a garbage
collection cycle.) If possible, try your code both in Lua 5.1 and in
Lua 5.2/5.3 to see the difference.
]]


-- 'use_weak_keys' is a boolean saying we should make 'a' an ephemeron table.

-- Note that, if I try to save the current value of key as key_1 (say, for some
-- future comparison), the object that 'key' points to, now has another external
-- reference, and therefore won't be collected.
function experiment (use_weak_keys)
	local a = {}
	
	if use_weak_keys then
		local mt = {__mode = "k"}
		setmetatable(a, mt)
	end

	-- Follow the very first example in the chapter, but have 'key' also
	-- be used as/involved in a strong reference!
	key = {}
	a[key] = key

	key = {}
	a[key] = key

	-- Force a garbage collection cycle.
	collectgarbage()

	-- Count the number of remaining elements in 'a'.
	local count = 0
	for k, v in pairs(a) do
		count = count + 1
		-- You can optionally call 'print(v)' here.
	end
	
	-- Return that count, especially to see what's going on in Lua 5.1!
	return count
end

-- In any version of Lua, not using weak references at all will result in 
-- two values residing in 'a'.
assert(experiment(false) == 2)

-- Now, let's use weak references:

-- The same weak key-references in 'a' are its strong value-references;
-- Lua 5.1 doesn't forgive this, but Lua 5.2/5.3 do, by implementing
-- ephemeron tables. See below.

-- 'setfenv' is non-nil if and only if this program is run with Lua 5.1.
assert(setfenv and 
	io.write("Using Lua 5.1...") and
	(experiment(true) == 2) or  	-- the same weak key is a strong value,
	io.write("Using Lua 5.2 or Lua 5.3...\n") and
	(experiment(true) == 1))		-- but Lua 5.3 implements ephemeron tables.

print("\nAll tests passed.")


