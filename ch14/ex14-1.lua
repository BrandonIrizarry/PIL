--[[
	Exercise 14.1
	
	Write a function to add two sparse matrices.
]]

math.randomseed(os.time())

function reload ()
	package.loaded["/home/brandon/PIL/ch14/ex14-1.lua"] = nil
	dofile("/home/brandon/PIL/ch14/ex14-1.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end


--[[
	N: number of rows
	M: number of columns
	sparse: number of active columns
	range: the possible range for a given value in the matrix
]]
function make_sparse_matrix (N, M, sparse, range)
	local mt = {} -- Neo's bane. 
	
	for i = 1, N do
		local row = {}
		
		for j = 1, sparse do
			row[math.random(M)] = math.random(range)
		end
		
		mt[i] = row
	end
	
	return mt
end

function print_sparse_matrix (mt)
	
	for i = 1, #mt do
		fmt_write("Row %d:", i)
		
		for j, val in pairs(mt[i]) do
			fmt_write(" %d:%d", j, val)
		end
		
		io.write("\n")
	end
	
	io.write("\n")
end

mt1 = make_sparse_matrix(4, 10, 2, 10)
mt2 = make_sparse_matrix(4, 10, 2, 10)
print_sparse_matrix(mt1)
print_sparse_matrix(mt2)

function add (a, b)
	local sum = {}
	
	for row = 1, #a do
		local result_line = {}
		
		for active_col, value in pairs(a[row]) do
			result_line[active_col] = (b[row][active_col] or 0) + value 
		end
		
		for active_col, value in pairs(b[row]) do
			if not a[row][active_col] then
				result_line[active_col] = value
			end
		end
		
		sum[row] = result_line
	end
	
	return sum
end

print_sparse_matrix(add(mt1, mt2))

mt3 = {
	{[1] = 10, [3] = 20}
}

mt4 = {
	{2,1,4}
}

print_sparse_matrix(add(mt3, mt4))