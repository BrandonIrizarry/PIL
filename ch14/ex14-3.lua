--[[
	Exercise 14.3
	
	Modify the graph structure so that it can keep a label for each arc.
The structure should represent each arc by an object, too, with two fields: its label
and the node it points to. Instead of an adjacent set, each node keeps an incident set
that contains the arcs that originate at that node.
	Adapt the function 'readgraph' to read two node names plus a label from each line
in the input file. (Assume that the label is a number.)
]]


local M = {} -- export some stuff!

function reload ()
	package.loaded["/home/brandon/PIL/ch14/ex14-3.lua"] = nil
	dofile("/home/brandon/PIL/ch14/ex14-3.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

--[[

Example graph.


		5
A------------>B
	| 
	|	1
	--------->C
	| 
	|	3
	--------->D
]]

function export_graph_example ()

	-- Hand-written definitions of individual nodes.
	B = { name = "B", inc = {} }
	C = { name = "C", inc = {} }
	D = { name = "D", inc = {} }

	A = { name = "A", inc = { {label = 5, node = B}, {label = 1, node = C}, {label = 3, node = D} } }

	return { ["A"] = A, ["B"] = B, ["C"] = C, ["D"] = D } -- the final graph.
end

local function name2node (graph, name)
	local node = graph.contents[name]
	
	if not node then
		-- node does not exist; create a new one
		node = {name = name, inc = {}}
		graph.contents[name] = node
	end
	
	return node
end

function M.readgraph (filename)
	io.input(filename) -- set read-input to graph-data file
	
	local graph = {title = filename, contents = {}}
	
	for line in io.lines() do
		-- split line into two node names plus a label
		local namefrom, nameto, label = line:match("(%S+)%s+(%S+)%s+(%d+)")

		-- define the corresponding nodes
		local from = name2node(graph, namefrom)
		local to = name2node(graph, nameto)
		
		from.inc[{label = tonumber(label), node = to}] = true
	end
	
	return graph
end

local function printnode (node)
	fmt_write("name: %s\n", node.name)
	
	for arc in pairs(node.inc) do
		fmt_write("-- leads to %s, with cost %d\n", arc.node.name, arc.label)
	end
end

function M.printgraph (graph)
	fmt_write("Graph '%s' contains:\n", graph.title)
	
	for _, node in pairs(graph.contents) do
		printnode(node)
	end
end

function test ()
	Graph = M.readgraph("graph1.txt")

	printgraph(Graph)
end
return M

