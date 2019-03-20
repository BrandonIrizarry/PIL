--[[
	Exercise 23.3
	
	Imagine you have to implement a memorizing table for a function from 
strings to strings. Making the table weak will not do removal of entries,
because weak tables do not consider strings as collectible objects. How can you
implement memorization in that case?
]]

-- Let's write a function that returns an all-uppercased version of a string.
-- Memorize the computed results in this table.
local uppercase_words = {}

-- Make table references to objects that are _values_ in 'uppercase_words', weak.
setmetatable(uppercase_words, {__mode = "v"})

function compute_upper (word)
	
	local all_caps_thunk = uppercase_words[word]
	
	if all_caps_thunk == nil then
		local all_caps = string.gsub(word, "%l", function (c)
			return string.char(string.byte(c) - 32)
		end)
		
		uppercase_words[word] = function () return all_caps end
	end
	
	-- If we return a string here, there will be no external references at all
	-- to the thunks in the memorization table, and therefore all
	-- such thunks will get garbage collected, so be careful what you do!
	return uppercase_words[word]
end
	
-- Note that the following are references to thunks returning strings,
-- not the strings themselves.
w1 = compute_upper("the anthem is the theme")
w2 = compute_upper("Lua Pattern Modifiers")
w1 = compute_upper("This has nothing to do.")

-- Force a garbage collection cycle.
collectgarbage()

-- Now "the anthem is the theme" has no reference external to the memorization
-- table, and so it won't show up here.
for entry, thunk in pairs(uppercase_words) do
	print(entry ,thunk()) 
end
