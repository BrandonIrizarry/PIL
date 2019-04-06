local A = require "async-as-sync"
local run, putline, getline = A.run, A.putline, A.getline

-- Now, begin the code.

run(function ()
	local LINES = {}
	local inp = io.input()
	local out = io.output()
	
	while true do
		local line = getline(inp)
		if not line then break end
		LINES[#LINES + 1] = line
	end
	
	for i = #LINES, 1, -1 do
		putline(out, LINES[i] .. "\n")
	end
end)