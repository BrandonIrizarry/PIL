-- Print tables with locals/upvalues format (Exercise 25.3).
return function (t_)
	for level, set in ipairs(t_) do
		print("LEVEL: ", level)

		for _,row in ipairs(set) do
			print(row.name, row.value)
		end
	end
end