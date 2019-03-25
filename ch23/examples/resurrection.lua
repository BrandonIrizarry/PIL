
A = {x = "this is A"}
B = {f = A}

setmetatable(B, {__gc = function (obj) r = obj.f; print(obj.f.x) end})
--setmetatable(A, {__gc = function (obj) print("now I'm really gone.") end})
--A,B = nil

--print(collectgarbage("count"))
print(r)