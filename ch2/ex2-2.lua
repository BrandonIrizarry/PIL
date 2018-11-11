--[[
  An alternative implementation for the eight-queen problem would be to generate 
all possible permutations of 1 to 8 and, for each permutation, to check whether it
is valid. Change the program to use this approach. How does the performance of the
new program compare with the old one? (Hint: compare the total number of permutations
with the number of times that the original program calls the function 'isplaceok'.)

  The new program is much slower. Broken configurations are still doing work.
  Note that 8! = 40320, while 'isplaceok' only gets called 1951 times in the first 
  version of our program.
]]

N = 8  -- board size

-- check whether position (n,c) is free from attacks
function isplaceok (a, n, c)
  for i = 1, n - 1 do -- for each queen already placed
    if (a[i] == c) or -- same column?
        (a[i] - i == c - n) or -- same right diagonal?
        (a[i] + i == c + n) then -- same left diagonal?
      return false -- place can be attacked, don't use
    end
  end
  return true -- no attacks; place is OK
end

-- print a board
function printsolution (a)
  for i = 1, N do -- for each row
    for j = 1, N do -- and for each column
      -- write "X" or "-" plus a space
      io.write(a[i] == j and "X" or "-", " ")
    end
    io.write("\n")
  end
  io.write("\n")
end

-- add to board 'a' all queens from 'n' to 'N'
function addqueen (a, n)
  if n > N then
    local ok = true
    
    for i = 1, N do -- check whether all positions are free from attacks
      ok = ok and isplaceok(a, i, a[i])
    end
    
    if ok then 
      printsolution(a) 
    end
  else 
    for c = 1, N do
      a[n] = c 
      addqueen(a, n + 1)      
    end
  end
end

-- run the program
addqueen({}, 1)