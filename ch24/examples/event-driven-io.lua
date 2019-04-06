local lib = require "async-lib"

local LINES = {} 
local inp = io.input()
local out = io.output()
local line_ptr

-- the write-line handler
local function putline ()
	line_ptr = line_ptr - 1
	
	if line_ptr == 0 then 	-- no more lines?
		lib.stop()			-- finish the main loop.
	else					-- write line and prepare next one.
		lib.writeline(out, LINES[line_ptr] .. "\n", putline)
	end
end

-- the read-line handler
local function getline (line)
	if line then					-- not EOF?
		LINES[#LINES + 1] = line	-- save line.
		lib.readline(inp, getline)	-- read next one.
	else
		line_ptr = #LINES + 1		-- prepare write-loop.
		putline()					-- enter write-loop.
	end
end

lib.readline(inp, getline)			-- ask to read first line.
lib.runloop()						-- run the main loop.