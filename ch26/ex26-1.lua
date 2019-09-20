--[[
	Exercise 26.1
	
	Implement and run the code presented in this chapter.
]]

-- NB: Pass in an argument of "true" to see the files come one by one more slowly,
-- rather than in one swoop :)
local serial = arg[1] or false

local download = require "modules.download"
local socket = require "socket"

local tasks = {} -- list of all live tasks

local function get (host, file)
	-- create a coroutine for the task
	local co = coroutine.wrap(function ()
		download(host, file, serial)
	end)
	
	-- insert it into the list
	table.insert(tasks, co)
end

local function dispatch ()
	local i = 1
	
	while true do
		if tasks[i] == nil then -- no other tasks?
			if tasks[1] == nil then -- list is empty?
				break -- break the loop
			end
			
			i = 1
		end
		
		local res = tasks[i]() -- dispatch
		
		if not res then -- task finished?
			table.remove(tasks, i)
		else
			i = i + 1 -- go to the next task
		end
	end
end

local function dispatch_good_cpu ()
	local i = 1
	local timedout = {}
	
	while true do
		if tasks[i] == nil then
			if tasks[1] == nil then
				break
			end
			
			i = 1
			timedout = {}
		end
		
		local res = tasks[i]()
		
		if not res then
			table.remove(tasks, i)
		else -- time out
			i = i + 1
			timedout[#timedout + 1] = res
			if #timedout == #tasks then -- all tasks blocked?
				socket.select(timedout) -- wait
			end
		end
	end
end

local function main (dispatcher)
	local host = "www.lua.org"
	local file_template = "/ftp/lua-%s.tar.gz"

	local versions = {"5.3.2", "5.3.1", "5.3.0", "5.2.4", "5.2.3"}

	for _, ver in ipairs(versions) do
		local file = string.format(file_template, ver)
		get(host, file)
	end
	
	dispatcher()
end

main(dispatch_good_cpu)
	
	