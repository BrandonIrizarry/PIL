--[[
	Exercise 5.3

	Suppose that you want to create a table that maps
each escape sequence for strings (Section 4.1) to
its meaning. How could you write a constructor for that
table?
]]

escape_sequences = {
	["\\a"] = "bell",
	["\\b"] = "back space",
	["\\f"] = "form feed",
	["\\n"] = "newline",
	["\\r"] = "carriage return",
	["\\t"] = "horizontal tab",
	["\\v"] = "vertical tab",
	["\\"] = "backslash",
	["\\\""] = "double quote",
	["\\'"] = "single quote",
}

-- We could now print out the escape sequences and their meanings,
-- but they'd be in no particular order. :(
--[[
for seq, meaning in pairs(escape_sequences) do
	print(seq, meaning)
end
--]]

-- However, we can make a "sorter table" to help us print
-- out the table entries in the order we want:

sorter_table = {
	"\\a",
	"\\b",
	"\\f",
	"\\n",
	"\\r",
	"\\t",
	"\\v",
	"\\",
	"\\\"",
	"\\'",
}

for _, v in ipairs(sorter_table) do
	print(v, escape_sequences[v]) -- Now we've got it!
end
