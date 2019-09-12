local socket = require "socket"

local host = "www.lua.org"
local file = "/manual/5.3/manual.html"

local connection = assert(socket.connect(host, 80))

do
	local contents = [[
GET %s HTTP/1.0
host: %s

]]

	connection:send(string.format(contents, file, host))
end

function run ()
	repeat
		local s, status, partial = connection:receive(2^10)
		io.write(s or partial)
	until status == "closed"
end

-- Do we ever see "timeout" in this example?
function run2 ()
	repeat
		local s, status, partial = connection:receive()
		io.write(status or "no status", "\n", s or partial, "\n")
	until status == "closed"
end

run2()

connection:close()