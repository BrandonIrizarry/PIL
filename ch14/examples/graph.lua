function name2node (graph, name)
	local node = graph[name]
	
	if not node then
		-- node does not exist; create a new one
		node = {name = name, adj = {}}
		graph[name] = node
	end
	
	return node
end

function readgraph ()
	local graph = {}
	
	for line in io.lines() do
		-- split line two names
		local namefrom, nameto = string.match(line, "(%S+)%s+(%S+)")
		
		-- find corresponding nodes
		local from = name2node(graph, namefrom)
		local to = name2node(graph, nameto)
		
		-- adds 'to' to the adjacent set of 'from'
		from.adj[to] = true
	end
	
	return graph
end

function print_graph (graph)
	for name, node in pairs(graph) do
		print(name)
		
		for to in pairs(node.adj) do
			print(" ", to.name)
		end
	end
end

function findpath (curr, to, path, visited)
	path = path or {} -- path is already a local variable, so we can do this.
	visited = visited or {}
	
	if visited[curr] then -- node already visited?
		return nil -- no path here
	end
	
	visited[curr] = true -- mark node as visited
	path[#path + 1] = curr -- add it to path
	if curr == to then
		return path
	end
	
	-- try all adjacent nodes
	for node in pairs(curr.adj) do
		local p = findpath(node, to, path, visited)
		if p then return p end
	end
	
	table.remove(path) -- remove node from path
end

-- Prints the names of a series of nodes which comprise the path.
function print_path (path)
	for i = 1, #path do
		print(path[i].name)
	end
	
	print() -- print a newline.
end

function path_in_graph (graph_file, nodename_1, nodename_2)
	io.input(graph_file)
	local g = readgraph()
	local r1 = name2node(g, nodename_1)
	local r2 = name2node(g, nodename_2)
	local path = findpath(r1, r2)
	if path then print_path(path) end
end

path_in_graph("graph1.txt", "Room1", "Room4")
path_in_graph("graph2.txt", "a", "j")
path_in_graph("graph2.txt", "a", "d")