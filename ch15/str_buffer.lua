
local M = {}

function M.str_buffer ()
	local result = {}
	
	return {
		add = 
		function (fmt, ...)
			result[#result + 1] = string.format(fmt, ...)
		end,
		
		fetch =
		function ()
			local str = table.concat(result)
			result = {}
			return str
		end,
	}
end


local function tests ()
	B = str_buffer()
	B.add("{\n\t%s", "tree")
	B.add("\n\t%s", "house")
	s = B.fetch()
	print(s)

	B.add("%d", 5)
	r = B.fetch()
	print(r)
end

return M