

local M = {}
local VALID_IDENTIFIER = "^[_%a][_%w]*$"

-- Assumes 'key' is only string, number, boolean, or nil.
function serializeKey (key)
	return string.format("%q", key)
end

function M.StringStack (basename)
	
	local stack = {basename}
	
	return {
	
		push = 
		function (key)
		
			if type(key) == "string" and key:match(VALID_IDENTIFIER) then
				stack[#stack + 1] = string.format(".%s", key)
			else
				stack[#stack + 1] = string.format("[%s]", serializeKey(key))
			end
		end,
		
		pop =
		function ()
			
			local last_key = stack[#stack] -- save the TOS
			local token = last_key:sub(1,1)
			stack[#stack] = nil -- delete the TOS
			
			if token == "." then
				return last_key:sub(2)
			elseif token == "[" then
				local contents = last_key:sub(2, -2) -- within the brackets.
				if tonumber(contents) then return "" else return last_key end
			else
				error("invalid token")
			end
		end,
		
		give =
		function (do_print)
			local result = table.concat(stack)
			if do_print then print(result) end
			return result
		end,
	}
end

return M