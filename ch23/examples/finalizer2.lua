A = {x = "this is A"}
B = {f = A}

setmetatable(B, {__gc = function (obj) print(obj.f.x) end})

A,B = nil

collectgarbage()