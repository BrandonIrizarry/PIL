local coro = require "old_stuff.coro"


function main ()
	local str_buf = {}
	
	print("Start with 'A' or 'B'?")
	local ans = io.read()
	if ans == 'A' then
		table.insert(str_buf, coro.transfer(print_A))
	elseif ans == 'B' then
		table.insert(str_buf, coro.transfer(print_B))
	elseif ans == 'q' then
		return str_buf
	end
end


function print_A ()
	
	while true do
		str = str .. "A"
		io.write("Added 'A'. Continue?")
		local ans = io.read()
		
		if ans == "n" then
			str = str .. coro.transfer(print_B)
		end
	end
end

function print_B ()

--[=[
local us_notation, european_notation

function mk_notation (store)
	return function ()
		local pos = 1
		
		while true do
			local current = store[pos]
			print("Take the next note of this kind? ", current)
			local ans = io.read()
			
			if ans == 'u' then 
				coro.transfer(us_notation, current)
				pos = (pos % #store) + 1
			elseif ans == 'e' then
				coro.transfer(european_notation, current)
				pos = (pos % #store) + 1
			elseif ans == 'q' then
				coro.transfer(main, current)
			else
				print("c to continue, q to quit")
			end
		end
	end
end

function main ()
	local melody = {}
	
	repeat
		local _, ans = coro.transfer(european_notation)
		melody[#melody + 1] = ans
	until not ans
	
	--[[
	for _, note in ipairs(melody) do
		io.write(note, " ")
	end
	--]]
	
	
	
	io.write "\n"
end

coro.main = main
coro.current = coro.main
--]=]

--[==[

--local cos = {us_notation, european_notation}





us_notation = coroutine.create(mk_notation {'a', 'b', 'c', 'd', 'e'})
european_notation = coroutine.create(mk_notation {'do', 're', 'mi', 'fa', 'sol'})
main = coroutine.create(main)

coroutine.resume(main)
-- tbc: figure out how transfer works now.
--]==]