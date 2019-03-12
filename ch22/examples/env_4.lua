

_ENV = {_G = _G}
local function foo ()
	_G.print(a) -- compiled as '_ENV._G.print(_ENV.a)'
end

a = 10
foo()

_ENV = {_G = _G, a = 20}

foo()



