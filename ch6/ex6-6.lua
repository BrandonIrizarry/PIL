--[[
	Exercise 6.6

	Sometimes, a language with proper tail calls is called _properly tail recursive_, with
the argument that this property is relevant only when we have recursive calls. (Without
recursive calls, the maximum call depth of a program would be statically fixed.)
	Show that this argument does not hold in a dynamic language like Lua: Write a program
that performs an unbounded call chain without recursion. (Hint: See section 16.1)
]]

-- The chunk we use to populate the array.
-- Note that each resulting function returned by a call to load has a different
-- hash, and so we indeed _aren't_ calling the same function recursively.
local chunk = "print('N is ', N, 'T[N] is', T[N]); N = N - 1; return T[N]()"

-- Initialize the array with the base case.
T = {function () print("Done") end}

-- Read in a number, and popluate the array with the compiled chunks.
N = tonumber(io.read())
for i = 2, N do
	T[i] = load(chunk)
end

-- Initialize the call chain.
T[N]()

