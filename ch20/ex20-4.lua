--[[
	Exercise 20.4
	
	Proxy tables can represent other kinds of objects besides tables.
Write a function 'fileAsArray' that takes the name of a file and returns
a proxy to that file, so that after a call 

	t = fileAsArray("myFile")

an access to t[i] returns the i-th byte of that file, and an assignment
to t[i] updates its i-th byte.
]]


local mt = {}
local proxy_table = {}

-- Note: accessing is one-indexed.
mt.__index = function (p, k)
	assert(math.type(k) == "integer" and k >= 1)
	
	local filename = proxy_table[p]
	local instream = assert(io.open(filename)) -- open file for reading
	instream:seek("set", k - 1)
	local byte = instream:read(1)
	instream:close()
	
	return byte
end


mt.__newindex = function (p, k, v)
	assert(math.type(k) == "integer" and k >= 1)
	assert(type(v) == "string" and #v == 1)
	
	local filename = proxy_table[p]
	local instream = assert(io.open(filename))
	local intext = instream:read()
	instream:close()
	
	local left = intext:sub(1, k-1)
	local right = intext:sub(k+1)
	local outtext = left .. v .. right
	
	local outstream = assert(io.open(filename, "w"))
	outstream:write(outtext)
	outstream:close()
end

function fileAsArray (filename)
	local proxy = {}
	setmetatable(proxy, mt)
	proxy_table[proxy] = filename
	
	return proxy
end

-- Usage.
local t = fileAsArray("examples/file.txt")

t[1] = "Z"
t[2] = "R"
t[5] = "W"
t[8] = "Q"
t[3] = "A"
print(t[1], t[2], t[5], t[8], t[3], t[100])