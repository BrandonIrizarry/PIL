

a = 1
local new_gt = {}
setmetatable(new_gt, {__index = _G})
_ENV = new_gt
print(a) -- via metatable, a is _G.a

a = 10
print(a, _G.a)

_G.a = 20
print(_G.a)


