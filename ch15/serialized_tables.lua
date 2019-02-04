E = {
	{
		bentley = {
			title = "More Programming Pearls",
			keywords = {
				k2 = "tips",
				k1 = "programming",
				k3 = "oysters",
			},
			year = 1990,
			author = "Jon Bentley",
			publisher = "Addison-Wesley",
		},
		knuth = {
			title = "Literate Programming",
			keywords = {
				k2 = "TAOCP",
				k1 = "Algol",
				k3 = "organ",
			},
			year = 1992,
			author = "Donald E. Knuth",
			publisher = "CSLI",
		},
	},
	{
		"A",
		"B",
		"C",
	},
	{
		"a",
		"b",
		"c",
	},
	{
		"a",
		"b",
		"c",
		punctuation = {
			["."] = true,
			[","] = true,
		},
		words = {
			"apple",
			"orange",
			"table",
		},
		[true] = false,
		["cs,"] = "do something cool",
	},
	{
		"red",
		"green",
		"blue",
		"orange",
	},
	{
		"begin",
		"second",
		"third",
		year = 1999,
		author = "Knuth",
		book = "taocp",
	},
	{
		"P",
		"q",
	},
	{
		2,
		1,
	},
	{
		3,
		2,
	},
	{
		{
			1,
			2,
			3,
		},
		{
			4,
			5,
			6,
		},
		{
			7,
			8,
			9,
		},
	},
}

A = {
	{
		3,
		4,
		5,
	},
	x = 3,
	y = 5,
}
A[2] = A
A["z"] = A[1]

B = {
	{
		1,
		2,
		3,
	},
	{
		4,
		5,
		6,
		["."] = 4,
	},
}
B[3] = A[1]

Z = {
}

