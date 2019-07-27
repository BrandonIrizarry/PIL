function escape (str)
	return (str:gsub("()(.)", function (index, char)
		local col_number = index % 20
		local hf = "\\x"..string.format("%02X", string.byte(char))
		return (col_number == 0 and (hf.."\\z\n")) or hf
	end))
end

local glossary = {
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\b"] = "\\b",
	["\\"] = "\\\\",
	["\r"] = "\\r",
}

local keywords = {
	["end"] = true,
}

function make_printable (str)
	return str:gsub(".", function (c)
		return glossary[c] or c
	end)
end

LUA_IDENTIFIER = "^[%a_][%w_]*$"
_DUMPED = {}

function force_valid_key (str)
	str = make_printable(str)
	
	if str:match(LUA_IDENTIFIER) and (not keywords[str]) then
		return str
	else
		return '["'..str..'"]'
	end
end

local message = "hi"

t = {
	mf = function () return 42 end,
	["m("] = function () return 1 end,
	["\b"] = function () return message end,
	ret = {1,2,3, cr = function () return "run" end},
	del = "esc",
}

-- This works.
--print(t.mf(), t["m("](), t["\b"]())

function serialize (obj)
	local _type = type(obj)
	if _type == "number" or
		_type == "string" or
		_type == "boolean" or
		_type == "nil" then
		return string.format("%q", obj)
	elseif _type == "table" then
		local result_buffer = {}
		table.insert(result_buffer, "{\n")
		
		for key, value in pairs(obj) do
			--if key == "cright" then
			--	utils.alert(key, type(key), string.format("%q", key), force_valid_key(key))
			--end
			if type(key) == "string" then
				table.insert(result_buffer, " "..force_valid_key(key).." = ")
			else
				table.insert(result_buffer, " ["..string.format("%q", key).."]".." = ")
			end
			
			table.insert(result_buffer, serialize(value))
			table.insert(result_buffer, ",\n")
		end
		table.insert(result_buffer, "}\n")
		return table.concat(result_buffer)
	elseif _type == "function" then
		local what = debug.getinfo(obj, "S").what
		if what == "C" then
			obj = function () obj() end
		end
		
		--local serialized_fn = escape(string.dump(obj))
		local serialized_fn = string.dump(obj)
		_DUMPED[serialized_fn] = true
		--return '"'..serialized_fn..'"'
		return '"'..escape(serialized_fn)..'"'
	end
end

--[[
ts = serialize(t)

tb = load("return "..ts)()
--]]

function revive (val)
	if _DUMPED[val] then
		return load(val)
	else
		return val
	end
end
	
do
	local m = require "map"
	map = m.map
	foreach = m.foreach
end

--tb = map(revive, tb) -- this works as expected.

function sr (t)
	local tb = load("return "..serialize(t))()
	return map(revive, tb)
end


function table_equal (T_1, T_2)
	for k_1, v_1 in pairs(T_1) do
		if (type(v_1) ~= "table") and v_1 ~= T_2[k_1] then
			return false, {k_1, v_1, T_2[k_1]}
		elseif type(v_1) == "table" then
			local result, status = table_equal(v_1, T_2[k_1])
			if result == false then
				return false, status
			end
		end
	end
	
	return true, {"success"}
end


		

--res1, status1 = table_equal({1,2,3, function () end}, {1,2,3, function () end})
--print(table.unpack(status1))
--print(table_equal(t, load("return "..serialize(t))()))

function s_fns (t)
	return map(function (val) 
		if type(val) == "function" then 
			return string.dump(val)
		else
			return val
		end
	end, t)
end


res2, status2 = table_equal(s_fns(t), load("return "..serialize(t))())
print(table.unpack(status2))

-- Unrelated (more basic.)
function round_trip_fn (fn)
	local fn_ser = '"'..escape(string.dump(fn))..'"'
	local orig = load("return "..fn_ser)()
	return load(orig)
end

--assert(fn() == round_trip(fn)())
--]]