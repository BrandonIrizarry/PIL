


S = require("save")
save, output, flush = S.save, S.output, S.flush
a = {9,8,7}
output("scratch_for_tables.lua")
save("a", a)
b = {1,2,3}
save("b", b)
flush()
os.execute("less scratch_for_tables.lua")

-- Erase the predefined values of 'a' and 'b'
a, b = nil

assert((not a) and (not b))

--input("scratch_for_tables.lua")

assert(load(io.lines("scratch_for_tables.lua", "L")))()

for _,v in ipairs(a) do
	print(v)
end

for _, v in ipairs(b) do
	print(v)
end
