mt = {__gc = 
	function (obj)
		print(obj[1])
	end
}

list = nil -- declare/initialize a link list

-- Entry #3's 'link' field has a link to Entry #2, which in turn
-- has a link to Entry #1, which links to the original nil-list declared
-- above.

for i = 1, 3 do
	list = setmetatable({i, link = list}, mt)
end

list = nil -- delete the link list, so no link can be referenced.

-- Force garbage collection, to see the behavior of the finalizer defined
-- above.
collectgarbage()