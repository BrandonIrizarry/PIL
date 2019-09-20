local socket = require "socket"

local function receive1 (connection)
	local str, status, partial = connection:receive(2^10)
	return str or partial, status
end

local function receive2 (connection)
	connection:settimeout(0)
	local str, status, partial = connection:receive(2^10)
	
	if status == "timeout" then
		coroutine.yield(connection)
	end
	
	return str or partial, status
end


local function download (host, file, serial)
	local contents = [[
GET %s HTTP/1.0
host: %s

]]

	local connection = assert(socket.connect(host, 80))
	local count = 0 -- count number of bytes read
	local request = string.format(contents, file, host)

	connection:send(request)
	
	local receive = serial and receive1 or receive2
	
	repeat
		local str, status = receive(connection)
		count = count + #str
	until status == "closed"
	
	connection:close()
	print(file, count)
end

return download
