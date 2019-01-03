--[[
	Exercise 12.4

	Write a function that takes a year and returns the day of its first Friday.
]]

function first_friday (year_given)
	local new_date = {year = year_given, month = 1, day = 1} -- start at Jan. 1
	local fmt = "%c" -- keep it simple. :)

	while true do
		new_date = os.date("*t", os.time(new_date)) -- load 'new_date' with all fields.

		if new_date.wday == 6 then -- does 'new_date' fall on a Friday?
			return new_date.day -- if so, done.
		end

		new_date.day = new_date.day + 1 -- if not, go to next day.
	end
end

-- A simple test.


function test_on_year (year)
	local suffix = "th" --  most ordinals end with "th".
	local day = first_friday(year)

	-- use a grammatically correct suffix for the ordinal.
	if day == 1 then
		suffix = "st"
	elseif day == 2 then
		suffix = "nd"
	elseif day == 3 then
		suffix = "rd"
	end

	print(string.format("The first Friday in %d falls on the %d%s.", year, day, suffix))
end

local years = {
	1979,
	1980,
	1981,
	1985,
	1986,
	1999,
	2018,
	2019,
	2038,
}

for _, year in ipairs(years) do
	test_on_year(year)
end

--[[
	Another interesting function: given a year and a month (numeric),
return the third Wednesday of that month. :)
	We need only return the day (e.g., 16, 21, etc.)
]]

function third_wednesday (year_given, month_given)
	local new_date = {year = year_given, month = month_given, day = 1}
	local wedn_cnt = 0 -- # of Wednesdays seen so far

	while true do
		new_date = os.date("*t", os.time(new_date))

		if new_date.wday == 4 then
			wedn_cnt = wedn_cnt + 1

			if wedn_cnt == 3 then
				return new_date.day
			end
		end

		new_date.day = new_date.day + 1
	end
end


print(string.format("The third Wednesday in Jan 2019 falls on the %dth.", third_wednesday(2019, 1)))
