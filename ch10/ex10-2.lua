--[[
	Exercise 10.2

	The patterns '%D' and '[^%d]' are equivalent. What about the patterns
'[^%d%u]' and '[%D%U]'?
]]

--[[
	They aren't equivalent, since the first is a predicate that means,
"neither a digit nor an uppercase letter" (e.g. lowercase letters), and the second means,
"either a non-digit, or a non-capital-letter (which includes digits!), or possibly neither."
The second will, in fact, match everything.
]]

-- Example:

example = "Catch 22"
pat_and = "[^%d%u]"
pat_or = "[%D%U]"

T_and = {}
for c in example:gmatch(pat_and) do
	T_and[#T_and + 1] = c
end

assert(table.concat(T_and) == "atch ")

T_or = {}
for c in example:gmatch(pat_or) do
	T_or[#T_or + 1] = c
end

assert(table.concat(T_or) == "Catch 22")

