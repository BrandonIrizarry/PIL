--[[
	Exercise 10.3

	Write a function 'transliterate'. This function receives a string and
replaces each character in that string with another character, according
to a table given as a second argument. If the table maps 'a' to 'b', the
function should replace any occurrence of 'a' with 'b'. If the table maps
'a' to 'false', the function should remove occurences of 'a' from the
resulting string.
]]


function transliterate (str, map)
	return (str:gsub("(.)", function (c)
		local val = map[c]

		if val == false then
			return ""
		else
			return val
		end
	end))
end

map = {a = "A", C = "c", ["2"] = "3", t = false}

example = "Catch 22"

print(transliterate(example, map))
print(transliterate("", map))
