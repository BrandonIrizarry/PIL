--[[
	Exercise 12.7

	Does adding one month and then one day to a given date give the same result
as adding one day and then one month?
]]

function c_date (dtable)
	return os.date("%c", os.time(dtable))
end

local D1 = {year = 2019, month = 3, day = 31} -- March 31st
local d

function reset_date ()
	d = os.date("*t", os.time(D1))
end

--[[
	The test.
	The test date-time 'd' is initialized to March 31st (a valid date),
representable as "3 31".  Adding one to both fields yields "4 32", which
normalizes to "5 2".
	However, "3 32" normalizes to "4 1", and adding a month to that yields
"5 1".  Yet, "4 31" normalizes to "5 1", and adding a day to that yields
"5 2".  So, no, the operations described in the problem statement can't be applied
in an arbitrary order - they don't always give the same result, if we normalize
between steps.
]]

-- Add a day, normalize, then add a month.
reset_date ()
d.day = d.day + 1
os.time(d) -- normalize
d.month = d.month + 1
print(c_date(d))

-- Add a month, normalize, then add a day.
reset_date ()
d.month = d.month + 1
os.time(d) -- normalize
d.day = d.day + 1
print(c_date(d))

