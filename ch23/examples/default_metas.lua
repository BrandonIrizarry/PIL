local mtS = setmetatable({}, {__mode = "v"})

function set_default (table_a, defval)
	local redirect = mtS[defval]
	
	if redirect == nil then
		redirect = {__index = function () return defval end}
		mtS[defval] = redirect -- memorize/cache the value
	end
	
	setmetatable(table_a, redirect)
end