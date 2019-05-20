


function print_A (str)
	local ans
	
	while true do
		io.write("Add an 'A'?")
		ans = io.read()
		
		if ans == 'y' then
			print("Added an 'A'")
			str = str .. "A"
		elseif ans == 'n' then
			print("Transferring to 'B'")
			str = transfer(print_B, str)
		elseif ans == nil then
			print("will report final result then...")
			transfer(finish, str)
		else
			print("Invalid selection")
		end
	end
end

function print_B (str)
	local ans

	while true do
		io.write("Add a 'B'?")
		ans = io.read()
		
		if ans == 'y' then
			print("Added a 'B'")
			str = str .. "B"
		elseif ans == 'n' then
			print("Transferring to 'A'")
			str = transfer(print_A, str)
		elseif ans == nil then
			print("\nWill report final result then...")
			transfer(finish, str)
		else
			print("Invalid selection")
		end
	end
end

function finish (str)
	print("This is the final result:")
	print(str)
	print("Tada! The end.")
	
	return true
end

print_A = coroutine.create(print_A)
print_B = coroutine.create(print_B)
finish = coroutine.create(finish)

function main (new_co)
	local str = ""
	local status
	
	while true do
		status, new_co, str = coroutine.resume(new_co, str)
		if new_co == true then
			print("Function 'main' reports: We are done.")
			return
		end
	end
end
	
main(print_A)
	
	
	
	