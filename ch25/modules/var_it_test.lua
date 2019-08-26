local locals, upvalues = table.unpack(require "var_it")

local function test ()
	local x, y, z = 0, 1, 2
	
	print("Locals (regular function)")
	for idx, name, value in locals(nil, 1) do
		print(idx, name, value)
	end
	
	print("Upvalues (regular function)")
	for idx, name, value in upvalues(nil, 1) do
		print(idx, name, value)
	end
end

test()

local function go_deeper()
	local a, b = "apple", "grape"
	coroutine.yield()
end

local function test_co ()
	local x, y = 0, 1
	coroutine.yield()
	go_deeper()
end

co = coroutine.create(test_co)
coroutine.resume(co)

print("Locals (coroutine)")
for idx, name, value in locals(co, 1) do
	print(idx, name, value)
end

print("Upvalues (coroutine)")
for idx, name, value in upvalues(co, 1) do
	print(idx, name, value)
end

-- After this 'resume', we're in 'go_deeper'.
coroutine.resume(co)

print("More locals (coroutine)")
for idx, name, value in locals(co, 1) do
	print(idx, name, value)
end

print("More upvalues (coroutine)")
for idx, name, value in upvalues(co, 1) do
	print(idx, name, value)
end

print("See same locals as before (coroutine)")
for idx, name, value in locals(co, 2) do
	print(idx, name, value)
end


