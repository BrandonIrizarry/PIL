
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
	-- be used as a strong reference in 'a'.
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

-- 'setfenv' is non-nil if and only if this program is run with Lua 5.1.
assert(experiment(false) == 2)
assert(setfenv and 
	io.write("Using Lua 5.1...") and
	(experiment(true) == 2) or  	-- the same weak key is a strong value,
	io.write("Using Lua 5.2 or Lua 5.3...") and
	(experiment(true) == 1))		-- but Lua 5.3 implements ephemeron tables.

print("\nAll tests passed.")


