--[[
	Exercise 14.4
	
	Assume the graph representation of the previous exercise, where
the label of each arc represents the distance between its end nodes.
Write a function to find the shortest path between two nodes, using
Dijkstra's algorithm
]]

function reload ()
	package.loaded["/home/brandon/PIL/ch14/ex14-4.lua"] = nil
	dofile("/home/brandon/PIL/ch14/ex14-4.lua")
end

function fmt_write (fmt, ...)
	return io.write(string.format(fmt, ...))
end

function dijkstra_init (graph, start)

	-- Make sure 'start' is in the graph!
	assert(graph.contents[start.name])
	
	-- will contain shortest distances, and info to reconstruct shortest paths
	all_nodes = {}

	for _, node in pairs(graph.contents) do
		all_nodes[node] = {shortest = math.huge, immediate = false}
	end
	
	-- The start node's shortest distance is 0.
	all_nodes[start].shortest = 0
	
	local function dijkstra (pos)
	
		for arc in pairs(pos.inc) do
			local discovered = all_nodes[pos].shortest + arc.label
			local known = all_nodes[arc.node].shortest
			
			if discovered < known then
				all_nodes[arc.node].shortest = discovered
				all_nodes[arc.node].immediate = pos
			end
			
			dijkstra(arc.node)
		end
	end

	dijkstra(start)

	return all_nodes 
end

Graph = require("ex14-3")
graph = Graph.readgraph("graph2.txt")

local an = dijkstra_init(graph, graph.contents["A"])

function reconstruct_path (all_nodes, endpoint)
	
	local total_cost = all_nodes[endpoint].shortest
	fmt_write("Shortest path (cost %d) from '%s' is:\n", total_cost, endpoint.name)
	
	local function iterate (node)
		local current = all_nodes[node]

		if all_nodes[node].immediate == false then
			fmt_write("%s\n", node.name)
			return 
		else
			fmt_write("%s,", node.name)
			return iterate(current.immediate)
		end
	end
	
	iterate(endpoint)
end

reconstruct_path(an, graph.contents["B"])
