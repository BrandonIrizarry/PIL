
function do_as_count ()
	local count = 0
	
	function Entry () count = count + 1 end -- has to be exported into the global environment
	
	dofile("biblio.lua")
	print("number of entries: " .. count)
end


function do_as_author ()
	local authors = {} -- collect all distinct authors
	
	function Entry (book) authors[book[1]] = true end
	dofile("biblio.lua")
	
	for name in pairs(authors) do print(name) end
end


function do_as_author_field ()
	local authors = {} -- this time note if there's an unknown author
	
	function Entry (book) authors[book.author or "unknown"] = true end
	dofile("biblio-named-fields.lua")
	
	for name in pairs(authors) do print(name) end
end

do_as_author_field()