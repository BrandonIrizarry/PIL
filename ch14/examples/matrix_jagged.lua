--[[
	Try out the jagged matrix example on page 126.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch14/examples/matrix_jagged.lua"] = nil
	dofile("/home/brandon/PIL/ch14/examples/matrix_jagged.lua")
end

function fwrite (fmt, ...)
	return io.write(string.format(fmt, ...))
end

function make_matrix (N, M)
	local matrix = {}

	for i = 1, N do -- define 'row', then connect it to the matrix.
		local row = {}

		for j = 1, M do
			row[j] = 0
		end

		matrix[i] = row
	end

	return matrix
end

-- Display various matrices at once.
function display (...)

	local matrices = {...}

	for _, matrix in ipairs(matrices) do -- display matrices one by one.
		for _, row in pairs(matrix) do
			io.write("| ")

			for _, item in pairs(row) do
				io.write(string.format("%-4s", item), " ")
			end

			io.write("|\n")
		end

		io.write("\n") -- make space for printing another matrix.
	end
end

function multiply_eff (A, B)
	local C = {}

	for i = 1, #A do
		local resultline = {}
		for k, va in pairs(A[i]) do
			for j, vb in pairs(B[k]) do
				local res = (resultline[j] or 0) + va * vb
				resultline[j] = (res ~= 0) and res or nil
			end
		end
		C[i] = resultline
	end
	return C
end

function make_special (num_active_cols)
	local matrix = {}
	for i = 1, 10000 do
		local row = {} -- this must be a separate step.
		matrix[i] = row
		for i = 1, num_active_cols do
			row[math.random(1,10000)] = math.random(1,10)
		end
	end

	return matrix
end

-- Display a particular row number of a matrix.
function display_row (matrix, row_num)
	local count = 0 -- record size of row

	local res_msg_buf = {""} -- reserved for storing the row header.

	for index, value in pairs(matrix[row_num]) do
		res_msg_buf[#res_msg_buf + 1] = string.format(" (%d %d)", index, value)
		count = count + 1
	end

	res_msg_buf[1] = string.format("\nROW %d, LEN %d:", row_num, count)
	res_msg_buf[#res_msg_buf + 1] = "\n"

	io.write(table.concat(res_msg_buf))
end

function display_2 (matrix)
	for i = 1, #matrix do
		display_row(matrix, i)
	end
end

--[[
mt1 = make_special(2)
mt2 = make_special(3)
prod = multiply_eff(mt1, mt2)
display_2(prod)
--]]
--[[
--]]
-- TESTS

function test_active_nodes_1 ()
	local active_nodes = {}
	for i = 1, 5 do
		active_nodes[#active_nodes + 1] = math.random(1,10000)
	end


	for _, a in ipairs(active_nodes) do
		io.write(a, " ")
	end
	io.write("\n")
end

function test_basic ()
	mt = make_matrix(5, 10)
	display(mt)
	mt[3][4] = 50
	display(mt)
end

MATRICES = {
	{ {3,1,4}, {1,5,9}, {2,6,5}, {3,5,8} },
	{ {3,0,4}, {1,5,0}, {2,0,5}, {0,5,8} },
	{ {9,7}, {9,3}, {2,3} },
	{ {3,0}, {1,5}, {2,3} },
	{ {2,7,0}, {1,3,8} },
}

function test_basic_mul (matrix1, matrix2)
	prod = multiply_eff(matrix1, matrix2)
	display(matrix1, matrix2, prod)
end

test_basic_mul(MATRICES[2], MATRICES[3])
test_basic_mul(MATRICES[4], MATRICES[5]) -- interesting!
