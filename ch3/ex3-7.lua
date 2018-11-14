function reload ()
  package.loaded["/home/brandon/PIL/ch3/ex3-7.lua"] = nil
  dofile("/home/brandon/PIL/ch3/ex3-7.lua")
end

math.randomseed(os.time())

-- Use the Box-Muller transform, to generate a pair of normally distributed
-- samples.
function gauss ()
	local u1, u2 = math.random(), math.random()
	
	return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2),
		math.sqrt(-2 * math.log(u1)) * math.sin(2 * math.pi * u2)
end

-- Return a table of samples across a normal distribution.
-- The user can specify the number of samples, and the number
-- of decimal places to which you'd like to express each sample.
--[[
function gauss_samples (num_samples, accuracy)
	local samples, num_samples = {}, num_samples or 20
	local accuracy = accuracy or 0.1
	
	for i = 1, num_samples do
		local g = gauss()
		local approx = g - g % accuracy
		samples[#samples + 1] = approx
	end
	
	return samples
end
]]
-- Print some samples to see what our normally distributed data looks like.
--[[
function print_samples ()
	local samples = gauss_samples(20, 0.125)
	
	-- Use the string-buffer technique on p. 132
	samples[#samples + 1] = ""
	print(table.concat(samples, "\n"))
end
]]

function histogram (num_samples, accuracy, low_end, high_end)

	-- Default arguments.
	local num_samples = num_samples or 20000
	local accuracy = accuracy or 1/16 -- helpful to use power-of-two denominator
	local low_end = low_end or -4 -- lowest allowable data point
	local high_end = high_end or 4 -- highest allowable data point
	assert(high_end > low_end)
	
	-- This will contain our normally distributed data points.
    local samples = {}
	
	-- Generate the data points.
	for i = 1, num_samples do
		local g = gauss()
		local approx = g - g % accuracy
		samples[#samples + 1] = approx
	end
	
	-- The table 'bucket_to_frequency' is the histogram proper.
	-- The array 'index_to_bucket' organizes bucket-frequency pairs into entries 
	-- that can later be displayed in sorted order.
	local index_to_bucket, bucket_to_frequency = {}, {}
	
	-- Initialize the histogram itself.
	-- 'L' is the current bucket, and 'index' is the current histogram entry.
	do
		local L, index  = low_end, 1
		
		while L <= high_end do
			index_to_bucket[index] = L
			bucket_to_frequency[L] = 0
			index = index + 1
			L = L + accuracy
		end
	end
	
	-- Populate the histogram.
	-- Make sure that our data points are within the histogram's bounds.
	for _, s in ipairs(samples) do
		if s < low_end or s > high_end then goto continue end
		bucket_to_frequency[s] = bucket_to_frequency[s] + 1
		::continue::
	end
	
	-- Print the histogram to stdout.
	for _, v in ipairs(index_to_bucket) do
		local bar_length = bucket_to_frequency[v] // 10
		print(v, string.rep("*" , bar_length))
	end
end