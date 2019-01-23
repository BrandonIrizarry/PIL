days = { 
			"Sunday",
			"Monday",
			"Tuesday",
			"Wednesday",
			"Thursday",
			"Friday",
			"Saturday"
}


-- Get the index of a particular day of the week.
-- Simple example, could be something else:
-- keys: substance, values: how much it's worth per kilogram.
-- Problem: Find out how much a given substance is worth per kilogram,
-- or at least its ranking index in a list (higher = worth more.)


stuff = io.open("most_expensive_subst.txt", "r"):read("a")

things = {}

for thing in stuff:gmatch("%s?(.-)%f[,]") do
	things[#things + 1] = thing
end

for i = 1, #things do
	print(things[i])
end