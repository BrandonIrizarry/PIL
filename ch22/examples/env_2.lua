

a = 15
print(_G.a)
a = -15
print(_G.a)

_ENV = {_G = _G}

a = 1

_G.print(5)
_G.print(_G.a)