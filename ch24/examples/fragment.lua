local A = require "async-as-sync"
local run, putline, getline = A.run, A.putline, A.getline
local lines = A.lines

-- Now, begin the code.

function reverse_lines ()
	local LINES = {}
	local inp = io.input("fragment.lua")
	local out = io.output()
	
	--[[
	while true do
		local line = getline(inp)
		if not line then break end
		LINES[#LINES + 1] = line
	end
	--]]
	
	---[[
	for line in lines(inp) do
		LINES[#LINES + 1] = line
	end
	--]]
	
	for i = #LINES, 1, -1 do
		putline(out, LINES[i] .. "\n")
	end
end

run(reverse_lines)