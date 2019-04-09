local A = require "async-as-sync"
local run, putline, getline = A.run, A.putline, A.getline

-- Now, begin the code.


function reverse_lines ()
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
end

run(reverse_lines)
--print("Done with first session; begin second session")
--run(reverse_lines)

