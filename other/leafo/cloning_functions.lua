local message = "Hello"

local function say_message ()
	print("message: " .. tostring(message))
end

local say_message_clone = loadstring(string.dump(say_message))

for i = 1, math.huge do
	-- see if i is a valid upvalue index
	local name = debug.getupvalue(say_message, i)
	if not name then
		break
	end
	-- join the clone and the original
	debug.upvaluejoin(say_message_clone, i, say_message, i)
end

		
say_message_clone()
message = "MoonScript"
say_message_clone()

--[[
function clone_function (fn)
	local dumped = string.dump(fn)
	local cloned = loadstring(dumped)
	
	for i = 1, math.huge do
		local name = debug.getupvalue(fn, i)
		if not name then
			break
		end
		
		debug.upvaluejoin(cloned, i, fn, i)
	end
	
	return cloned
end
--]]

function upvalues (fn)
	local function iter (fn, i)
		i = i + 1
		local name, value = debug.getupvalue(fn, i)
		if name then
			return i, name, value
		end
	end
	
	return iter, fn, 0
end

print("The original")
for i, u, v in upvalues(say_message) do 
	print(i, u, v)
end

print("The clone")
for i, u, v in upvalues(say_message_clone) do
	print(i, u, v)
end

local say_message_false_clone = loadstring(string.dump(say_message))

print("The false clone")
for i, u, v in upvalues(say_message_false_clone) do
	print(i, u, v)
end

function clone_function (fn)
	local dumped = string.dump(fn)
	local cloned = loadstring(dumped)
	
	for i, _, _ in upvalues(cloned) do -- Fix function 'cloned' upvalues!
		debug.upvaluejoin(cloned, i, fn, i)
	end
	
	return cloned
end

local a = 1; local b = 2
function run ()
	-- Without any loaded upvalues, this doesn't even have _ENV!
	print(a + b)
end

run2 = clone_function(run)

run3 = loadstring(string.dump(run)) -- false clone

print "first"
run()

print "second"
run2()

print "third (false)"
run3()	-- no a,b, _ENV - just borks, Q.E.D.


	