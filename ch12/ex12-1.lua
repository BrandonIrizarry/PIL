--[[
	Exercise 12.1

	Write a function that returns the date-time exactly one month after a
given date-time. (Assume the numeric coding of date-time.)
]]

function one_month_later (raw_time)
	local date = os.date("*t", raw_time)
	date.month = date.month + 1

	return os.time(date)
end

function test (dtable)
	local raw_time = os.time(dtable)
	local fmt = "%x %I:%M:%S %p"
	print()
	print("TEST")
	print("Given date-time is: ", os.date(fmt, raw_time))

	local later_time = one_month_later(raw_time)

	print("One month later, it'll be: ", os.date(fmt, later_time))
end

local examples = {
	{year = 2019, month = 3, day = 31}, -- March 31
	os.date("*t", os.time()), -- currrent date-time
}

for _, dtable in ipairs(examples) do
	test(dtable)
end


