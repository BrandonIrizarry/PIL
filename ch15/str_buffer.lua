
local M = {}


local buffer = {}

function M.add (fmt, ...)
	buffer[#buffer + 1] = string.format(fmt, ...)
end

function M.flush ()
	local str = table.concat(buffer)
	buffer = {}
	return str
end

return M