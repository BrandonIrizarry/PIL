local t = {__gc = function ()
	-- your 'atexit' code comes here
	print("Finishing Lua program")
end}

setmetatable(t,t)
_G["*AA*"] = t