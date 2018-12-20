--[[
	Exercise 8.1

	Most languages with a C-like syntax do not offer an elseif construct.
Why does Lua need this construct more than those languages?
]]

--[[
	Lua doesn't have a switch/case statement. So, to express that logic,
you would otherwise need nested ifs, which create a lot of indentation in
your program:
]]

message = "You'll see this if you entered 3 or 4."
print("Enter a number:")
number = io.read("n")

if number == 1 then
	print("one.")
else
	if number == 2 then
		print("two.")
	else
		if number == 3 then
			print("three.")
		else
			if number == 4 then
				print("four.")
			end
		end
	print(message)
	end
end

--[[
	Notice that Lua's scanner lets us write that as the following:
]]

print("Enter another number:")
number = io.read("n")

if number == 1 then
	print("one.")
else if number == 2 then
	print("two.")
else if number == 3 then
	print("three.")
else if number == 4 then
	print("four.")
end
end
print(message) -- only reading the first version makes this line clear to me.
end
end

--[[
	But, of course, the elseif keyword takes all that in using just
	one terminating
'end', and makes clearer when 'print(message)' will execute. Also,
there's no "lexical interweaving" of scopes (which the '3 or 4' part
insinuates - you've left scope 3 or 4, and are jumping back to scope 2,
then to scope 1); even if _that_ weren't a problem, the above version
strongly discourages defining local variables after an 'if' keyword.
]]

print("Enter a third number:")
number = io.read("n")

if number == 1 then
	print("one.")
elseif number == 2 then
	print("two.")
elseif number == 3 then
	print("three.")
	print("You'll see this... only if you've entered 3?")
elseif number == 4 then
	print("four.")
end

--[[
	Now every "scope-position" is clearly associated with a number.
This is, in a sense, better than a switch statement, because there's no confusing
"fall-through" code.
]]
