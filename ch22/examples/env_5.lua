
a = 2
do
	local _ENV = {this_print = print, a = 14}
	this_print(a)
end

print(a)


function factory (_ENV)
	return function ()
		return a
	end
end

f1 = factory {a = 6}
f2 = factory {a = 7}

print(f1())
print(f2())