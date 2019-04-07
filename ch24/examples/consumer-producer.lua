--[[
	In this version of "Who Is the Boss?", the producer is the main
thread, while the consumer is the coroutine. 
	The producer hands a line over to consumer, to be consumed.
Consumer then writes the line.
	There is a subtle point here. At first, my version of consumer looked
liked this:

function consumer ()
	while true do
		line = coroutine.yield()
		io.write(line, "\n")
	end
end

	However, it wouldn't echo _the very first line_ you inputted. Why? 
Because, before printing to stdout, _consumer would first yield, to request
a value from the main thread._ The producer loop would then continue, and resume 
the consumer again, complying with yield's request, which started the expected
program logic of echoing user-inputted lines.
	To avoid this, we note that resuming a coroutine for the first time will
pass arguments to the coroutine body itself, giving us a place to bootstrap.
]]

function consumer (line)
	while true do
		io.write(line, "\n")
		line = coroutine.yield()
	end
end

function producer ()
	while true do
		local line = io.read()
		if line == nil then break end
		coroutine.resume(consumer, line)
	end
end

consumer = coroutine.create(consumer)

producer()



