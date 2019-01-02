function reload ()
	package.loaded["/home/brandon/PIL/ch12/chapter_examples/epoch_stats.lua"] = nil
	dofile("/home/brandon/PIL/ch12/chapter_examples/epoch_stats.lua")
end

function epoch_stats ()
	local date = os.time()
	local days_in_year = 365.242
	local seconds_in_hour = 60 * 60
	local hours_in_day = 24
	local seconds_in_day = seconds_in_hour * hours_in_day
	local seconds_in_year = seconds_in_hour * hours_in_day * days_in_year
	print("Raw epoch-time: ", date)
	print("Current UTC year: ", date // seconds_in_year + 1970)
	print("Current UTC hour: ", date % seconds_in_day // seconds_in_hour)
	print("Current UTC minute: ", date % seconds_in_hour // 60)
	print("Current UTC seconds: ", date % 60)
end
