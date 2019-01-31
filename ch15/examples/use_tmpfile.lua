

text = [[
Roses are red,
Violets are blue;
Sugar is sweet,
And so are you!
]]


--[[
f = assert (io.tmpfile ()) -- open temporary file
f:write (text)  -- write to it
f:seek ("set", 0) -- back to start - don't omit this!
s = f:read ("a")  -- read all of it back in
--print (s)  -- print out
f:close ()  -- close file

--]]

fstream = assert(io.tmpfile())
io.output(fstream)
io.write(text)
fstream:seek("set") 
s = fstream:read("a")
print(s)
