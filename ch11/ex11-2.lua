--[[
	Exercise 11.2

	Repeat the previous exercise but, instead of using length as
the criterion for ignoring a word, the program should read from a
text file a list of words to be ignored.
]]

-- Set up the words to be ignored in the word count.
local ign_strm = io.open("ignore.txt", "r")

local ignores = {}
for word in ign_strm:lines() do
	ignores[word] = true
end

-- Begin the main part of the program.
local counter = {}

--local filter = string.rep("%w", 4) .. "+"

for line in io.lines() do
	for word in string.gmatch(line, "%w+") do
		if not ignores[word] then -- only count non-ignored words.
			counter[word] = (counter[word] or 0) + 1
		end
	end
end

local words = {} -- sorting needs a proper list

for w in pairs(counter) do
	words[#words + 1] = w -- load 'words' with the keys from 'counter'
end

table.sort(words, function (w1, w2)
	return counter[w1] > counter[w2] or
		counter[w1] == counter[w2] and w1 < w2
end)

-- number of words to print
local n = math.min(tonumber(arg[1]) or math.huge, #words)

for i = 1, n do
	io.write(words[i], "\t", counter[words[i]], "\n")
end

