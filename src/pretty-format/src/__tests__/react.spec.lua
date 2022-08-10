-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/__tests__/react.test.tsx
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

type unknown = any --[[ ROBLOX FIXME: adding `unknown` type alias to make it easier to use Luau unknown equivalent when supported ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Symbol = LuauPolyfill.Symbol

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip
local itFIXME = function(description: string, ...: any)
	JestGlobals.it.todo(description)
end

local React = require(Packages.Dev.React)
type ReactElement = React.ReactElement
local renderer = require(Packages.Dev.ReactTestRenderer)
local ParentModule = require(script.Parent.Parent)
local prettyFormat = ParentModule.default
local plugins = ParentModule.plugins
local typesModule = require(script.Parent.Parent.Types)
type OptionsReceived = typesModule.OptionsReceived

-- ROBLOX deviation START: using same numbers as used in roact-alignment until it uses Symbols
-- local elementSymbol = Symbol.for_("react.element")
-- local fragmentSymbol = Symbol.for_("react.fragment")
-- local suspenseSymbol = Symbol.for_("react.suspense")
local elementSymbol = 0xeac7
local fragmentSymbol = 0xeacb
local suspenseSymbol = 0xead1
local testSymbol = Symbol.for_("react.test.json")
-- ROBLOX deviation END

local ReactElement, ReactTestComponent = plugins.ReactElement, plugins.ReactTestComponent

local function formatElement(element: unknown, options: OptionsReceived?)
	local opts = Object.assign({}, { plugins = { ReactElement } }, options)
	return prettyFormat(element, opts)
end

local function formatTestObject(object: unknown, options: OptionsReceived?)
	return prettyFormat(object, Object.assign({}, { plugins = { ReactTestComponent, ReactElement } }, options))
end

local function assertPrintedJSX(val: unknown, expected: string, options: OptionsReceived?)
	jestExpect(formatElement(val, options)).toEqual(expected)
	jestExpect(formatTestObject(renderer.create(val):toJSON(), options)).toEqual(expected)
end

it("supports a single element with no props or children", function()
	assertPrintedJSX(React.createElement("Mouse"), "<Mouse />")
end)

it("supports a single element with non-empty string child", function()
	assertPrintedJSX(React.createElement("Mouse", nil, "Hello World"), "<Mouse>\n  Hello World\n</Mouse>")
end)

it("supports a single element with empty string child", function()
	assertPrintedJSX(React.createElement("Mouse", nil, ""), "<Mouse>\n  \n</Mouse>")
end)

it("supports a single element with non-zero number child", function()
	assertPrintedJSX(React.createElement("Mouse", nil, 4), "<Mouse>\n  4\n</Mouse>")
end)

it("supports a single element with zero number child", function()
	assertPrintedJSX(React.createElement("Mouse", nil, 0), "<Mouse>\n  0\n</Mouse>")
end)

-- ROBLOX FIXME: I don't know why does it fail
itFIXME("supports a single element with mixed children", function()
	assertPrintedJSX(
		-- ROBLOX FIXME Luau: roblox-cli doesn't allow for mixed arrays
		React.createElement("Mouse", nil, { { 1 :: any, nil } :: any, 2, nil, { false :: any, { 3 } } }),
		"<Mouse>\n  1\n  2\n  3\n</Mouse>"
	)
end)

it("supports props with strings", function()
	assertPrintedJSX(React.createElement("Mouse", { style = "color:red" }), '<Mouse\n  style="color:red"\n/>')
end)

it("supports props with multiline strings", function()
	local val = React.createElement(
		"svg",
		nil,
		React.createElement(
			"polyline",
			{ id = "J", points = Array.join({ "0.5,0.460", "0.5,0.875", "0.25,0.875" }, "\n") }
		)
	)
	local expected = Array.join({
		"<svg>",
		"  <polyline",
		'    id="J"',
		'    points="0.5,0.460',
		"0.5,0.875",
		'0.25,0.875"',
		"  />",
		"</svg>",
	}, "\n")
	assertPrintedJSX(val, expected)
end)

it("supports props with numbers", function()
	assertPrintedJSX(React.createElement("Mouse", { size = 5 }), "<Mouse\n  size={5}\n/>")
end)

it("supports a single element with a function prop", function()
	assertPrintedJSX(
		React.createElement("Mouse", { onclick = function(self) end }),
		"<Mouse\n  onclick={[Function onclick]}\n/>"
	)
end)

it("supports a single element with a object prop", function()
	assertPrintedJSX(
		React.createElement("Mouse", { customProp = { one = "1", two = 2 } }),
		'<Mouse\n  customProp={\n    Table {\n      "one": "1",\n      "two": 2,\n    }\n  }\n/>'
	)
end)

it("supports an element with and object prop and children", function()
	assertPrintedJSX(
		React.createElement("Mouse", { customProp = { one = "1", two = 2 } }, React.createElement("Mouse")),
		'<Mouse\n  customProp={\n    Table {\n      "one": "1",\n      "two": 2,\n    }\n  }\n>\n  <Mouse />\n</Mouse>'
	)
end)

it("supports an element with complex props and mixed children", function()
	assertPrintedJSX(
		React.createElement(
			"Mouse",
			{ customProp = { one = "1", two = 2 }, onclick = function(self) end },
			"HELLO",
			React.createElement("Mouse"),
			"CIAO"
		),
		'<Mouse\n  customProp={\n    Table {\n      "one": "1",\n      "two": 2,\n    }\n  }\n  onclick={[Function onclick]}\n>\n  HELLO\n  <Mouse />\n  CIAO\n</Mouse>'
	)
end)

it("escapes children properly", function()
	assertPrintedJSX(
		React.createElement("Mouse", nil, '"-"', React.createElement("Mouse"), "\\ \\\\"),
		'<Mouse>\n  "-"\n  <Mouse />\n  \\ \\\\\n</Mouse>'
	)
end)

it("supports everything all together", function()
	assertPrintedJSX(
		React.createElement(
			"Mouse",
			{ customProp = { one = "1", two = 2 }, onclick = function(self) end },
			"HELLO",
			React.createElement(
				"Mouse",
				{ customProp = { one = "1", two = 2 }, onclick = function(self) end },
				"HELLO",
				React.createElement("Mouse"),
				"CIAO"
			),
			"CIAO"
		),
		'<Mouse\n  customProp={\n    Table {\n      "one": "1",\n      "two": 2,\n    }\n  }\n  onclick={[Function onclick]}\n>\n  HELLO\n  <Mouse\n    customProp={\n      Table {\n        "one": "1",\n        "two": 2,\n      }\n    }\n    onclick={[Function onclick]}\n  >\n    HELLO\n    <Mouse />\n    CIAO\n  </Mouse>\n  CIAO\n</Mouse>'
	)
end)

it("sorts props in nested components", function()
	--[[ eslint-disable sort-keys ]]
	assertPrintedJSX(
		React.createElement(
			"Mouse",
			{ zeus = "kentaromiura watched me fix this", abc = { one = "1", two = 2 } },
			React.createElement("Mouse", { xyz = 123, acbd = { one = "1", two = 2 } }, "NESTED")
		),
		'<Mouse\n  abc={\n    Table {\n      "one": "1",\n      "two": 2,\n    }\n  }\n  zeus="kentaromiura watched me fix this"\n>\n  <Mouse\n    acbd={\n      Table {\n        "one": "1",\n        "two": 2,\n      }\n    }\n    xyz={123}\n  >\n    NESTED\n  </Mouse>\n</Mouse>'
	)
	--[[ eslint-enable sort-keys ]]
end)

it("supports a single element with React elements as props", function()
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement("div") }),
		"<Mouse\n  prop={<div />}\n/>"
	)
end)

it("supports a single element with React elements with props", function()
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement("div", { foo = "bar" }) }),
		'<Mouse\n  prop={\n    <div\n      foo="bar"\n    />\n  }\n/>'
	)
end)

it("supports a single element with custom React elements with props", function()
	local function Cat()
		return React.createElement("div")
	end
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement(Cat, { foo = "bar" }) }),
		'<Mouse\n  prop={\n    <Cat\n      foo="bar"\n    />\n  }\n/>'
	)
end)

it("supports a single element with custom React elements with props (using displayName)", function()
	local Cat = setmetatable({}, {
		__call = function(_self)
			return React.createElement("div")
		end,
	})
	Cat.displayName = "CatDisplayName"
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement(Cat :: any, { foo = "bar" }) }),
		'<Mouse\n  prop={\n    <CatDisplayName\n      foo="bar"\n    />\n  }\n/>'
	)
end)

it("supports a single element with custom React elements with props (using anonymous function)", function()
	assertPrintedJSX(
		React.createElement("Mouse", {
			prop = React.createElement(function()
				return React.createElement("div")
			end, { foo = "bar" }),
		}),
		'<Mouse\n  prop={\n    <Unknown\n      foo="bar"\n    />\n  }\n/>'
	)
end)

it("supports a single element with custom React elements with a child", function()
	local function Cat(props: unknown)
		return React.createElement("div", props)
	end
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement(Cat, {}, React.createElement("div")) }),
		"<Mouse\n  prop={\n    <Cat>\n      <div />\n    </Cat>\n  }\n/>"
	)
end)

it("supports undefined element type", function()
	jestExpect(formatElement({ ["$$typeof"] = elementSymbol, props = {} })).toEqual("<UNDEFINED />")
end)

it("supports a fragment with no children", function()
	jestExpect(formatElement({ ["$$typeof"] = elementSymbol, props = {}, type = fragmentSymbol })).toEqual(
		"<React.Fragment />"
	)
end)

it("supports a fragment with string child", function()
	jestExpect(formatElement({
		["$$typeof"] = elementSymbol,
		props = { children = "test" },
		type = fragmentSymbol,
	})).toEqual("<React.Fragment>\n  test\n</React.Fragment>")
end)

it("supports a fragment with element child", function()
	jestExpect(formatElement({
		["$$typeof"] = elementSymbol,
		props = { children = React.createElement("div", nil, "test") },
		type = fragmentSymbol,
	})).toEqual("<React.Fragment>\n  <div>\n    test\n  </div>\n</React.Fragment>")
end)

it("supports suspense", function()
	jestExpect(formatElement({
		["$$typeof"] = elementSymbol,
		props = { children = React.createElement("div", nil, "test") },
		type = suspenseSymbol,
	})).toEqual("<React.Suspense>\n  <div>\n    test\n  </div>\n</React.Suspense>")
end)

it("supports a single element with React elements with a child", function()
	assertPrintedJSX(
		React.createElement("Mouse", { prop = React.createElement("div", nil, "mouse") }),
		"<Mouse\n  prop={\n    <div>\n      mouse\n    </div>\n  }\n/>"
	)
end)

it("supports a single element with React elements with children", function()
	assertPrintedJSX(
		React.createElement("Mouse", {
			prop = React.createElement("div", nil, "mouse", React.createElement("span", nil, "rat")),
		}),
		"<Mouse\n  prop={\n    <div>\n      mouse\n      <span>\n        rat\n      </span>\n    </div>\n  }\n/>"
	)
end)

it("supports a single element with React elements with array children", function()
	assertPrintedJSX(
		React.createElement("Mouse", {
			prop = React.createElement("div", nil, "mouse", {
				React.createElement("span", { key = 1 }, "rat"),
				React.createElement("span", { key = 2 }, "cat"),
			}),
		}),
		"<Mouse\n  prop={\n    <div>\n      mouse\n      <span>\n        rat\n      </span>\n      <span>\n        cat\n      </span>\n    </div>\n  }\n/>"
	)
end)

it("supports array of elements", function()
	local val = {
		React.createElement("dt", nil, "jest"),
		React.createElement("dd", nil, "to talk in a playful manner"),
		-- FIXME luau: luau wants to align the props interface for these
		-- elements, but will only accept nil because of the first element
		React.createElement("dd", { style = { color = "#99424F" } } :: any, "painless JavaScript testing"),
	}
	local expected = Array.join({
		"Table {",
		"  <dt>",
		"    jest",
		"  </dt>,",
		"  <dd>",
		"    to talk in a playful manner",
		"  </dd>,",
		"  <dd",
		"    style={",
		"      Table {",
		'        "color": "#99424F",',
		"      }",
		"    }",
		"  >",
		"    painless JavaScript testing",
		"  </dd>,",
		"}",
	}, "\n")
	jestExpect(formatElement(val)).toEqual(expected)
	jestExpect(formatTestObject(Array.map(val, function(element)
		return renderer.create(element):toJSON()
	end))).toEqual(expected)
end)

describe("test object for subset match", function()
	-- Although test object returned by renderer.create(element).toJSON()
	-- has both props and children, make sure plugin allows them to be undefined.
	it("undefined props", function()
		local val = { ["$$typeof"] = testSymbol, children = { "undefined props" }, type = "span" }
		jestExpect(formatTestObject(val)).toEqual("<span>\n  undefined props\n</span>")
	end)

	it("undefined children", function()
		local val = {
			["$$typeof"] = testSymbol,
			props = { className = "undefined children" },
			type = "span",
		}
		jestExpect(formatTestObject(val)).toEqual('<span\n  className="undefined children"\n/>')
	end)
end)

describe("indent option", function()
	local val = React.createElement(
		"ul",
		nil,
		React.createElement("li", { style = { color = "green", textDecoration = "none" } }, "Test indent option")
	)
	local expected = Array.join({
		"<ul>",
		"  <li",
		"    style={",
		"      Table {",
		'        "color": "green",',
		'        "textDecoration": "none",',
		"      }",
		"    }",
		"  >",
		"    Test indent option",
		"  </li>",
		"</ul>",
	}, "\n")

	it("default implicit: 2 spaces", function()
		assertPrintedJSX(val, expected)
	end)

	it("default explicit: 2 spaces", function()
		assertPrintedJSX(val, expected, { indent = 2 })
	end)

	-- Tests assume that no strings in val contain multiple adjacent spaces!
	it("non-default: 0 spaces", function()
		local indent = 0
		assertPrintedJSX(val, expected:gsub("  ", string.rep(" ", indent)), { indent = indent })
	end)

	it("non-default: 4 spaces", function()
		local indent = 4
		assertPrintedJSX(val, expected:gsub("  ", string.rep(" ", indent)), { indent = indent })
	end)
end)

describe("maxDepth option", function()
	it("elements", function()
		local maxDepth = 2
		local val = React.createElement( -- ++depth === 1
			"dl",
			nil,
			React.createElement("dt", { id = "jest" }, "jest"), -- ++depth === 2
			React.createElement( -- ++depth === 2
				"dd",
				{ id = "jest-1" },
				"to talk in a ",
				React.createElement("em", nil, "playful"), -- ++depth === 3
				" manner"
			),
			React.createElement( -- ++ depth === 2
				"dd",
				{
					id = "jest-2",
					style = { -- ++depth === 3
						color = "#99424F",
					},
				},
				React.createElement("em", nil, "painless"), -- ++depth === 3
				" JavaScript testing"
			)
		)
		local expected = Array.join({
			"<dl>",
			"  <dt",
			'    id="jest"',
			"  >",
			"    jest",
			"  </dt>",
			"  <dd",
			'    id="jest-1"',
			"  >",
			"    to talk in a ",
			"    <em \u{2026} />",
			"     manner",
			"  </dd>",
			"  <dd",
			'    id="jest-2"',
			"    style={[Table]}",
			"  >",
			"    <em \u{2026} />",
			"     JavaScript testing",
			"  </dd>",
			"</dl>",
		}, "\n")
		assertPrintedJSX(val, expected, { maxDepth = maxDepth })
	end)

	it("array of elements", function()
		local maxDepth = 2
		local array = { -- ++depth === 1
			React.createElement( -- ++depth === 2
				"dd",
				{ id = "jest-1" },
				"to talk in a ",
				React.createElement("em", nil, "playful"), -- ++depth === 3
				" manner"
			),
			-- FIXME luau: it looks like luau infers a prop interface from
			-- the first element and fails to coerce the second one to match
			React.createElement( -- ++ depth === 2
				"dd",
				{
					id = "jest-2",
					style = { -- ++depth === 3
						color = "#99424F",
					} :: any,
				},
				React.createElement("em", nil, "painless"), -- ++depth === 3
				" JavaScript testing"
			),
		}
		local expected = Array.join({
			"Table {",
			"  <dd",
			'    id="jest-1"',
			"  >",
			"    to talk in a ",
			"    <em \u{2026} />",
			"     manner",
			"  </dd>,",
			"  <dd",
			'    id="jest-2"',
			"    style={[Table]}",
			"  >",
			"    <em \u{2026} />",
			"     JavaScript testing",
			"  </dd>,",
			"}",
		}, "\n")
		jestExpect(formatElement(array, { maxDepth = maxDepth })).toEqual(expected)
		jestExpect(formatTestObject(
			Array.map(array, function(element)
				return renderer.create(element):toJSON()
			end), --[[ ROBLOX CHECK: check if 'array' is an Array ]]
			{ maxDepth = maxDepth }
		)).toEqual(expected)
	end)
end)

it("min option", function()
	assertPrintedJSX(
		React.createElement(
			"Mouse",
			{ customProp = { one = "1", two = 2 }, onclick = function(self) end },
			"HELLO",
			React.createElement(
				"Mouse",
				{ customProp = { one = "1", two = 2 }, onclick = function(self) end },
				"HELLO",
				React.createElement("Mouse"),
				"CIAO"
			),
			"CIAO"
		),
		'<Mouse customProp={{"one": "1", "two": 2}} onclick={[Function onclick]}>HELLO<Mouse customProp={{"one": "1", "two": 2}} onclick={[Function onclick]}>HELLO<Mouse />CIAO</Mouse>CIAO</Mouse>',
		{ min = true }
	)
end)

-- ROBLOX deviation: hightlights not supported
itSKIP("ReactElement plugin highlights syntax", function()
	local jsx = React.createElement(
		"Mouse",
		{ prop = React.createElement("div", nil, "mouse", React.createElement("span", nil, "rat")) }
	)
	jestExpect(formatElement(jsx, { highlight = true })).toMatchSnapshot()
end)

-- ROBLOX deviation: hightlights not supported
itSKIP("ReactTestComponent plugin highlights syntax", function()
	local jsx = React.createElement(
		"Mouse",
		{ prop = React.createElement("div", nil, "mouse", React.createElement("span", nil, "rat")) }
	)
	jestExpect(formatTestObject(renderer.create(jsx):toJSON(), { highlight = true })).toMatchSnapshot()
end)

-- ROBLOX deviation: theme not supported
itSKIP("throws if theme option is null", function()
	local jsx = React.createElement("Mouse", { style = "color:red" }, "Hello, Mouse!")
	jestExpect(function()
		-- @ts-expect-error
		formatElement(jsx, { highlight = true, theme = nil })
	end).toThrow('pretty-format: Option "theme" must not be null.')
end)

-- ROBLOX deviation: theme not supported
itSKIP('throws if theme option is not of type "object"', function()
	-- jestExpect(function()
	-- 	local jsx = React.createElement("Mouse", { style = "color:red" }, "Hello, Mouse!") -- @ts-expect-error
	-- 	formatElement(jsx, { highlight = true, theme = "beautiful" })
	-- end).toThrow('pretty-format: Option "theme" must be of type "object" but instead received "string".')
end)

-- ROBLOX deviation: theme not supported
itSKIP("throws if theme option has value that is undefined in ansi-styles", function()
	jestExpect(function()
		local jsx = React.createElement("Mouse", { style = "color:red" }, "Hello, Mouse!")
		formatElement(jsx, {
			highlight = true,
			theme = { content = "unknown", prop = "yellow", tag = "cyan", value = "green" },
		})
	end).toThrow(
		'pretty-format: Option "theme" has a key "content" whose value "unknown" is undefined in ansi-styles.'
	)
end)

-- ROBLOX deviation: hightlights not supported
itSKIP("ReactElement plugin highlights syntax with color from theme option", function()
	local jsx = React.createElement("Mouse", { style = "color:red" }, "Hello, Mouse!")
	jestExpect(formatElement(jsx, { highlight = true, theme = { value = "red" } })).toMatchSnapshot()
end)

-- ROBLOX deviation: hightlights not supported
itSKIP("ReactTestComponent plugin highlights syntax with color from theme option", function()
	local jsx = React.createElement("Mouse", { style = "color:red" }, "Hello, Mouse!")
	jestExpect(formatTestObject(renderer.create(jsx):toJSON(), { highlight = true, theme = { value = "red" } })).toMatchSnapshot()
end)

it("supports forwardRef with a child", function()
	local function Cat(props: any, _ref: any)
		return React.createElement("div", props, props.children)
	end
	jestExpect(formatElement(React.createElement(React.forwardRef(Cat), nil, "mouse"))).toEqual(
		"<ForwardRef(Cat)>\n  mouse\n</ForwardRef(Cat)>"
	)
end)

describe("React.memo", function()
	describe("without displayName", function()
		it("renders the component name", function()
			local function Dog(props: any)
				return React.createElement("div", props, props.children)
			end
			jestExpect(formatElement(React.createElement(React.memo(Dog), nil, "cat"))).toEqual(
				"<Memo(Dog)>\n  cat\n</Memo(Dog)>"
			)
		end)
	end)

	describe("with displayName", function()
		it("renders the displayName of component before memoizing", function()
			local Foo = setmetatable({}, {
				__call = function()
					return React.createElement("div")
				end,
			})
			Foo.displayName = "DisplayNameBeforeMemoizing(Foo)"
			-- ROBLOX FIXME roact-alignment: React.memo doesn't accept callable table: https://github.com/Roblox/roact-alignment/issues/283
			local MemoFoo = React.memo((Foo :: any) :: (_props: unknown, _ref: unknown) -> ReactElement | nil)
			jestExpect(formatElement(React.createElement(MemoFoo, nil, "cat"))).toEqual(
				"<Memo(DisplayNameBeforeMemoizing(Foo))>\n  cat\n</Memo(DisplayNameBeforeMemoizing(Foo))>"
			)
		end)

		it("renders the displayName of memoized component", function()
			local Foo = setmetatable({}, {
				__call = function()
					return React.createElement("div")
				end,
			})
			Foo.displayName = "DisplayNameThatWillBeIgnored(Foo)"
			-- ROBLOX FIXME roact-alignment: React.memo doesn't accept callable table: https://github.com/Roblox/roact-alignment/issues/283
			local MemoFoo = React.memo((Foo :: any) :: (_props: unknown, _ref: unknown) -> ReactElement | nil);
			-- ROBLOX FIXME: React.memo doesn't seem to return proper type
			(MemoFoo :: any).displayName = "DisplayNameForMemoized(Foo)"
			jestExpect(formatElement(React.createElement(MemoFoo, nil, "cat"))).toEqual(
				"<Memo(DisplayNameForMemoized(Foo))>\n  cat\n</Memo(DisplayNameForMemoized(Foo))>"
			)
		end)
	end)
end)

it("supports context Provider with a child", function()
	local Provider = React.createContext("test").Provider
	jestExpect(formatElement(React.createElement(Provider, { value = "test-value" }, "child"))).toEqual(
		'<Context.Provider\n  value="test-value"\n>\n  child\n</Context.Provider>'
	)
end)

it("supports context Consumer with a child", function()
	local Consumer = React.createContext("test").Consumer
	jestExpect(formatElement(React.createElement(Consumer, nil, function()
		return React.createElement("div", nil, "child")
	end))).toEqual("<Context.Consumer>\n  [Function anonymous]\n</Context.Consumer>")
end)

it("ReactElement removes undefined props", function()
	assertPrintedJSX(React.createElement("Mouse", { abc = nil, xyz = true }), "<Mouse\n  xyz={true}\n/>")
end)

-- ROBLOX deviation: theme not supported
itSKIP("ReactTestComponent removes undefined props", function()
	local jsx = React.createElement("Mouse", { abc = nil, xyz = true })
	jestExpect(formatElement(jsx, { highlight = true, theme = { value = "red" } })).toMatchSnapshot()
end)

-- ROBLOX deviation START: tests not present upstream
it("supports props when key is a table with name property", function()
	assertPrintedJSX(
		React.createElement("MyComponent", { [{ name = "TableKey" }] = "foo" }),
		'<MyComponent\n  TableKey="foo"\n/>'
	)
end)

it("supports props when key is a table without name property", function()
	assertPrintedJSX(
		React.createElement("MyComponent", { [{ otherKey = "TableKey" }] = "foo" }),
		'<MyComponent\n  Table {\n      "otherKey": "TableKey",\n    }="foo"\n/>'
	)
end)
-- ROBLOX deviation END

return {}
