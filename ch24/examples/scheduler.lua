queue = require "queue"

dispatcher = queue:new()

function dispatcher:add_task (task)
	self:push(task)
end

function dispatcher:add_routine (fn, ...)
	local co = coroutine.create(fn)
	local task = {co = co, params = table.pack(...)}
	self:add_task(task)
	
	return task
end

function dispatcher:run ()
	while not self:empty() do
		local task = self:pop()
		
		if not task then break end
		
		if coroutine.status(task.co) ~= "dead" then
			local status, values = 
				coroutine.resume(task.co, table.unpack(task.params))
			
			if coroutine.status(task.co) ~= "dead" then
				self:add_task(task)
			else
				print("TASK FINISHED")
			end
		else
			print("DROPPING TASK")
		end
	end
end
	
local runner = dispatcher:new()

routines = require "wa_ex2"

runner:add_routine(routines.doOnce, "Hello World")
runner:add_routine(routines.doLoop, 3)
runner:add_routine(routines.doTextChar, "The brown")

runner:run()