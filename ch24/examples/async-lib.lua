local cmdQueue = {} -- queue of pending operations

local lib = {}

function lib.readline (stream, callback)
	local nextCmd = 
		function ()
			return callback(stream:read())
		end
	
	table.insert(cmdQueue, nextCmd)
end

function lib.writeline (stream, line, callback)
	local nextCmd = 
		function ()
			return callback(stream:write(line))
		end
		
	table.insert(cmdQueue, nextCmd)
end

function lib.stop ()
	table.insert(cmdQueue, "stop")
end

function lib.runloop ()
	while true do
		local nextCmd = table.remove(cmdQueue, 1)
		if nextCmd == "stop" then
			break
		else
			print(nextCmd()) -- perform next operation; "goto yield in getline/putline."
			-- note that the yields ultimately come back _here_, which is how the event loop
			-- is even able to proceed in the first place.
		end
	end
end

function lib.show_queue ()
	for _, cmd in ipairs(cmdQueue) do
		io.write(tostring(cmd), " ")
	end
	io.write(tostring(#cmdQueue))
	io.write("\n")
end

return lib