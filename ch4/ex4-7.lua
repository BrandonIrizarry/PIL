--[[
  Exercise 4.7
  
  Write a function to check whether a given string is a palindrome:
  
  > ispali("step on no pets") --> true
  > ispali("banana") --> false
]]

function ispali(subj)
  return subj == string.reverse(subj)
end

local examples = {
  ispali("step on no pets"),
  ispali("banana"),
  ispali("A man, a plan, a canal, Panama"),
  ispali(""),
  ispali("a"),
  ispali("aba"),
}

for _, e in ipairs(examples) do print(e) end