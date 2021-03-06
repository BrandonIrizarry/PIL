--[[
	Stop the garbage collector, and call it manually from time to time.
Time: 3.8 secs, an improvement over version b!
]]

collectgarbage("stop")

function collect_some ()
	local leave = collectgarbage("step")
	while not leave do
		leave = collectgarbage("step", 10^10)
	end
end

local start = os.clock()

function print_cols (header, col1, col2)
	io.write(string.format("%-25s%-10s%10s\n", header, tostring(col1), tostring(col2))) 
end

local count = 0

local mt = {__gc = function () count = count - 1 end}
local a = {}

-- Show memory usage before doing any allocation and such.
print_cols("before incrementing count:", collectgarbage("count") * 1024, "count not defined")

local amt = 10^7

for i = 1, amt do
	count = count + 1
end

print_cols("before row allocation:", collectgarbage("count") * 1024, count)

-- Now, this certainly will.
for i = 1, amt do
	local row = {}
	setmetatable(row, mt) -- comment this out to prevent resurrection.
	a[i] = row
end


-- It doesn't look like anything is collectible at this point, but leave it in
-- anyway.


collect_some()

-- Show us the initial value of count, and what amount of memory in bytes
-- Lua is currently using.
print_cols("initial:", collectgarbage("count") * 1024, count)

-- Eliminate the reference 'a', thus losing all of its rows to oblivion.
a = nil

-- Now collect those lost references.
collect_some()

print_cols("after first collect:", collectgarbage("count") * 1024, count)

collect_some()
print_cols("after second collect", collectgarbage("count") * 1024, count)


print_cols("TIME:", os.clock() - start)
