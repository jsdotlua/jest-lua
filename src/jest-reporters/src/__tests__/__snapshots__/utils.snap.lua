-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/__snapshots__/utils.test.ts.snap
local snapshots = {}

snapshots[tostring("printDisplayName should correctly print the displayName when color and name are valid values 1")] =
	'"[0m[7m[32m hello [39m[27m[0m"'

snapshots[tostring("printDisplayName should default displayName color to white when color is not a valid value 1")] =
	'"[0m[7m[37m hello [39m[27m[0m"'

snapshots[tostring("printDisplayName should default displayName color to white when displayName is a string 1")] =
	'"[0m[7m[37m hello [39m[27m[0m"'

snapshots[tostring("trimAndFormatPath() does not trim anything 1")] =
	'"[2m1234567890/1234567890/[22m[1m1234.js[22m"'

snapshots[tostring("trimAndFormatPath() split at the path.sep index 1")] = '"[2m.../[22m[1m1234.js[22m"'

snapshots[tostring("trimAndFormatPath() trims dirname (longer line width) 1")] =
	'"[2m...890/1234567890/[22m[1m1234.js[22m"'

snapshots[tostring("trimAndFormatPath() trims dirname 1")] = '"[2m...234567890/[22m[1m1234.js[22m"'

snapshots[tostring("trimAndFormatPath() trims dirname and basename 1")] = '"[1m...1234.js[22m"'

snapshots[tostring("wrapAnsiString() returns the string unaltered if given a terminal width of zero 1")] =
	'"This string shouldn\'t cause you any trouble"'

snapshots[tostring("wrapAnsiString() returns the string unaltered if given a terminal width of zero 2")] =
	'"This string shouldn\'t cause you any trouble"'

snapshots[tostring("wrapAnsiString() wraps a long string containing ansi chars 1")] = [[

"abcde <red><bold>red-
bold</></> 12344
56<dim>bcd</> 123t
tttttththt
hththththt
hththththt
hththththt
hthththtet
etetetette
tetetetete
tetete<bold>stnh
snthsnth</>ss
ot"
]]

snapshots[tostring("wrapAnsiString() wraps a long string containing ansi chars 2")] = [[

"abcde red-
bold 12344
56bcd 123t
tttttththt
hththththt
hththththt
hththththt
hthththtet
etetetette
tetetetete
tetetestnh
snthsnthss
ot"
]]

return snapshots
