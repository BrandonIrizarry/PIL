--[[
	Exercise 12.6

	Write a function that computes the number of complete months between two given dates.
]]

--[[
	Use a brute algorithm to count up a date, month by month, to the
greater of the two dates. When A > B, return count - 1.
	Assume 'date1' comes chronologically before 'date2'.
]]

function num_complete_months (date1, date2)

	for i = 1, math.huge do
		date1.month = date1.month + 1 -- increment the month

		if os.time(date1) > os.time(date2) then
			return i - 1
		end
	end
end

--[[
	You can't pass NOW as both arguments to 'num_complete_months'. A deep
copy of 'NOW' is needed for one of the arguments, or else date1 and date2 will
be references to the same table: incrementing date1.month also increments
date2.month, and an infinite loop results.
]]

local NOW_1 = os.date("*t", os.time())
local NOW_2 = os.date("*t", os.time(NOW_1))

local examples = {
	{
		d1 = { year = 2018, month = 4, day = 3 },
		d2 = NOW
	},

	{
		d1 = { year = 1981, month = 1, day = 1 },
		d2 = NOW
	},

	{
		d1 = { year = 2019, month = 3, day = 31 },
		d2 = { year = 2019, month = 4, day = 31 } -- tricky example.
	},

	{
		d1 = { year = 2019, month = 4, day = 1 },
		d2 = { year = 2019, month = 5, day = 1 },
	},

	{
		d1 = { year = 2018, month = 1, day = 1 },
		d2 = { year = 2019, month = 1, day = 1, hour = 11} -- short by 1 hour, should return 11.
	},

	{
		d1 = NOW_1,
		d2 = NOW_2 -- should return a count of zero.
	},
}

-- Return a conventional string representation of a date table.
function run_tests ()
	local function c_date (dtable)
		return os.date("%c", os.time(dtable))
	end

	for i, endpoints in ipairs(examples) do
		local d1, d2 = endpoints.d1, endpoints.d2
		local msg = string.format(
	[[

		First date: %s
		Second date: %s
		Number of complete months: %d
	]],
			c_date(d1),
			c_date(d2),
			num_complete_months(d1, d2))

	io.write(msg, "\n")
	end
end

run_tests()
