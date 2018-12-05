--[[
	Exercise 5.2

	Assume the following code:
]]

a = {}; a.a = a

--[[
	What would be the value of a.a.a.a?
	Is there any a in that sequence somehow different from the others?

	Now, add the next line to the previous code:

	a.a.a.a  = 3

	What would be the value od a.a.a.a now?

Answer: The first a is the table, and rest are string
keys:
]]

assert(a == a)
assert(a.a == a)
assert(a.a.a == a)
assert(a.a.a.a == a)

-- When Lua sees the assignment statement

a.a.a.a = 3

--[[
	Apparently, Lua evaluates a.a.a.a down to a.a,
and sets that to 3:
]]

assert(a.a == 3)

-- Hence, a.a.a.a would throw an error:

status, error_msg = pcall(function () print(a.a.a.a) end)

assert(status == false)
print(error_msg)
