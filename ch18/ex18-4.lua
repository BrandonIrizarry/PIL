--[[
	Exercise 18.4
	
	Write an iterator that returns all non-empty substrings of a given
string.
]]

-- An example iterator that iterates over the indices of a triangular array,
-- i.e. basically over a pair of numbers.
-- We use this idea to solve the exercise.
function double_count (N)
	local runner = 0
	local anchor = 1
	
	return function ()
		runner = runner + 1
		
		if runner > N then
			anchor = anchor + 1
			runner = anchor
		end
		
		if anchor > N then
			return nil
		else
			return anchor, runner -- f(anchor, runner) where f == id.
		end
	end
end
		
function substrings (str)
	local runner = 0
	local anchor = 1
	local N = #str
	
	return function ()
		runner = runner + 1
		
		if runner > N then
			anchor = anchor + 1
			runner = anchor
		end
		
		if anchor > N then
			return nil
		else
			return str:sub(anchor, runner) -- essentially f(anchor, runner)
		end
	end
end

-- Example.
function test ()
	local str = "happiness"

	for ss in substrings(str) do
		print(ss)
	end
end
