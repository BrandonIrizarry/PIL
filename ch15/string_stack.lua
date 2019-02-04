

local M = {}
local VALID_IDENTIFIER = "^[_%a][_%w]*$"

-- Assumes 'key' is only string, number, boolean, or nil.
function serializeKey (key)
	return string.format("%q", key)
end

function M.StringStack (basename)
	
	local stack = basename
	
	return {
	
		push = 
		function (key)
		
			if type(key) == "string" and key:match(VALID_IDENTIFIER) then
				stack = string.format("%s.%s", stack, key)
			else
				stack = string.format("%s[%s]", stack, serializeKey(key))
			end
		end,
		
		pop =
		function ()
			
			-- See if the last key is .something.
			local last_key = stack:match("%..+$")
			
			if not last_key then
				local NO_LEFT_BRACKET = "[^%[]+"
				local PATTERN = string.format("%%[%s]$", NO_LEFT_BRACKET)
				last_key = stack:match(PATTERN)
			end
			
			-- Remove the last stack item.
			local pos = stack:find(last_key)
			stack = stack:sub(1, pos)
			
			-- Return the appropriate final keying.
			
			
		end,
		
		get_copy =
		function ()
			return stack
		end,
	}
end

return M