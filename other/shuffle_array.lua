
t1 = {1,2,3,4}

function shuffle_array (t)
	table.sort(t,
		function (a, b)
			local x = math.random()
			local y = math.random()
			local message = string.format("%s,%s: %s\t%s", tostring(a), tostring(b), tostring(x), tostring(y))
			print(message)
			return x > y
		end)
end

function print_array (t)
	for _,v in ipairs(t) do
		print(v)
	end
end
