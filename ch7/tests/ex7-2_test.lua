function reload ()
  package.loaded["/home/brandon/PIL/ch7/tests/ex7-2_test.lua"] = nil
  dofile("/home/brandon/PIL/ch7/tests/ex7-2_test.lua")
end

package.path = package.path .. ";../?.lua"
main = require "ex7-2"
common = require "common"

local files = common.files.prepare_files()
test1 = common.make_test(main.fix_streams)
test2 = common.make_test(main.fix_streams, files.love_poem)
test3 = common.make_test(main.fix_streams, files.love_poem, files.notice)

function run_tests()
	io.write("Enter some lines (press enter then ctrl+d to quit):\n")
		test1()
		test2()
		io.write(string.format("file2 before:\n%s\n", string.rep("-", 10)))
		common.files.print_file(files.notice)
		test3()
		io.write(string.format("file2 after (did you overwrite?):\n%s\n", string.rep("-", 10)))
		common.files.print_file(files.notice)
end

if arg[1] == "y" then run_tests() end -- optionally specify to run the main suite.
