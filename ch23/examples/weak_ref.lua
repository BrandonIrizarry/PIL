local function f()
	local weaktable = {}
	setmetatable(weaktable, { __mode = "v" })
	
		return function()
				local row = weaktable[1]
				
				if not row then
						row = { a = 1 }
						weaktable[1] = row
				end
				
				return row
		end
end

for i=1,10 do
		local t = f()()
		print(t.a)
end