nlf = require "nlf"

letters, numbers, figures = nlf.letters, nlf.numbers, nlf.figures
fmt_write = nlf.fmt_write
print_set = nlf.print_set

-- Store our results in a set.
result_chars = {}

function dispatch (co, ...)

	coroutine.resume(co, ...)
	--[[
	while coroutine.status(new_co) ~= "dead" do
		new_co = coroutine.resume(transfer, new_co)
	end
	--]]
end


function transfer (co, ...)
	
	local _dispatch
	
	if type(_G.dispatch) ~= "thread" then
		_dispatch = coroutine.create(dispatch)
	end
	
	coroutine.resume(_dispatch, co, ...)
end



function get_letter ()
	for l in pairs(letters) do
		fmt_write("Do you want this character (y for yes): %s >", l)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[l] = true -- add the character to the set.
			fmt_write("Added '%s' to result_chars.\n", l)
		else
			::try_again::
			fmt_write("Where do you want to go (n, f)?")
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
		fmt_write("Do you want this character (y for yes): %d >", n)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[tostring(n)] = true
			fmt_write("Added '%s' to result_chars.\n", tostring(n))
		else
			::try_again::
			fmt_write("Where do you want to go (l, f)?")
			local ans = io.read()

			if ans == "l" then
				transfer(get_letter)
			elseif ans == "f" then
				transfer(get_figure)
			else
				print("Not a valid place!")
				goto try_again
			end
		end
	end
end

function get_figure ()
	for f in pairs(figures) do
		fmt_write("Do you want this character (y for yes): %s >", f)
		local ans = io.read()
		
		if ans == "y" then
			result_chars[f] = true
			fmt_write("Added '%s' to result_chars.\n", f)
		else
			::try_again::
			fmt_write("Where do you want to go (l, n)?")
			local ans = io.read()

			if ans == "l" then
				transfer(get_letter)
			elseif ans == "n" then
				transfer(get_number)
			else
				print("Not a valid place!")
				goto try_again
			end
		end
	end
end


transfer(get_letter)


--main()
--[[
function tracks ()
	repeat
		local what = io.read()
		
		if what == "l" then
			print("letter")
		elseif what == "n" then
			print("number")
		elseif what == "f" then
			print("figure")
		elseif not what then
			print("bye")
		else
			print("not recognized")
		end
	until not what
end
tracks()
--]]
