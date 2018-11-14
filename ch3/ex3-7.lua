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

-- Print some samples to see what our normally distributed data looks like.
function print_samples ()
	local samples = gauss_samples(20, 0.125)
	
	-- Use the string-buffer technique on p. 132
	samples[#samples + 1] = ""
	print(table.concat(samples, "\n"))
end
	
function histogram (num_samples, accuracy)
	local num_samples = num_samples or 20
	local accuracy = accuracy or 0.125
	local samples = gauss_samples(num_samples, accuracy)
	
	local index_to_bucket, bucket_to_frequency = {}, {}
	
	local low_end, high_end, index = -4, 4, 1

	while low_end <= high_end do
		index_to_bucket[index] = low_end
		bucket_to_frequency[low_end] = 0
		index = index + 1
		low_end = low_end + accuracy
	end
	
	-- Populate the histogram using our samples.
	for _, s in ipairs(samples) do
		if s < -4 or s > 4 then goto continue end
		bucket_to_frequency[s] = bucket_to_frequency[s] + 1
		::continue::
	end
	
	return index_to_bucket, bucket_to_frequency
end
	
-- Let there be light.
function print_histogram (num_samples, accuracy)
	local num_samples = num_samples or 20
	local accuracy = accuracy or 0.125
	local i_to_b, b_to_f = histogram(num_samples, accuracy)
	
	for _, v in ipairs(i_to_b) do
		local bar_length = b_to_f[v] // 10
		print(v, string.rep("*" , bar_length))
	end
end