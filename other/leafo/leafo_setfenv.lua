local number = 15

local function lucky()
	print("your lucky number: " .. number)
end

local function fetch_upvalues (fn)
	for idx = 1, math.huge do
		local name, val = debug.getupvalue(fn, idx)
		if not name then break end
		print(name, val)
	end
end

--fetch_upvalues(lucky)

local function really_lucky ()
	--local p = print
end

fetch_upvalues(really_lucky)

local function get_upvalue(fn, search_name)
	for idx = 1, math.huge do
		local name, val = debug.getupvalue(fn, idx)
		if not name then break end
		if name == search_name then
			return idx, val
		end
	end
end

debug.setupvalue(lucky, get_upvalue(lucky, "number"), 22)

lucky()

do
	local p = print
	local new_env = {print = function () p("lucky numbers are closed today") end}
	debug.setupvalue(lucky, get_upvalue(lucky, "_ENV"), _ENV)
end

lucky()
