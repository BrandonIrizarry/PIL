--[[
	Exercise 16.3
	
	The function 'stringrep', in Listing 16.2, uses a binary
multiplication algorithm to concatenate n copies of a given string s.
For any fixed n, we can create a specialized version of stringrep
by unrolling the loop into a sequence of instructions r=r..s and 
s=s..s. As an example, for n=5 the unrolling gives us the following
function:

	function stringrep_5 (s)
		local r = ""
		r = r .. s
		s = s .. s
		s = s .. s
		r = r .. s
		return r
	end
	
	Write a function that, given n, returns a specialized function
'stringrep_n'. Instead of using a closure, your function should build
the text of a Lua function with the proper sequence of instructions
(a mix of r = r .. s and s = s .. s) and then use 'load' to produce
the final function. Compare the performance of the generic function
'stringrep' (or of a closure using it) with your tailor-made functions.
]]

-- Listing 16.2: String repetition.
function stringrep (s, n)
	local r = ""
	
	if n > 0 then
		
		while n > 1 do
			if n % 2 ~= 0 then r = r .. s end
			s = s .. s
			n = math.floor(n/2)
		end
		
		r = r .. s
	end
	
	return r
end
		
-- Use this from the previous exercise!
function multiload (...)
	
	local chunks = {...}
	local queue = {}
	
	for _, chunk in ipairs(chunks) do
		if type(chunk) == "string" then
			queue[#queue + 1] = chunk
		elseif type(chunk) == "function" then
			for block in chunk do
				queue[#queue + 1] = block
			end
		else 
			error("invalid chunk type: " .. type(chunk), 2)
		end
	end
	
	local i = 0
	
	--[[
	-- Inspect the queue, in case something goes wrong.
	for _,v in ipairs(queue) do
		print(v)
	end
	--]]
	
	return load(function ()
		i = i + 1
		return queue[i]
	end)
end

function stringrep_n (n)

	local function instructions () -- reader function
		local result
		
		-- If n <= 1, then the while loop is skipped, and 'nil' is returned.
		while n > 1 do
			if n % 2 ~= 0 then
				result = " r = r .. s; s = s .. s;"
			else
				result = " s = s .. s;"
			end
			
			n = math.floor(n/2)
			return result
		end
	end
	
	local prefix = string.format("function stringrep_%d (s) local r = \"\";", n)
	local suffix = " r = r .. s; return r end"
	
	-- Load 'stringrep_<n> into the global environment.
	assert(multiload(prefix, instructions, suffix))()
end

-- Example: I want a use a function 'stringrep_10" (or any number, call it N):
local N = 10
stringrep_n (N)
local subject = "Yeah!"
local chain = stringrep_10(subject) -- return the subject, repeated in succession N times.
local _, count = chain:gsub(subject, "%0")
assert(count == N) -- prove there are N repetitions.
print(chain)
print(string.format("The subject '%s' was indeed repeated %d times.", subject, N))

-- tbc - compare the performance of these 'loaded' functions, with the given stringrep
-- (or else closures using it.)