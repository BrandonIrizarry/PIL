--[[
	Exercise 9.2

	What will be the output of the following chunk:

	function F (x)
		return {
			set = function (y) x = y end,
			get = function () return x end
		}
	end

	o1 = F(10)
	o2 = F(20)
	print(o1.get(), o2.get())
	o2.set(100)
	o1.set(300)
	print(o1.get(), o2.get())
]]

function F (x)
	return {
		set = function (y) x = y end,
		get = function () return x end
	}
end

-- I don't understand why 'get' can return the x updated by 'set', if technically they're
-- different functions with independent scopes!
o1 = F(10); o2 = F(20)
assert(o1.get() == 10 and o2.get() == 20)
o2.set(100); o1.set(300)
assert(o1.get() == 300 and o2.get() == 100)

-- P.S.
-- As a further illustration
function G (y)
	return {
		double = function () y = 2 * y end,
		decrement = function () y = y - 1 end,
		add = function (d) y = y + d end,
		get = function () return y end -- sees everything that happens above!
	}
end

c = G(1); c.double(); c.double(); c.double(); c.decrement(); c.add(0.5)
assert(c.get() == 7.5)
