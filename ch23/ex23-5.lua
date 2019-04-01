--[[
	Exercise 23.5

	For this exercise, you need at least one Lua script that uses
a lot of memory. If you do not have one, write it. (It can be as simple as a 
loop creating tables.)

	1. Run your script with different values for 'pause' and
	'stepmul'. How do they affect the performance and memory usage
	of the script? What happens if you set the pause to zero? What
	happens if you set the pause to 1000? What happens if you set
	the step multiplier to zero? What happens if you set the step
	multiplier to 1000000?

	2. Adapt your script so that it keeps full control over the
	garbage collector.  It should keep the collector stopped and
	call it from time to time to do some work. Can you improve the
	performance of your script with this approach?
]]

local function fmt_write (fmt, ...)
	io.write(string.format(fmt, ...))
end

function mem_usage ()
	local mem = collectgarbage("count") * 1024
	fmt_write("Memory in use: %d\n",  mem)
end

--[[
collectgarbage("setpause", arg[1])
collectgarbage("setstepmul", arg[2])
--]]

collectgarbage("stop")

local start = os.clock()


local a = {}

for i = 1, 10^7 do
	a[i] = {}
	if i % 10^6 == 0 then
		print(collectgarbage("step"))
	end
end

fmt_write("Time: %f\n", os.clock() - start)
