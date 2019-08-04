--[[
receive = coroutine.resume
send = coroutine.yield
times = 3

function producer ()
	return coroutine.create(function ()
		local yy = "hihi"
		
		for i = 1, times do
			local x = io.read()
			send(x)
		end
	end)
end

function filter (prod)
	return coroutine.create(function ()
		local xx = "vexvex"
		
		for line = 1, times do
			local _, x = receive(prod)
			x = string.format("%5d %s", line, x)
			send(x)
		end
	end)
end

function consumer (prod)
	for line = 1, times do
		local _, x  = receive(prod)
		io.write(x, "\n")
	end
end

f = filter(producer())
receive(f)
receive(f)
print(debug.getlocal(f, 2, 1))
--]]

function 

names = {"Brad", "Carly", "Steven", "Erin"}

function get_name ()
	for i = 1, math.huge do
		local n = names[i]
		if not n then break end
		coroutine.yield(n)
	end
end

co = coroutine.create(get_name)

coroutine.resume(co)