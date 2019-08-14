return function (co)
	return function (co, idx)
		idx = idx + 1
		
		local func
		
		if co then
			func = debug.getinfo(co, 1, "f")
		else
			func = debug.getinfo(2, "f")
		end

		local name, value = debug.getupvalue(func, idx)
		if not name then break end	
		
		return idx, name, value
	end, co, 0
end

