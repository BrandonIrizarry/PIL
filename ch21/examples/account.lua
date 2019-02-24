Account = {balance = 0}

function Account.withdraw (v)
	Account.balance = Account.balance - v
end

Account.withdraw(100.0)

print(Account.balance)

-- Account is global.
-- The function will only work for this particular object:

OtherAccount = {balance = 0}

local _, msg = pcall(OtherAccount.withdraw, 100.0) -- 'OtherAccount' table doesn't have a 'withdraw' field
print(msg)

-- Even for this particular object, the function will work only as long as the
-- object is stored in that particular global variable. If we change the object's
-- name, 'withdraw' does not work any more:

a, Account = Account, nil -- move 'Account' into 'a'
local _, msg = pcall(a.withdraw, 100.0) -- the 'withdraw' method has 'Account' hard-coded into its definition

print(msg)

-- To fix both these problems, Account.withdraw must specify the table whose balance field is to be updated:
-- the aim is that this table be the _same_ table possessing the 'withdraw' field:

Account = {balance = 0} -- reinitialize 'Account'
function Account.withdraw (self, v)
	self.balance = self.balance - v
end

-- Now, when we call the method, we have to specify the object that it has to operate on:

a1, Account = Account, nil -- do our mv again

-- a1 is now the Account table, so it has both 'balance' and 'withdraw' fields.
-- Now, the withdraw field is disciplined into referring to a specified table, which we
-- aim to have it be the same table as the one possessing the 'balance' field.
-- Hence, the following works:

a1.withdraw(a1, 100.0)
print(a1.balance)

-- The colon notation makes the metion of 'self' implicit:
Account = {balance = 0}
function Account:withdraw(v)
	self.balance = self.balance - v
end

a1, Account = Account, nil
a1:withdraw(100.0)
print("Now with 'self-reference':", a1.balance) 

-- Now, the self-reference is enforced.

-- A conventional table-constructor definition.
Account = {
			balance = 0,
			
			withdraw = function (self, v)
				self.balance = self.balance - v
			end,
}
			
-- Taking advantage of colon-syntax:
function Account:deposit (v)
	self.balance = self.balance + v
end

Account.deposit(Account, 200.0) -- conventional
Account:withdraw(100.0)

print(Account.balance)