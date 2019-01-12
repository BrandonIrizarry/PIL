--[[
	Show how a matrix can be represented with a single row.
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch14/examples/matrix.lua"] = nil
	dofile("/home/brandon/PIL/ch14/examples/matrix.lua")
end

function make_matrix (N, M) -- N rows, M columns

	local matrix = {}

	for i = 1, N do
		local logical_row = (i - 1) * M

		for j = 1, M do
			matrix[logical_row + j] = 0
		end
	end

	local function bounds_check(row, col)
		if row < 1 or row > N then
			error(string.format("row (%d) out of bounds", row))
		elseif col < 1 or col > M then
			error(string.format("col (%d) out of bounds", col))
		end
	end

	return {
		get = function (row, col)
			bounds_check(row, col)
			return matrix[(row - 1) * M + col]
		end,

		set = function (row, col, val)
			bounds_check(row, col)
			matrix[(row - 1) * M + col] = val
		end,

		size = M * N,

		display = function ()
			for i = 1, N do
				local logical_row = (i - 1) * M

				io.write("| ")

				for j = 1, M do
					local cell = matrix[logical_row + j]
					io.write(string.format("%-4s", tostring(cell)), " ")
				end

				io.write("|\n")
			end
		end
	}
end

Matrix = make_matrix(5, 10)
Matrix.display()
