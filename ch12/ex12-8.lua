--[[
	Exercise 12.8

	Write a function that produces the system's time zone.
]]

function time_zone ()
	return os.date("%z", os.time())
end
