--[[
	Exercise 12.3

	Write a function that takes a date-time (coded as a number) and
returns the number of seconds passed since the beginning of its respective
day.
]]


function seconds_since_that_midnight (raw_time)
	local date = os.date("*t", raw_time)
	date.hour, date.min, date.sec = 0,0,0 -- reset to midnight

	return os.difftime(raw_time, os.time(date))
end

-- Using date tables is the only way to common-sense specify a date-time.
local examples = {
	os.date("*t", os.time()),
	{year = 2019, month = 1, day = 1, hour = 23, min = 59, sec = 59},
}

for i, dtable in ipairs(examples) do
	print("\nTESTS")
	print(os.date("%c", os.time(dtable)))
	local secs_since = seconds_since_that_midnight(os.time(dtable))
	print(secs_since)

	-- An extra little test for one of the examples.
	local secs_in_day = 24 * 60 * 60

	if i == 2 then -- refer to the second test case.
		assert(secs_since + 1 == secs_in_day)
	end
end

