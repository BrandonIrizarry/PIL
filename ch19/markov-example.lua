function allwords ()
	local line = io.read()
	local pos = 1
	
	return function ()
		while line do
			local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
			if w then
				pos = e
				return w
			else
				line = io.read()
				pos = 1
			end
		end
		
		return nil
	end
end

function prefix (w1, w2)
	return w1 .. " " .. w2
end

local statetab = {}

function insert (prefix, value)
	local list = statetab[prefix]
	
	if list == nil then
		statetab[prefix] = {value}
	else
		list[#list + 1] = value
	end
end

-- The main program.

local MAXGEN = 200
local NOWORD = "\n"

local w1, w2 = NOWORD, NOWORD

for nextword in allwords() do
	insert(prefix(w1, w2), nextword)
	w1 = w2; w2 = nextword
end

insert(prefix(w1, w2), NOWORD)

-- generate text
w1 = NOWORD; w2 = NOWORD

for i = 1, MAXGEN do
	local list = statetab[prefix(w1, w2)]
	local r = math.random(#list)
	local nextword = list[r]
	if nextword == NOWORD then return end
	io.write(nextword, " ")
	w1 = w2; w2 = nextword
end