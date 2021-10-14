-- upstream: https://github.com/facebook/jest/blob/v27.0.6/packages/jest-snapshot/src/__tests__/printSnapshot.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Error = LuauPolyfill.Error
	local Object = LuauPolyfill.Object
	local Symbol = LuauPolyfill.Symbol

	-- deviation: omitting imports for styles
	local ansiRegex = require(Packages.PrettyFormat).plugins.ConvertAnsi.ansiRegex
	local chalk = require(Packages.ChalkLua)
	local format = require(Packages.PrettyFormat).prettyFormat

	local jestExpect = require(Packages.Dev.Expect)

	local printSnapshot = require(CurrentModule.printSnapshot)
	local getReceivedColorForChalkInstance = printSnapshot.getReceivedColorForChalkInstance
	local getSnapshotColorForChalkInstance = printSnapshot.getSnapshotColorForChalkInstance
	local noColor = printSnapshot.noColor
	local printPropertiesAndReceived = printSnapshot.printPropertiesAndReceived
	local printSnapshotAndReceived = printSnapshot.printSnapshotAndReceived

	local serialize = require(CurrentModule.utils).serialize

	local colors = require(CurrentModule.colors)
	-- ROBLOX TODO: ADO-1522 add level 3 support in chalk
	-- deviation: omitted level 3 colors since we don't have level 3 support in chalk
	local aBackground2 = colors.aBackground2
	-- local aBackground3 = colors.aBackground3
	local aForeground2 = colors.aForeground2
	-- local aForeground3 = colors.aForeground3
	local bBackground2 = colors.bBackground2
	-- local bBackground3 = colors.bBackground3
	local bForeground2 = colors.bForeground2
	-- local bForeground3 = colors.bForeground3

	local aOpenForeground1 = chalk.magenta.open
	local aOpenBackground1 = chalk.bgYellowBright.open
	local bOpenForeground1 = chalk.cyan.open
	local bOpenBackground1 = chalk.bgWhiteBright.open

	local aOpenForeground2 = chalk.ansi256(aForeground2).open
	local bOpenForeground2 = chalk.ansi256(bForeground2).open
	local aOpenBackground2 = chalk.bgAnsi256(aBackground2).open
	local bOpenBackground2 = chalk.bgAnsi256(bBackground2).open

	-- ROBLOX TODO: ADO-1522 add level 3 support in chalk
	-- deviation: omitted level 3 colors

	local ansiLookupTable = {
			[chalk.inverse.open] = "<i>",
			[chalk.inverse.close] = "</i>",
			[chalk.bold.open] = "<b>",
			[chalk.dim.open] = "<d>",
			[chalk.bold.close] = "</>",
			[chalk.dim.close] = "</>",
			[chalk.green.open] = "<g>",
			[aOpenForeground1] = "<m>",
			[aOpenForeground2] = "<m>",
			-- [aOpenForeground3] = "<m>"
			[chalk.red.open] = "<r>",
			[bOpenForeground1] = "<t>",
			[bOpenForeground2] = "<t>",
			-- [bOpenForeground3] = "<t>",
			[chalk.yellow.open] = "<y>",
			[chalk.cyan.close] = "</>",
			[chalk.green.close] = "</>",
			[chalk.magenta.close] = "</>",
			[chalk.red.close] = "</>",
			[chalk.yellow.close] = "</>"
	}

	local function convertAnsi(val: string): string
		-- // Trailing spaces in common lines have yellow background color.
		local isYellowBackground = false

		val = val:gsub(ansiRegex, function(match)
			if ansiLookupTable[match] then
				return ansiLookupTable[match]
			elseif match == chalk.bgYellow.open then
				isYellowBackground = true
				return "<Y>"
			elseif
				match == aOpenBackground1 or
				match == bOpenBackground1 or
				match == aOpenBackground2 or
				match == bOpenBackground2
				-- ROBLOX TODO: ADO-1522 add level 3 support in chalk
				-- match == aOpenBackground3 or
				-- match == bOpenBackground3
			then
				isYellowBackground = false
				return ""
			elseif match == chalk.bgYellow.close then
				-- // The same code closes any background color.
				if isYellowBackground then
					return "</Y>"
				else
					return ""
				end
			else
				return match
			end
		end)

		return val
	end

	local jestSnapshot = require(CurrentModule)
	local toMatchSnapshot = jestSnapshot.toMatchSnapshot
	local toThrowErrorMatchingSnapshot = jestSnapshot.toThrowErrorMatchingSnapshot

	beforeAll(function()
		jestExpect.addSnapshotSerializer({
			serialize = function(val: string): string
				return convertAnsi(val)
			end,
			test = function(val: any)
				return typeof(val) == "string" and val:match(ansiRegex)
			end
		})
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	describe('chalk', function()
		-- // Because these tests give code coverage of get functions
		-- // and give confidence that the escape sequences are correct,
		-- // convertAnsi can return same serialization for any chalk level
		-- // so snapshot tests pass in any environment with chalk level >= 1.

		-- // Simulate comparison lines from printSnapshotAndReceived.
		local function formatLines(chalkInstance)
			local aColor = getSnapshotColorForChalkInstance(chalkInstance)
			local bColor = getReceivedColorForChalkInstance(chalkInstance)
			local cColor = chalkInstance.dim

			local changeLineTrailingSpaceColor = noColor
			local commonLineTrailingSpaceColor = chalkInstance.bgYellow

			return table.concat({
				aColor("- delete 1" .. changeLineTrailingSpaceColor(" ")),
				cColor("  common 2" .. commonLineTrailingSpaceColor("  ")),
				bColor("+ insert 0"),
			}, "\n")
		end

		local expected0 = "- delete 1 \n  common 2  \n+ insert 0"
		local expected1 = "<m>- delete 1 </>\n<d>  common 2<Y>  </Y></>\n<t>+ insert 0</>"

		it("level 0", function()
			-- deviation: we don't have a chalk instance so we set the level of
			-- the imported chalk object
			chalk.level = 0
			local formatted = formatLines(chalk)
			local converted = convertAnsi(formatted)
			chalk.level = 2
			jestExpect(converted).toBe(expected0)
			jestExpect(formatted).toBe(expected0)
		end)

		-- deviation: test skipped because we don't have level 1 support in chalk-lua
		itSKIP('level 1', function()
			-- deviation: we don't have a chalk instance so we set the level of
			-- the imported chalk object
			chalk.level = 1
			local formatted = formatLines(chalk)
			local converted = convertAnsi(formatted)
			chalk.level = 2

			jestExpect(converted).toBe(expected1)
			jestExpect(formatted).toContain(aOpenForeground1 .. aOpenBackground1 .. '-')
			jestExpect(formatted).toContain(bOpenForeground1 .. bOpenBackground1 .. '+')
			jestExpect(formatted).never.toContain(chalk.bgYellow(' ')) -- // noColor
			jestExpect(formatted).toContain(chalk.bgYellow('  '))
		end)

		it("level 2", function()
			-- deviation: we don't have a chalk instance so we set the level of
			-- the imported chalk object
			chalk.level = 2
			local formatted = formatLines(chalk)
			local converted = convertAnsi(formatted)

			jestExpect(converted).toBe(expected1)
			jestExpect(formatted).toContain(aOpenForeground2 .. aOpenBackground2 .. "-")
			jestExpect(formatted).toContain(bOpenForeground2 .. bOpenBackground2 .. "+")
			jestExpect(formatted).never.toContain(chalk.bgYellow(" "))
			jestExpect(formatted).toContain(chalk.bgYellow("  "))
		end)

		-- deviation: test skipped because we don't have level 1 support in chalk-lua
		itSKIP('level 3', function()
			-- deviation: we don't have a chalk instance so we set the level of
			-- the imported chalk object
			chalk.level = 3
			local formatted = formatLines(chalk)
			local converted = convertAnsi(formatted)
			chalk.level = 2

			jestExpect(converted).toBe(expected1)
			-- jestExpect(formatted).toContain(aOpenForeground3 .. aOpenBackground3 .. '-')
			-- jestExpect(formatted).toContain(bOpenForeground3 .. bOpenBackground3 .. '+')
			jestExpect(formatted).never.toContain(chalk.bgYellow(' ')) -- noColor
			jestExpect(formatted).toContain(chalk.bgYellow('  '))
		end)
	end)

	describe("matcher error", function()
		-- ROBLOX TODO: ADO-1552 add toMatchInlineSnapshot block

		describe("toMatchSnapshot", function()
			local received = {
				id = "abcdef",
				text = "Throw matcher error",
				type = "ADD_ITEM"
			}

			it("Expected properties must be an object (non-null)", function()
				local context = {
					isNot = false,
					promise = '',
				}
				local properties = function() return {} end

				jestExpect(function()
					toMatchSnapshot(context, received, properties)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("Expected properties must be an object (null) with hint", function()
				local context = {
					isNot = false,
					promise = '',
				}
				local properties = nil
				local hint = 'reminder'

				jestExpect(function()
					toMatchSnapshot(context, received, properties, hint)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("Expected properties must be an object (null) without hint", function()
				local context = {
					isNot = false,
					promise = '',
				}
				local properties = nil

				jestExpect(function()
					toMatchSnapshot(context, received, properties)
				end).toThrowErrorMatchingSnapshot()
			end)

			describe("received value must be an object", function()
				local context = {
					currentTestName = '',
					isNot = false,
					promise = '',
					snapshotState = {},
				}
				local properties = {}

				it('(non-null)', function()
					jestExpect(function()
						toMatchSnapshot(context, 'string', properties)
					end).toThrowErrorMatchingSnapshot()
				end)

				it('(null)', function()
					jestExpect(function()
						toMatchSnapshot(context, nil, properties)
					end).toThrowErrorMatchingSnapshot()
				end)
			end)

			-- deviation: skipping this test, to work with the TestEZ runner, our implementation auto-initializes snapshot state
			-- by default if it doesn't already exist
			itSKIP('Snapshot state must be initialized', function()
				-- local context = {
				-- 	isNot = false,
				-- 	promise = 'resolves',
				-- }
				-- local hint = 'initialize me'

				-- jestExpect(function()
				-- 	toMatchSnapshot(context, received, nil, hint)
				-- end).toThrowErrorMatchingSnapshot()
			end)
		end)

		-- ROBLOX TODO: ADO-1552 add toThrowErrorMatchingInlineSnapshot block

		describe("toThrowErrorMatchingSnapshot", function()
			it("Received value must be a function", function()
				local context = {
					isNot = false,
					promise = ""
				}

				local received = 13
				local fromPromise = false

				jestExpect(function()
					toThrowErrorMatchingSnapshot(context, received, nil, fromPromise)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("Snapshot matchers cannot be used with not", function()
				local context = {
					isNot = true,
					promise = ""
				}
				local received = Error('received')
				local hint = 'reminder'
				local fromPromise = true

				jestExpect(function()
					toThrowErrorMatchingSnapshot(context, received, hint, fromPromise)
				end).toThrowErrorMatchingSnapshot()
			end)

			-- // Future test: Snapshot hint must be a string
		end)
	end)

	describe("other error", function()
		describe("toThrowErrorMatchingSnapshot", function()
			it("Received function did not throw", function()
				local context = {
					isNot = false,
					promise = ""
				}

				local received = function() end
				local fromPromise = false

				jestExpect(function()
					toThrowErrorMatchingSnapshot(
						context,
						received,
						nil,
						fromPromise
					)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe("pass false", function()
		-- ROBLOX TODO: ADO-1552 add toMatchInlineSnapshot block

		describe("toMatchSnapshot", function()
			it("New snapshot was not written (multi line)", function()
				local context = {
					currentTestName = "New snapshot was not written",
					isNot = false,
					promise = "",
					snapshotState = {
						match = function(self, receivedTable)
							local received = receivedTable.received
							return {
								actual = format(received),
								count = 1,
								expected = nil,
								pass = false
							}
						end
					}
				}

				local received = "To write or not to write,\nthat is the question."
				local hint = "(CI)"

				local result = toMatchSnapshot(context, received, hint)
				local message = result.message
				local pass = result.pass
				jestExpect(pass).toBe(false)
				jestExpect(message()).toMatchSnapshot()
			end)

			it("New snapshot was not written (single line)", function()
				local context = {
					currentTestName = "New snapshot was not written",
					isNot = false,
					promise = "",
					snapshotState = {
						match = function(self, receivedTable)
							local received = receivedTable.received
							return {
								actual = format(received),
								count = 2,
								expected = nil,
								pass = false
							}
						end
					}
				}
				local received = "Write me if you can!"
				local hint = "(CI)"

				local result = toMatchSnapshot(context, received, hint)
				local message = result.message
				local pass = result.pass
				jestExpect(pass).toBe(false)
				jestExpect(message()).toMatchSnapshot()
			end)

			describe("with properties", function()
				local id = "abcdef"
				local properties = {id = id}
				local type_ = "ADD_ITEM"

				describe("equals false", function()
					local context = {
						currentTestName = "with properties",
						equals = function() return false end,
						isNot = false,
						promise = "",
						snapshotState = {
							fail = function(_, fullTestName)
								return fullTestName .. " 1" end,
						},
						utils = {
							iterableEquality = function() return {} end,
							subsetEquality = function() return {} end
						}
					}

					it("isLineDiffable false", function()
						local result = toMatchSnapshot(
							context,
							Error("Invalid array length"),
							{name = "Error"}
						)
						local message = result.message
						local pass = result.pass
						jestExpect(pass).toBe(false)
						jestExpect(message()).toMatchSnapshot()
					end)

					it("isLineDiffable true", function()
						local received = {
							id = "abcdefg",
							text = "Increase code coverage",
							type = type_
						}

						local result = toMatchSnapshot(context, received, properties)
						local message = result.message
						local pass = result.pass
						jestExpect(pass).toBe(false)
						jestExpect(message()).toMatchSnapshot()
					end)
				end)

				it("equals true", function()
					local context = {
						currentTestName = "with properties",
						equals = function() return true end,
						isNot = false,
						promise = "",
						snapshotState = {
							expand = false,
							match = function(self, receivedTable)
								local received = receivedTable.received
								return {
									actual = format(received),
									count = 1,
									expected = format({
										id = id,
										text = "snapshot",
										type = type_
									})
								}
							end,
							pass = false
						},
						utils = {
							iterableEquality = function() return {} end,
							subsetEquality = function() return {} end
						}
					}
					local received = {
						id = id,
						text = "received",
						type = type_
					}
					local hint = "change text value"

					local result = toMatchSnapshot(
						context,
						received,
						properties,
						hint
					)
					local message = result.message
					local pass = result.pass
					jestExpect(pass).toBe(false)
					jestExpect(message()).toMatchSnapshot()
				end)
			end)
		end)

		-- ROBLOX TODO: ADO-1552 skipping toThrowErrorMatchingInlineSnapshot block
	end)

	describe("pass true", function()
		describe("toMatchSnapshot", function()
			it("without properties", function()
				local context = {
					isNot = false,
					promise = "",
					snapshotState = {
						match = function(self)
							return {
								expected = "",
								pass = true
							}
						end
					}
				}
				local received = 7

				local pass = toMatchSnapshot(context, received).pass
				jestExpect(pass).toBe(true)
			end)
		end)
	end)

	describe("printPropertiesAndReceived", function()
		it("omit missing properties", function()
			local received = {
				b = {},
				branchMap = {},
				f = {},
				fnMap = {},
				-- // hash is missing
				path = "…",
				s = {},
				statementMap = {}
			}
			local properties = {
				hash = jestExpect.any("string"),
				path = jestExpect.any("string")
			}

			jestExpect(printPropertiesAndReceived(properties, received, false)).toMatchSnapshot()
		end)
	end)

	describe("printSnapshotAndReceived", function()
		-- // Simulate default serialization.
		local function testWithStringify(
			expected: any,
			received: any,
			expand: boolean
		): string
			return printSnapshotAndReceived(
				serialize(expected),
				serialize(received),
				received,
				expand
			)
		end

		-- // Simulate custom raw string serialization.
		local function testWithoutStringify(
			expected: string,
			received: string,
			expand: boolean
		): string
			return printSnapshotAndReceived(expected, received, received, expand)
		end

		describe('backtick', function()
			it('single line expected and received', function()
				local expected = 'var foo = `backtick`;'
				local received = 'var foo = tag`backtick`;'

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)
		end)

		describe('empty string', function()
			it('expected and received single line', function()
				local expected = ""
				local received = "single line string"

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('received and expected multi line', function()
				local expected = "multi\nline\nstring"
				local received = ""

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)
		end)

		describe('escape', function()
			it('double quote marks in string', function()
				local expected = 'What does "oobleck" mean?'
				local received = 'What does "ewbleck" mean?'

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('backslash in multi line string', function()
				local expected = 'Forward / slash and back \\ slash'
				local received = 'Forward / slash\nBack \\ slash'

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('backslash in single line string', function()
				local expected = 'forward / slash and back \\ slash'
				local received = 'Forward / slash and back \\ slash'

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			-- deviation: test skipped because we do not have support for the
			-- global flag in RegExp
			itSKIP('regexp', function()
				local expected = '\\(")'
				local received = '\\(")'
				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)
		end)

		describe('expand', function()
			-- // prettier/pull/522
			local expected = table.concat({
				'type TypeName<T> =',
				'T extends string ? "string" :',
				'T extends number ? "number" :',
				'T extends boolean ? "boolean" :',
				'T extends undefined ? "undefined" :',
				'T extends Function ? "function" :',
				'"object";',
				'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
				'type TypeName<T> = T extends string',
				'? "string"',
				': T extends number',
				'? "number"',
				': T extends boolean',
				'? "boolean"',
				': T extends undefined',
				'? "undefined"',
				': T extends Function ? "function" : "object";',
				''
			}, '\n')
			local received = table.concat({
				'type TypeName<T> =',
				'T extends string ? "string" :',
				'T extends number ? "number" :',
				'T extends boolean ? "boolean" :',
				'T extends undefined ? "undefined" :',
				'T extends Function ? "function" :',
				'"object";',
				'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
				'type TypeName<T> = T extends string',
				'? "string"',
				': T extends number',
				'? "number"',
				': T extends boolean',
				'? "boolean"',
				': T extends undefined',
				'? "undefined"',
				': T extends Function',
				'? "function"',
				': "object";',
				''
			}, '\n')

			it('false', function()
				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('true', function()
				jestExpect(testWithStringify(expected, received, true)).toMatchSnapshot()
			end)
		end)

		it('fallback to line diff', function()
			local expected = table.concat({
				'[...a, ...b,];',
				'[...a, ...b];',
				'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
				'[...a, ...b];',
				'[...a, ...b];',
				''
			}, '\n')

			local received = table.concat({
				'====================================options=====================================',
				'parsers: ["flow", "typescript"]',
				'printWidth: 80',
				'                                                                                | printWidth',
				'=====================================input======================================',
				'[...a, ...b,];',
				'[...a, ...b];',
				'',
				'=====================================output=====================================',
				'[...a, ...b];',
				'[...a, ...b];',
				'',
				'================================================================================'
			}, '\n')

			jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
		end)

		describe('has no common after clean up chaff', function()
			it('array', function()
				local expected = {'delete', 'two'}
				local received = {'insert', '2'}

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('string single line', function()
				local expected = 'delete'
				local received = 'insert'

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)
		end)

		describe("MAX_DIFF_STRING_LENGTH", function()
			describe("unquoted", function()
				-- // Do not call diffStringsUnified if either string is longer than max.
				local lessChange = chalk.inverse('single ')
				local less = 'single line'
				local more = 'multi line' .. string.rep('\n123456789', 2000) -- // 10 + 20K chars

				it('both are less', function()
					local less2 = 'multi\nline'
					local difference = printSnapshotAndReceived(less2, less, less, true)

					jestExpect(difference).toMatch('- multi')
					jestExpect(difference).toMatch('- line')
					jestExpect(difference).toContain(lessChange)
					jestExpect(difference).never.toMatch('+ single line')
				end)

				it('expected is more', function()
					local difference = printSnapshotAndReceived(less, more, more, true)

					jestExpect(difference).toMatch('- single line')
					jestExpect(difference).toMatch('+ multi line')
					jestExpect(difference).never.toContain(lessChange)
				end)

				it('received is more', function()
					local difference = printSnapshotAndReceived(less, more, more, true)

					jestExpect(difference).toMatch('- single line')
					jestExpect(difference).toMatch('+ multi line')
					jestExpect(difference).never.toContain(lessChange)
				end)
			end)

			describe("quoted", function()
				-- // Do not call diffStringsRaw if either string is longer than max.
				local lessChange = chalk.inverse('no')
				local less = 'no numbers'
				local more = 'many numbers' .. string.rep(' 123456789', 2000) -- // 12 + 20K chars
				local lessQuoted = '"' .. less .. '"'
				local moreQuoted = '"' .. more .. '"'

				it('both are less', function()
					local lessQuoted2 = '"0 numbers"'
					local stringified = printSnapshotAndReceived(
						lessQuoted2,
						lessQuoted,
						less,
						true
					)

					jestExpect(stringified).toMatch('Received:')
					jestExpect(stringified).toContain(lessChange)
					jestExpect(stringified).never.toMatch('+ Received')
				end)

				it('expected is more', function()
					local stringified = printSnapshotAndReceived(
						moreQuoted,
						lessQuoted,
						less,
						true
					)

					jestExpect(stringified).toMatch('Received:')
					jestExpect(stringified).toMatch(less)
					jestExpect(stringified).never.toMatch('+ Received')
					jestExpect(stringified).never.toContain(lessChange)
				end)

				it('received is more', function()
					local stringified = printSnapshotAndReceived(
						lessQuoted,
						moreQuoted,
						more,
						true
					)

					jestExpect(stringified).toMatch('Snapshot:')
					jestExpect(stringified).toMatch(less)
					jestExpect(stringified).never.toMatch('- Snapshot')
					jestExpect(stringified).never.toContain(lessChange)
				end)
			end)
		end)

		describe('isLineDiffable', function()
			describe('false', function()
				it('asymmetric matcher', function()
					local expected = nil
					local received = {asymmetricMatch = function(self) end}

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('boolean', function()
					local expected = true
					local received = false

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('date', function()
					local expected = DateTime.fromUniversalTime(2019, 9, 19)
					local received = DateTime.fromUniversalTime(2019, 9, 20)

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('error', function()
					local expected = Error('Cannot spread fragment "NameAndAppearances" within itself.')
					local received = Error('Cannot spread fragment "NameAndAppearancesAndFriends" within itself.')

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('function', function()
					-- deviation: changed undefined to nil
					local expected = nil
					local received = function() end

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('number', function()
					local expected = -0
					local received = 0/0

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)
			end)

			describe('true', function()
				it('array', function()
					local expected0 = {
						code = 4011,
						weight = 2.13
					}

					local expected1 = {
						code = 4019,
						count = 4
					}

					local expected = {expected0, expected1}

					local received = {
						Object.assign({_id = 'b14680dec683e744ada1f2fe08614086'}, expected0),
						Object.assign({_id = '7fc63ff01769c4fa7d9279e97e307829'}, expected1)
					}

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('object', function()
					local type_ = 'img'
					local expected = {
						props = {
							className = 'logo',
							src = '/img/jest.png'
						},
						type = type_
					}

					local received = {
						props = {
							alt = 'Jest logo',
							class = 'logo',
							src = '/img/jest.svg'
						},
						type = type_
					}

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				-- deviation: test skipped because there is no distinction
				-- between an empty array and an empty table in Lua
				itSKIP('single line expected and received', function()
					-- local expected = []
					-- local received = {}

					-- jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)

				it('single line expected and multi line received', function()
					local expected = {}
					local received = {0}

					jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
				end)
			end)
		end)

		it('multi line small change in one line and other is unchanged', function()
			local expected = "There is no route defined for key 'Settings'.\nMust be one of: 'Home'"
			local received = "There is no route defined for key Settings.\nMust be one of: 'Home'"

			jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
		end)

		it('multi line small changes', function()
			local expected = table.concat({
				'    69 | ',
				"    70 | test('assert.doesNotThrow', () => {",
				'  > 71 |   assert.doesNotThrow(() => {',
				'       |          ^',
				"    72 |     throw Error('err!');",
				'    73 |   });',
				'    74 | });',
				'    at Object.doesNotThrow (__tests__/assertionError.test.js:71:10)'
			}, '\n')
			local received = table.concat({
				'    68 | ',
				"    69 | test('assert.doesNotThrow', () => {",
				'  > 70 |   assert.doesNotThrow(() => {',
				'       |          ^',
				"    71 |     throw Error('err!');",
				'    72 |   });',
				'    73 | });',
				'    at Object.doesNotThrow (__tests__/assertionError.test.js:70:10)'
			}, '\n')

			jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
		end)

		it('single line large changes', function()
			local expected = 'Array length must be a finite positive integer'
			local received = 'Invalid array length'

			jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
		end)

		describe('ignore indentation', function()
			-- deviation: changed $$typeof to typeof
			local typeof_ = Symbol.for_('react.test.json')

			-- deviation: test skipped because we don't have support for react elements
			itSKIP('markup delete', function()
				local received = {
					["$$typeof"] = typeof_,
					children = {
						{
							["$$typeof"] = typeof_,
							children = {'Ignore indentation for most serialized objects'},
							type = 'h3'
						},
						{
							["$$typeof"] = typeof_,
							children = {
								'Call ',
								{
									["$$typeof"] = typeof_,
									children = {'diffLinesUnified2'},
									type = 'code'
								},
								' to compare without indentation'
							},
							type = 'p'
						}
					},
					type = 'div'
				}

				local expected = {
					["$$typeof"] = typeof_,
					children = {received},
					type = 'div'
				}

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			-- deviation: test skipped because we don't have support for react elements
			itSKIP('markup fall back', function()
				-- // Because text has more than one adjacent line.
				local text = table.concat({
					'for (key in foo) {',
					'  if (Object.prototype.hasOwnProperty.call(foo, key)) {',
					'    doSomething(key);',
					'  }',
					'}'
				}, '\n')

				local expected = {
					["$$typeof"] = typeof_,
					children = {text = text},
					props = {
						className = 'language-js',
					},
					type = 'pre',
				}

				local received = {
					["$$typeof"] = typeof_,
					children = {expected = expected},
					type = 'div',
				}

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			-- deviation: test skipped because we don't have support for react elements
			itSKIP('markup insert', function()
				local text = 'when'
				local expected = {
					["$$typeof"] = typeof_,
					children = {text = text},
					type = 'th',
				}

				local received = {
					["$$typeof"] = typeof_,
					children = {
						{
							["$$typeof"] = typeof_,
							children = {text = text},
							type = 'span',
						},
						{
							["$$typeof"] = typeof_,
							children = {'↓'},
							props = {
								title = 'ascending from older to newer',
							},
							type = 'abbr',
						},
					},
					type = 'th',
				}

				jestExpect(testWithStringify(expected, received, false)).toMatchSnapshot()
			end)

			describe('object', function()
				local text = 'Ignore indentation in snapshot'
				local time_ = '2019-11-11'
				local type_ = 'CREATE_ITEM'
				local less = {
					text = text,
					time = time_,
					type = type_
				}
				local more = {
					payload = {
						text = text,
						time = time_
					},
					type = type_
				}

				it('delete', function()
					jestExpect(testWithStringify(more, less, false)).toMatchSnapshot()
				end)

				it('insert', function()
					jestExpect(testWithStringify(less, more, false)).toMatchSnapshot()
				end)
			end)
		end)

		describe('without serialize', function()
			it('backtick single line expected and received', function()
				local expected = 'var foo = `backtick`;'
				local received = 'var foo = `back${x}tick`;'

				jestExpect(testWithoutStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('backtick single line expected and multi line received', function()
				local expected = 'var foo = `backtick`;'
				local received = 'var foo = `back\ntick`;'
				jestExpect(testWithoutStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('has no common after clean up chaff multi line', function()
				local expected = 'delete\ntwo'
				local received = 'insert\n2'

				jestExpect(testWithoutStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('has no common after clean up chaff single line', function()
				local expected = 'delete'
				local received = 'insert'

				jestExpect(testWithoutStringify(expected, received, false)).toMatchSnapshot()
			end)

			it('prettier/pull/5590', function()
				local expected = table.concat({
					'====================================options=====================================',
					'parsers: ["html"]',
					'printWidth: 80',
					'                                                                                | printWidth',
					'=====================================input======================================',
					'<img src="test.png" alt=\'John "ShotGun" Nelson\'>',
					'',
					'=====================================output=====================================',
					'<img src="test.png" alt="John &quot;ShotGun&quot; Nelson" />',
					'',
					'================================================================================'
				}, '\n')
				local received = table.concat({
					'====================================options=====================================',
					'parsers: ["html"]',
					'printWidth: 80',
					'                                                                                | printWidth',
					'=====================================input======================================',
					'<img src="test.png" alt=\'John "ShotGun" Nelson\'>',
					'',
					'=====================================output=====================================',
					'<img src="test.png" alt=\'John "ShotGun" Nelson\' />',
					'',
					'================================================================================'
				}, '\n')

				jestExpect(testWithoutStringify(expected, received, false)).toMatchSnapshot()
			end)
		end)
	end)
end