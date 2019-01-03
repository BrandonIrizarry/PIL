--[[
	Exercise 12.4

	Write a function that takes a year and returns the day of its first Friday.
]]

function first_friday (year_given)
	local new_date = {year = year_given, month = 1, day = 1} -- start at Jan. 1
	local fmt = "%c" -- keep it simple. :)

	while true do
		new_date = os.date("*t", os.time(new_date)) -- load with all fields.

		if new_date.wday == 6 then -- Friday?
			return os.date(fmt, os.time(new_date)) -- done.
		end

		new_date.day = new_date.day + 1 -- still here, go to next day.
	end
end

-- A simple test.
print(first_friday(2019))
