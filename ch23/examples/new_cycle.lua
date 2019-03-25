do
	local mt = {__gc = function (obj)
		-- whatever you want to do
		print("new cycle")
		-- creates new object for next cycle
		setmetatable({}, getmetatable(obj))
	end}
	
	-- creates first object
	setmetatable({}, mt)
end

local t = {__gc = function ()
	-- your 'atexit' code comes here
	print("Finishing Lua program")
end}

setmetatable(t,t)
_G["*AA*"] = t

-- The third call will create a new object for the next cycle, which 
-- finishes when the Lua state closes; hence _four_ calls to the finalizer
-- result here - unless you use os.exit. That also blocks the 'atexit' code.
collectgarbage()
collectgarbage()
collectgarbage()
os.exit() 