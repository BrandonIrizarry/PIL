--[[
	The consumer prints lines, while the producer obtains them.
]]	

function producer ()
	while true do
		coroutine.yield(io.read())
	end
end


function consumer ()
	while true do
		local _, line = coroutine.resume(producer)
		
		if line == nil then -- hit ctrl+d to break the loop. 
			break
		else
			io.write(line, "\n")
		end
	end
end
 
producer = coroutine.create(producer)

consumer()