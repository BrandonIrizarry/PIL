--[=[
  Exercise 4.1
  How can you embed the following fragment of XML as a string in a Lua program?
  
  <![CDATA[
    Hello world
  ]]>
  
  Show at least two different ways.
  
  To run this program, simply execute lua on this file.
]=]

data1 = 
[=[
<![CDATA[
  Hello world
]]>]=]

data2 = "<![CDATA[\n  Hello world\n]]>"

--[[ 
  Prove to anybody running this program, that the two representations are,
  in fact, equal.
]]
assert(data1 == data2)
