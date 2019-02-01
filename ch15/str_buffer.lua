
local M = {}

function M.buffer ()
	local result = {}
	
	return {
		add =
		function (fmt, ...)
			result[#result + 1] = string.format(fmt, ...)
		end,
		
		flush =
		function ()
			local str = table.concat(result)
			result = {}
			return str
		end,
	}
end

return M