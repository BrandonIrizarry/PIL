--[[
	Exercise 12.5

	Write a function that computes the number of complete days between two given dates.
]]

function num_complete_days (date1, date2)
	local t1, t2 = os.time(date1), os.time(date2)

	return math.abs(os.difftime(t1, t2)) // (24 * 3600)
end


local examples = {
	{
		d1 = os.date("*t", os.time()),
		d2 = {year = 2019, month = 1, day = 15, hour = 17}
	},

	{
		d1 = {year = 1981, month = 1, day = 19}, -- my birthday.
		d2 = os.date("*t", os.time()),  -- what ever could I be calculating? ;)
	},
}

-- Returns the conventional string representation of a date-table.
local function c_date (dtable)
	return os.date("%c", os.time(dtable))
end

for _, endpoints in ipairs(examples) do
	local d1, d2 = endpoints.d1, endpoints.d2
	local msg = string.format(
		"\n%s\n%s\n%d complete days.",
		c_date(d1),
		c_date(d2),
		num_complete_days(d1, d2))
	io.write(msg, "\n")
end
