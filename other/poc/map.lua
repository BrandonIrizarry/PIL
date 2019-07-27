local M = {}

function M.map (fn, t)
	local t_copy = {} -- tbc
	
	for key, value in pairs(t) do
		if type(value) == "table" then
			t_copy[key] = M.map(fn, value)
		else
			t_copy[key] = fn(value)
		end
	end
	
	return t_copy
end

-- Only performs a side-effect on table values.
function M.foreach (fn, t)
	for key, value in pairs(t) do
		if type(value) == "table" then
			M.foreach(fn, value)
		else
			fn(value)
		end
	end
end

--return M

--[[
t = {
	'a', 'b', 'c',
	{
		'd', 'e','f',
	},
	{	
		'g', 'h', 'i',
	},
	'j','k',
	{ 
		{
			'l', 'm', 'n', 'o',
		},
		'p', 'q', 'r','s',
	},
}

tn = M.map(string.upper, t)
M.foreach(print, M.map(string.upper, t))
--]]

return M