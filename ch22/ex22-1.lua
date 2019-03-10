--[[
	Exercise 22.1
	
	The function 'getfield' that we defined in the beginning of this
chapter is too forgiving, as it accepts "fields" like math?sin or
string!!!gsub.
	Rewrite it so that it accepts only single dots as name separators.
]]


local IDENTIFIER = "[%a_][%w_]*"

function get_innermost_field (address)

	-- Scan 'address' for invalid name separators.
	local sep_pat = "()([^%w_]+)"
	
	for pos, sep in address:gmatch(sep_pat) do
		if sep ~= "." then -- separator isn't a single dot
			error("Invalid separator at position " .. pos)
		end
	end
	
	-- Now, the code as usual.
	local curr = _G
	
	for subdir in address:gmatch(IDENTIFIER) do
		curr = curr[subdir]
	end
		
	return curr
end

local examples = {
	"math?sin",
	"string!!!gsub",
	"string..sub",
	"io.read"
}

for _, ex in ipairs(examples) do
	local status, r_msg = pcall(get_innermost_field, ex)
	print(status, r_msg)
end