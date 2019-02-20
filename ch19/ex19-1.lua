--[[
	Exercise 19.1
	
	Generalize the Markov-chain algorithm so that it can use any size
for the sequence of previous words used in the choice of the next word.
]]
math.randomseed(os.time())

local PREFIX_LENGTH = arg[1]
io.input(arg[2] or io.stdin) -- first argument to script is file to read from (if omitted, use io.stdin.)


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

function make_prefix (W)
	return table.concat(W, " ")
end

-- This pushes a new element _in_ from the right, as it were.
function push (W, nextword)
	table.move(W, 2, #W, 1)
	W[#W] = nextword
end

local state_table = {}

function insert (prefix, value)
	local list = state_table[prefix]
	
	if list == nil then
		state_table[prefix] = {value}
	else
		list[#list + 1] = value
	end
end

-- The main program.

local MAXGEN = 200
local NOWORD = "\n"

-- Use a prefix table W.
function new_prefix_table ()
	local W = {}
	
	for i = 1, PREFIX_LENGTH do
		W[i] = NOWORD
	end
	
	return W
end

local W = new_prefix_table()

for nextword in allwords() do
	insert(make_prefix(W), nextword)
	push(W, nextword)
end

insert(make_prefix(W), NOWORD)

-- generate text
X = new_prefix_table()

for i = 1, MAXGEN do
	local list = state_table[make_prefix(X)]
	local r = math.random(#list)
	local nextword = list[r]
	if nextword == NOWORD then return end
	io.write(nextword, " ")
	push(X, nextword)
end