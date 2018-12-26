--[[
	Exercise 10.1

	Write a function 'split' that receives a string and a delimiter pattern
and returns a sequence with the chunks in the original string separated by
the delimiter:

	t = split("a whole new world", " ")
	-- t = {"a", "whole", "new", "world"}
]]

-- OK - if patterns must not be literal, then we can't just tag them
-- onto the end - we would have to figure out an instance of the pattern,
-- and tag that onto the end.
-- For me, the best solution would be to legitimately find the
-- last occurence of the pattern, and take the substring towards the
-- end as the last token
function split (str, pattern, literal)
	str = str .. pattern
	if literal == nil then literal = true end

	if literal then
		pattern = pattern:gsub("(%W)", "%%%1") -- prepare 'pattern' for use as a literal pattern
	end

	local T = {}

	for token in str:gmatch("(.-)" .. pattern) do
		if token ~= "" then
			T[#T + 1] = token
		end
	end

	return T
end

function make_string(pattern, ...)
	return table.concat({...}, pattern)
end

function print_array (a)
	for _, v in ipairs(a) do
		print(v)
	end
end

pattern = "[=abc=]"
r = make_string(pattern, "blue", "green", "red")
t = split(r, pattern)
print_array(t)

pattern = "[;:. ]"
r = "This;is:something.new !"
t = split(r, pattern, false)
print_array(t)
