--[[
	I left in some commented-out old code, because I had used it as
scaffolding to figure out what the problem was asking, and I find such code 
instructive in reminding me HOW I arrived at a solution.
]]

nlf = require "nlf"

--letters, numbers, figures = nlf.letters, nlf.numbers, nlf.figures
letters, numbers, figures = nlf.s_lett, nlf.s_num, nlf.s_fig
fmt_write = nlf.fmt_write
print_set = nlf.print_set

-- Store our results in a set.
result_chars = {}

-- The key to making this all work!
function transfer (fn, ...)
	Cos[fn].args = table.pack(...)
	coroutine.yield(Cos[fn])
end

-- End coroutine management.

function get_letter ()
	for l in pairs(letters) do
		fmt_write("\nDo you want this character (y for yes): %s >", l)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[l] = true -- add the character to the set.
			fmt_write("Added '%s' to result_chars.\n", l)
		else
			::try_again::
			fmt_write("\nWhere do you want to go (n, f)?")
			local ans = io.read()
			
			if ans == "n" then
				transfer(get_number)
			elseif ans == "f" then
				transfer(get_figure)
			elseif ans == nil then 
				break
			else
				print("Not a valid place!")
				goto try_again
			end
		end
	end
end

function get_number ()
	for n in pairs(numbers) do
		fmt_write("\nDo you want this character (y for yes): %d >", n)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[tostring(n)] = true
			fmt_write("Added '%s' to result_chars.\n", tostring(n))
		else
			::try_again::
			fmt_write("\nWhere do you want to go (l, f)?")
			local ans = io.read()

			if ans == "l" then
				transfer(get_letter)
			elseif ans == "f" then
				transfer(get_figure)
			elseif ans == nil then
				break
			else
				print("Not a valid place!")
				goto try_again
			end
		end
	end
end

function get_figure ()
	for f in pairs(figures) do
		fmt_write("\nDo you want this character (y for yes): %s >", f)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[f] = true
			fmt_write("Added '%s' to result_chars.\n", f)
		else
			::try_again::
			fmt_write("\nWhere do you want to go (l, n)?")
			local ans = io.read()

			if ans == "l" then
				transfer(get_letter)
			elseif ans == "n" then
				transfer(get_number)
			elseif ans == nil then
				break
			else
				print("Not a valid place!")
				goto try_again
			end
		end
	end
end


local Cos = {}

function register_as_co (fn, ...)
	local co = coroutine.create(fn)
	Cos[fn] = {co = co, args = table.pack(...)}
end

-- Start registering the above functions as coroutines.
register_as_co(get_letter)
register_as_co(get_number)
register_as_co(get_figure)

-- Define the actions of the runner.
function runner ()
	for _, cot in pairs(Cos) do
		local _, next_thing = coroutine.resume(cot.co, cot.args)
	end
	
	print_set(result_chars)
end

-- Start executing the coroutines.
runner()