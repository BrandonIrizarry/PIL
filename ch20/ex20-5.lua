--[[
	Exercise 20.5
	
	Extend the previous example to allow us to traverse the bytes in the file
with pairs(t) and get the file length with #t.
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

-- The 'f' (iterator/driver) function (see p. 174).
local function iter (instream, k)
	local byte = instream:read(1)
	
	if byte == nil then
		instream:close()
	else
		return k + 1, byte
	end
end
	
mt.__pairs = function (p)
	local filename = proxy_table[p]
	local instream = assert(io.open(filename))
	
	return iter, instream, 0
end
	
mt.__len = function (p)
	local filename = proxy_table[p]
	local file = assert(io.open(filename))
	
	local current = file:seek() -- save current position
	local size = file:seek("end") -- get file size
	file:seek("set", current) -- restore position
	
	return size
end

function fileAsArray (filename)
	local proxy = {}
	setmetatable(proxy, mt)
	proxy_table[proxy] = filename
	
	return proxy
end

-- Usage.
local t = fileAsArray("examples/file.txt")

for i, char in pairs(t) do
	print(i, char)
end

print("Length: ", #t)