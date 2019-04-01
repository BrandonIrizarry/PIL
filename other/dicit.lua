

local dictionary = {
	add = function (x, y)
		return x + y
	end,
	
	sub = function (x, y)
		return x - y
	end,
	
	mul = function (x, y)
		return x * y
	end,
	
	div = function (x, y)
		return x // y
	end,
}

local arities = setmetatable({}, {__index = function (_, word)
	if word == "add" or word == "sub" or word == "mul" or word == "div" then
		return 2
	elseif tonumber(word) then
		return 0
	else
		return -1
	end
end})

stack = "1 2 add 4 sub kick"

-- Current live state of the stack is stored here.
_context = {}

context = setmetatable({}, {__index = function (_, word)
	if arities[word] == 0 then
		table.insert(_context, dictionary[word])
	elseif arities[word] == 1 then
		local fvalue = dictionary[word]
		local arg = table.remove(_context)
		table.insert(_context, fvalue(arg))
	elseif arities[word] == 2 then
		local fvalue = dictionary[word]
		local arg1 = table.remove(_context)
		local arg2 = table.remove(_context)
		table.insert(_context, fvalue(arg1, arg2))
	end
end})
	



values = setmetatable( dictionary, 
	{__index = function (_, word) 
		return tonumber(word) or -1
end})
		
		
for word in stack:gmatch("%S+") do
	--print(word, dictionary[word])
	--print(word, dictionary[word])
	table.insert(context, word)
end

for k,v in ipairs(_context) do
	print(k,v)
end

-- Nothing gets added so far.
-- The function arities should really take care of themselves!
print(#_context)

