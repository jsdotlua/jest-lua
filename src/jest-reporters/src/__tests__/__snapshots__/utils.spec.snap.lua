-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/__snapshots__/utils.test.ts.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP

local snapshots = {}

snapshots["printDisplayName should correctly print the displayName when color and name are valid values 1"] =
	[["</><inverse><green> hello </></></>"]]

snapshots["printDisplayName should default displayName color to white when color is not a valid value 1"] =
	[["</><inverse><white> hello </></></>"]]

snapshots["printDisplayName should default displayName color to white when displayName is a string 1"] =
	[["</><inverse><white> hello </></></>"]]

snapshots["trimAndFormatPath() does not trim anything 1"] = [["<dim>1234567890/1234567890/</><bold>1234.js</>"]]

snapshots["trimAndFormatPath() split at the path.sep index 1"] = [["<dim>.../</><bold>1234.js</>"]]

snapshots["trimAndFormatPath() trims dirname (longer line width) 1"] = [["<dim>...890/1234567890/</><bold>1234.js</>"]]

snapshots["trimAndFormatPath() trims dirname 1"] = [["<dim>...234567890/</><bold>1234.js</>"]]

snapshots["trimAndFormatPath() trims dirname and basename 1"] = [["<bold>...1234.js</>"]]

snapshots["wrapAnsiString() returns the string unaltered if given a terminal width of zero 1"] =
	[["This string shouldn't cause you any trouble"]]

snapshots["wrapAnsiString() returns the string unaltered if given a terminal width of zero 2"] =
	[["This string shouldn't cause you any trouble"]]

-- ROBLOX deviation START: not supported
-- snapshots["wrapAnsiString() wraps a long string containing ansi chars 1"] = [[

-- "abcde <red><bold>red-
-- bold</></> 12344
-- 56<dim>bcd</> 123t
-- tttttththt
-- hththththt
-- hththththt
-- hththththt
-- hthththtet
-- etetetette
-- tetetetete
-- tetete<bold>stnh
-- snthsnth</>ss
-- ot"
-- ]]

-- snapshots["wrapAnsiString() wraps a long string containing ansi chars 2"] = [[

-- "abcde red-
-- bold 12344
-- 56bcd 123t
-- tttttththt
-- hththththt
-- hththththt
-- hththththt
-- hthththtet
-- etetetette
-- tetetetete
-- tetetestnh
-- snthsnthss
-- ot"
-- ]]
-- ROBLOX deviation END

return snapshots
