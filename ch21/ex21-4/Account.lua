--[[
	Exercise 21.4
	
	A variation of the dual representation is to implement objects using
proxies (Section 20.4). Each object is represented by an empty proxy table.
An internal table maps proxies to tables that carry the object state. This
internal table is not accessible from the outside, but methods use it to
translate their 'self' parameters to the real tables where they operate.
	Implement the Account example using this approach and discuss its pros
and cons.
]]

--[[
	The pro is that the implementation is almost the same as the
conventional one. Also, an object's data is hidden, and only
read/writable via object methods.
	The con is that extending objects is difficult, since you have
to define my own protector table with each module you write.
]]

local P = {}

function protect (T)
	local proxy = {}
	P[proxy] = T
	
	return proxy
end

local Account = {balance = 0}
Account = protect(Account)

function Account:new (data)
	local acct = data or {balance = 0}
	acct = protect(acct)
	
	self.__index = self
	setmetatable(acct, self)
	
	return acct
end

function Account:withdraw (amt)
	P[self].balance = (P[self].balance or 0) - amt
end

function Account:deposit (amt)
	P[self].balance = (P[self].balance or 0) + amt
end

function Account:balance ()
	return (P[self].balance or 0)
end

return Account:new()
