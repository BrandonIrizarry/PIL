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


local SIZE = 10^7

function run_script (sp_arg, ssm_arg)

	-- 25-26K.
	print(collectgarbage("count") * 1024)

	start_time = os.clock()
	
	collectgarbage("setpause", sp_arg)
	collectgarbage("setstepmul", ssm_arg)

	local a = {}
	
	--[[setmetatable(a, {__mode = "k"})]]
	collectgarbage("stop")
	
	for i = 1, SIZE do
		a[i] = {}
	end
	
	print(collectgarbage("isrunning"))
	
	for i = SIZE+1, 2*SIZE do
		a[i] = {}
	end
	
	print(collectgarbage("isrunning"))
	
	for i = 2*SIZE+1, 3 * SIZE do
		a[i] = {}
	end
	
	print(collectgarbage("isrunning"))

	
	-- How much memory have we accumulated?
	print(collectgarbage("count") * 1024)
	
	-- Print how long the code took to run.
	--[[local msg = string.format("Time, with '%s' set to %s:", cg_arg, data)]]
	local msg = string.format("time, with pause: %s, stepmul: %s", sp_arg, ssm_arg)
	print(msg, os.clock() - start_time)
end


run_script(200, 200)