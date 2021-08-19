--!nocheck
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/__tests__/mock_serializer.test.ts
-- /**
-- * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
-- *
-- * This source code is licensed under the MIT license found in the
-- * LICENSE file in the root directory of this source tree.
-- *
-- */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Symbol = LuauPolyfill.Symbol

	local jestExpect = require(Packages.Expect)
	local jest = require(Packages.Dev.Jest)

	local prettyFormat = require(Packages.PrettyFormat).prettyFormat

	local plugin_ = require(CurrentModule.mock_serializer)

	it('mock with 0 calls and default name', function()
		local fn = jest.fn()
		jestExpect(fn).toMatchSnapshot()
	end)

	it('mock with 1 calls and non-default name via new in object', function()
		local fn = jest.fn()
		fn.mockName('MyConstructor')
		-- deviation: we add a mockReturnValueOnce statement because by default the return value
		-- would be nil and then would not be printed in output since nil table values don't get
		-- examined by Lua
		fn.mockReturnValueOnce('undefined')
		fn.new({name = 'some fine name'})
		local val = {
			fn = fn
		}
		jestExpect(val).toMatchSnapshot()
	end)

	-- deviation: skipped because we don't have support for React elements in prettyFormat
	itSKIP('mock with 1 calls in React element', function()
		local fn = jest.fn()
		fn('Mocking you!')
		local val = {
			["$$typeof"] = Symbol.for_('react.test.json'),
			children = {'Mock me!'},
			props = {
				onClick = fn
			},
			type = 'button'
		}
		jestExpect(val).toMatchSnapshot()
	end)

	it('mock with 2 calls', function()
		local fn = jest.fn()
		-- deviation: we add a mockReturnValue statement because by default the return value
		-- would be nil and then would not be printed in output since nil table values don't get
		-- examined by Lua
		fn.mockReturnValue('undefined')
		fn()
		fn({foo = 'bar'}, 42)
		jestExpect(fn).toMatchSnapshot()
	end)

	it('indent option', function()
		local fn = jest.fn(function(val) return val end)
		fn({key = 'value'})
		-- deviation: replaced Array with Table, Object with Table and [] with {}
		local expected = table.concat({
			'[MockFunction] {',
			'"calls": Table {',
			'Table {',
			'Table {',
			'"key": "value",',
			'},',
			'},',
			'},',
			'"results": Table {',
			'Table {',
			'"type": "return",',
			'"value": Table {',
			'"key": "value",',
			'},',
			'},',
			'},',
			'}'
		}, '\n')
		jestExpect(prettyFormat(fn, {indent = 0, plugins = {plugin_}})).toBe(expected)
	end)

	it('min option', function()
		local fn = jest.fn(function(val) return val end)
		fn({key = 'value'})
		-- deviation: replaced [] with {}
		local expected =
			'[MockFunction] {"calls": {{{"key": "value"}}}, "results": {{"type": "return", "value": {"key": "value"}}}}'
		jestExpect(prettyFormat(fn, {min = true, plugins = {plugin_}})).toBe(expected)
	end)

	it('maxDepth option', function()
		local fn1 = jest.fn()
		fn1.mockName('atDepth1')
		-- deviation: we add a mockReturnValueOnce statement because by default the return value
		-- would be nil and then would not be printed in output since nil table values don't get
		-- examined by Lua
		fn1.mockReturnValueOnce('undefined')
		fn1('primitive', {key = 'value'})
		local fn2 = jest.fn()
		fn2.mockName('atDepth2')
		fn2('primitive', {key = 'value'})
		local fn3 = jest.fn()
		fn3.mockName('atDepth3')
		fn3('primitive', {key = 'value'})
		local val = {
			fn1 = fn1,
			greaterThan1 = {
				fn2 = fn2,
				greaterThan2 = {
					fn3 = fn3
				}
			}
		}

		-- deviation: replaced Array with Table, Object with Table and [] with {}
		local expected = table.concat({
			'Table {', -- // ++depth === 1
			'  "fn1": [MockFunction atDepth1] {',
			'    "calls": Table {', -- // ++depth === 2
			'      Table {', -- // ++depth === 3
			'        "primitive",',
			'        [Table],', -- // ++depth === 4
			'      },',
			'    },',
			'    "results": Table {', -- // ++depth === 2
			'      Table {', -- // ++depth === 3
			'        "type": "return",',
			'        "value": "undefined",',
			'      },',
			'    },',
			'  },',
			'  "greaterThan1": Table {', -- // ++depth === 2
			'    "fn2": [MockFunction atDepth2] {',
			'      "calls": Table {', -- // ++depth === 3
			'        [Table],', -- // ++depth === 4
			'      },',
			'      "results": Table {', -- // ++depth === 3
			'        [Table],', -- // ++depth === 4
			'      },',
			'    },',
			'    "greaterThan2": Table {', -- // ++depth === 3
			'      "fn3": [MockFunction atDepth3] {',
			'        "calls": [Table],', -- // ++depth === 4
			'        "results": [Table],', -- // ++depth === 4
			'      },',
			'    },',
			'  },',
			'}'
		}, '\n')
		jestExpect(prettyFormat(val, {maxDepth = 3, plugins = {plugin_}})).toBe(expected)
	end)
end