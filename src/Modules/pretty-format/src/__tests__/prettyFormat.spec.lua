-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/pretty-format/src/__tests__/prettyFormat.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return function()
	local prettyFormat = require(script.Parent.Parent).prettyFormat

	describe('prettyFormat()', function()
		-- deviation: omitted, no Argument type in lua

		it('prints an empty array', function()
			local val = {}
			expect(prettyFormat(val)).to.equal('Table {}')
		end)

		it('prints an array with items', function()
			local val = {1, 2, 3}
			expect(prettyFormat(val)).to.equal('Table {\n  1,\n  2,\n  3,\n}')
		end)

		-- deviation: omitted, no typed arrays in lua

		it('prints a nested array', function()
			local val = {{1, 2, 3}}
			expect(prettyFormat(val)).to.equal(
				'Table {\n  Table {\n    1,\n    2,\n    3,\n  },\n}'
			)
		end)

		it('prints true', function()
			local val = true
			expect(prettyFormat(val)).to.equal('true')
		end)

		it('prints false', function()
			local val = false
			expect(prettyFormat(val)).to.equal('false')
		end)

		-- deviation: omitted, no Error type in lua

		-- deviation: omitted, no Function constructor in lua

		it('prints an anonymous callback function', function()
			local val
			local f = function(cb)
			  val = cb
			end
			f(function() end)
			expect(prettyFormat(val)).to.equal('[Function anonymous]')
		end)

		it('prints an anonymous assigned function', function()
			local val = function() end
			expect(prettyFormat(val)).to.equal('[Function anonymous]')
		end)

		-- deviation: omitted, no named functions in lua

		it('can customize function names', function()
			local val = function() end
			expect(
				prettyFormat(val, {
					printFunctionName = false,
			})
			).to.equal('[Function]')
		end)

		it('prints inf', function()
			local val = math.huge
			expect(prettyFormat(val)).to.equal('inf')
		end)

		it('prints -inf', function()
			local val = -math.huge
			expect(prettyFormat(val)).to.equal('-inf')
		end)

		-- deviation: omitted, identical to 'prints an empty array' test

		it('prints a table with values', function()
			local val = {
				prop1 = 'value1',
				prop2 = 'value2'
			}
			expect(prettyFormat(val)).to.equal(
				'Table {\n  "prop1": "value1",\n  "prop2": "value2",\n}'
			)
		end)

		it('prints a table with non-string keys', function()
			local val = {
				[false] = 'boolean',
				['false'] = 'string',
				[0] = 'number',
				['0'] = 'string',
				['nil'] = 'string',
			}
			local expected = table.concat({
				'Table {',
				'  false: "boolean",',
				'  0: "number",',
				'  "0": "string",',
				'  "false": "string",',
				'  "nil": "string",',
				'}',
			}, '\n')
			expect(prettyFormat(val)).to.equal(expected)
		end)

		-- deviation: separate test case for table keys because table ordering is non-deterministic
		it('prints a table with table keys', function()
			local val = {
				[{'array', 'key'}] = 'array'
			}
			local expected = table.concat({
				'Table {',
				'  Table {',
				'    "array",',
				'    "key",',
				'  }: "array",',
				'}',
			}, '\n')
			expect(prettyFormat(val)).to.equal(expected)
		end)

		it('prints nan', function()
			local val = 0/0
			expect(prettyFormat(val)).to.equal('nan')
		end)

		it('prints nil', function()
			local val = nil
			expect(prettyFormat(val)).to.equal('nil')
		end)

		it('prints a positive number', function()
			local val = 123
			expect(prettyFormat(val)).to.equal('123')
		end)

		it('prints a negative number', function()
			local val = -123
			expect(prettyFormat(val)).to.equal('-123')
		end)

		it('prints zero', function()
			local val = 0
			expect(prettyFormat(val)).to.equal('0')
		end)

		it('prints negative zero', function()
			local val = -0
			expect(prettyFormat(val)).to.equal('-0')
		end)

		-- deviation: omitted, no BigInt type in lua

		-- deviation: Date modified to use Roblox DateTime
		it('prints a date', function()
			local val = DateTime.fromUnixTimestampMillis(10e11)
			expect(prettyFormat(val)).to.equal('2001-09-09T01:46:40.000Z')
		end)

		-- deviation: omitted, Roblox DateTime throws an error with an invalid constructor

		-- deviation: omitted, no Object, RegExp, Set type in lua

		it('prints a string', function()
			local val = 'string'
			expect(prettyFormat(val)).to.equal('"string"')
		end)

		it('prints and escape a string', function()
			local val = '"\'\\'
			expect(prettyFormat(val)).to.equal('"\\"\'\\\\"')
		end)

		it("doesn't escape string with {escapeString: false}", function()
			local val = '"\'\\n'
			expect(prettyFormat(val, {escapeString = false})).to.equal('""\'\\n"')
		end)

		it('prints a string with escapes', function()
			expect(prettyFormat('"-"')).to.equal('"\\"-\\""')
			expect(prettyFormat('\\ \\\\')).to.equal('"\\\\ \\\\\\\\"')
		end)

		it('prints a multiline string', function()
			local val = table.concat({'line 1', 'line 2', 'line 3'}, '\n')
			expect(prettyFormat(val)).to.equal('"' .. val .. '"')
		end)

		it('prints a multiline string as value of table', function()
			local polyline = {
				props = {
					id = 'J',
					points = table.concat({'0.5,0.460', '0.5,0.875', '0.25,0.875'}, '\n'),
				},
				type = 'polyline',
			}
			local val = {
				props = {
					children = polyline,
				},
				type = 'svg',
			}
			expect(prettyFormat(val)).to.equal(
				table.concat({
					'Table {',
					'  "props": Table {',
					'    "children": Table {',
					'      "props": Table {',
					'        "id": "J",',
					'        "points": "0.5,0.460',
					'0.5,0.875',
					'0.25,0.875",',
					'      },',
					'      "type": "polyline",',
					'    },',
					'  },',
					'  "type": "svg",',
					'}',
				}, '\n')
			)
		end)

		-- deviation: omitted, no Symbol, undefined, WeakMap, WeakSet

		-- deviation: converted these tests to use tables
		it('prints deeply nested tables', function()
			local val = {prop = {prop = {prop = 'value'}}}
			expect(prettyFormat(val)).to.equal(
				'Table {\n  "prop": Table {\n    "prop": Table {\n      "prop": "value",\n    },\n  },\n}'
			)
		end)

		it('prints circular references', function()
			local val = {}
			val['prop'] = val
			expect(prettyFormat(val)).to.equal('Table {\n  "prop": [Circular],\n}')
		end)

		it('prints parallel references', function()
			local inner = {}
			local val = {prop1 = inner, prop2 = inner}
			expect(prettyFormat(val)).to.equal(
				'Table {\n  "prop1": Table {},\n  "prop2": Table {},\n}'
			)
		end)

		describe('indent option', function()
			local val = {
				{
					id = '8658c1d0-9eda-4a90-95e1-8001e8eb6036',
					text = 'Add alternative serialize API for pretty-format plugins',
					type = 'ADD_TODO',
				},
				{
					id = '8658c1d0-9eda-4a90-95e1-8001e8eb6036',
					type = 'TOGGLE_TODO',
				},
			}
			local expected = table.concat({
				'Table {',
				'  Table {',
				'    "id": "8658c1d0-9eda-4a90-95e1-8001e8eb6036",',
				'    "text": "Add alternative serialize API for pretty-format plugins",',
				'    "type": "ADD_TODO",',
				'  },',
				'  Table {',
				'    "id": "8658c1d0-9eda-4a90-95e1-8001e8eb6036",',
				'    "type": "TOGGLE_TODO",',
				'  },',
				'}',
			}, '\n')
			it('default implicit: 2 spaces', function()
				expect(prettyFormat(val)).to.equal(expected)
			end)
			it('default explicit: 2 spaces', function()
				expect(prettyFormat(val, {indent = 2})).to.equal(expected)
			end)

			-- // Tests assume that no strings in val contain multiple adjacent spaces!
			it('non-default: 0 spaces', function()
				expect(prettyFormat(val, {indent = 0})).to.equal(
					expected:gsub('  ', '')
				)
			end)
			it('non-default: 4 spaces', function()
				expect(prettyFormat(val, {indent = 4})).to.equal(
					expected:gsub('  ', '    ')
				)
			end)
		end)

		-- deviation: modified since we don't have most of these types
		it('can customize the max depth', function()
			local val = {
				{
					['array literal empty'] = {},
					['array literal non-empty'] = {'item'},
					['table nested'] = { name = { name = 'value' } },
					['table non-empty'] = { name = 'value' },
				},
			}
			expect(prettyFormat(val, {maxDepth = 2})).to.equal(
				table.concat({
					'Table {',
					'  Table {',
					'    "array literal empty": [Table],',
					'    "array literal non-empty": [Table],',
					'    "table nested": [Table],',
					'    "table non-empty": [Table],',
					'  },',
					'}',
				}, '\n')
			)
		end)

		it('throws on invalid options', function()
			expect(function()
				prettyFormat({}, {invalidOption = true})
			end).to.throw()
		end)

		it('supports plugins', function()
			local Foo = {
				name = 'Foo'
			}

			expect(
				prettyFormat(Foo, {
					plugins = {
						{
							print = function() return 'class Foo' end,
							test = function(object)
								return object.name == 'Foo'
							end,
						},
					}
				})
			).to.equal('class Foo')
		end)

		it('supports plugins that return empty string', function()
			local val = {
				payload = '',
			}
			local options = {
				plugins = {
					{
						print = function(v)
							return v.payload
						end,
						test = function(v)
							return v and typeof(v.payload) == 'string'
						end,
					},
				},
			}
			expect(prettyFormat(val, options)).to.equal('')
		end)

		it('throws if plugin does not return a string', function()
			local val = 123
			local options = {
				plugins = {
					{
						print = function(v)
							return v
						end,
						test = function(v)
							return true
						end,
					},
				},
			}
			expect(function()
				prettyFormat(val, options)
			end).to.throw()
		end)

		it('throws PrettyFormatPluginError if test throws an error', function()
			local options = {
				plugins = {
					{
						print = function() return '' end,
						test = function()
							error('Where is the error?')
						end,
					},
				},
			}

			expect(function()
				prettyFormat('', options)
			end).to.throw('PrettyFormatPluginError')
		end)

		it('throws PrettyFormatPluginError if print throws an error', function()
			local options = {
				plugins = {
					{
						print = function()
							error('Where is the error?')
						end,
						test = function() return true end,
					},
				},
			}

			expect(function()
				prettyFormat('', options)
			end).to.throw('PrettyFormatPluginError')
		end)

		it('throws PrettyFormatPluginError if serialize throws an error', function()
			local options = {
				plugins = {
					{
						serialize = function()
							error('Where is the error?')
						end,
						test = function() return true end,
					},
				},
			}

			expect(function()
				prettyFormat('', options)
			end).to.throw('PrettyFormatPluginError')
		end)

		it('supports plugins with deeply nested arrays (#24)', function()
			local val = {
				{1, 2},
				{3, 4},
			}
			expect(
				prettyFormat(val, {
					plugins = {
						{
							print = function(v, f)
								local t = {}
								for i, _ in ipairs(v) do
									t[i] = f(v[i])
								end
								return table.concat(t, ' - ')
							end,
							test = function(v)
								return typeof(v) == 'table'
							end,
						},
					},
				})
			).to.equal('1 - 2 - 3 - 4')
		end)

		it('should call plugins on nested basic values', function()
			local val = {prop = 42}
			expect(
				prettyFormat(val, {
					plugins = {
						{
							print = function(_val, _print)
								return '[called]'
							end,
							test = function(v)
								return typeof(v) == 'string' or typeof(v) == 'number'
							end,
						},
					},
				})
			).to.equal('Table {\n  [called]: [called],\n}')
		end)

		-- deviation: omitted, identical to empty table test

		it('calls toJSON and prints its return value', function()
			expect(
				prettyFormat({
					toJSON = function() return {value = false} end,
					value = true,
				})
			).to.equal('Table {\n  "value": false,\n}')
		end)

		it('calls toJSON and prints an internal representation.', function()
			expect(
				prettyFormat({
					toJSON = function() return '[Internal Object]' end,
					value = true,
				})
			).to.equal('"[Internal Object]"')
		end)

		it('calls toJSON only on functions', function()
			expect(
				prettyFormat({
					toJSON = false,
					value = true,
				})
			).to.equal('Table {\n  "toJSON": false,\n  "value": true,\n}')
		end)

		it('does not call toJSON recursively', function()
			expect(
				prettyFormat({
					toJSON = function()
						return {toJSON = function() return {value = true} end}
					end,
					value = false,
				})
			).to.equal('Table {\n  "toJSON": [Function anonymous],\n}')
		end)

		-- deviation: modified to use table instead of set
		it('calls toJSON on Tables', function()
			local set = {}
			set.toJSON = function() return 'map' end
			expect(prettyFormat(set)).to.equal('"map"')
		end)

		it('disables toJSON calls through options', function()
			local value = {apple = 'banana', toJSON = function() return '1' end}
			local set = { [1] = value }
			set['toJSON'] = function() return 'map' end
			expect(
				prettyFormat(set, {
					callToJSON = false,
				})
			).to.equal(
				'Table {\n  Table {\n    "apple": "banana",\n    "toJSON": [Function anonymous' ..
					'],\n  },\n}'
			)
			-- deviation: omitted, no toBeCalled in TestEZ
		end)

		describe('min', function()
			it('prints some basic values in min mode', function()
				local val = {
					['boolean'] = {false, true},
					-- deviation: not set to nil because if value is nil then the key isn't set
					['nil'] = 0,
					['number'] = {0, -0, 123, -123, math.huge, -math.huge, 0/0},
					['string'] = {'', 'non-empty'},
				}
				expect(
					prettyFormat(val, {
						min = true
					})
				).to.equal(
					'{' ..
					table.concat({
						'"boolean": {false, true}',
						'"nil": 0',
						'"number": {0, -0, 123, -123, inf, -inf, nan}',
						'"string": {"", "non-empty"}',
					}, ', ') ..
					'}'
				)
			end)

			-- deviation: modified since we don't have most of these types
			it('prints some complex values in min mode', function()
				local val = {
					['array literal empty'] = {},
					['array literal non-empty'] = {'item'},
					['table non-empty'] = {name = 'value'},
				}
				expect(
					prettyFormat(val, {
						min = true
					})
				).to.equal(
					'{' ..
					table.concat({
						'"array literal empty": {}',
						'"array literal non-empty": {"item"}',
						'"table non-empty": {"name": "value"}',
					}, ', ') ..
					'}'
				)
			end)

			it('does not allow indent !== 0 in min mode', function()
				expect(function()
					prettyFormat(1, {indent = 1, min = true})
				end).to.throw()
			end)
		end)
	end)
end