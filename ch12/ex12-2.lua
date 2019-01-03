--[[
	Exercise 12.2

	Write a function that returns the day of the week (coded as an integer,
one is Sunday) of a given date.
]]

function day_of_week (raw_time)
	local date = os.date("*t", raw_time)
	return date.wday
end


local examples = {
	os.date("*t", os.time()),
	{year = 2019, month = 1, day = 19},
}

for _, dtable in ipairs(examples) do
	local INDEX = day_of_week(os.time(dtable))

	local codes = {
		"Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday",
	}

	print("\nTEST")
	print(os.date("%c", os.time(dtable)))
	print("The corresponding day of the week is: ", codes[INDEX])
end
