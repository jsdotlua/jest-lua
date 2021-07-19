--!nocheck
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/__tests__/dedentLines.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Modules = CurrentModule.Parent
	local Packages = Modules.Parent.Parent

	local Polyfill = require(Packages.LuauPolyfill)
	local Symbol = Polyfill.Symbol

	local jestExpect = require(Modules.Expect)

	local PrettyFormat = require(Modules.PrettyFormat)
	local format = PrettyFormat.prettyFormat
	local dedentLines = require(CurrentModule.dedentLines)

	local typeof_ = Symbol.for_('react.test.json')
	local plugins = { PrettyFormat.plugins.ReactTestComponent }

	local function formatLines2(val)
		return format(val, {indent = 2, plugins = plugins}):split('\n')
	end
	local function formatLines0(val)
		return format(val, {indent = 0, plugins = plugins}):split('\n')
	end

	describe('dedentLines non-null', function()
		it('no lines', function()
			local indented = {}
			local dedented = indented

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		it('one line empty string', function()
			local indented = {''}
			local dedented = indented

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		it('one line empty object', function()
			local val = {}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('one line self-closing element', function()
			local val = {
				["$$typeof"] = typeof_,
				children = nil,
				type = 'br',
			}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		it('object value empty string', function()
			local val = {
				key = '',
			}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		it('object value string includes double-quote marks', function()
			local val = {
				key = '"Always bet on JavaScript",',
			}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup with props and text', function()
			local val = {
				["$$typeof"] = typeof_,
				children = {
					{
						["$$typeof"] = typeof_,
						props = {
							alt = 'Jest logo',
							src = 'jest.svg',
						},
						type = 'img',
					},
					{
						["$$typeof"] = typeof_,
						children = {'Delightful JavaScript testing'},
						type = 'h2',
					},
				},
				type = 'header',
			}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup with components as props', function()
			-- // https://daveceddia.com/pluggable-slots-in-react-components/
			local val = {
				["$$typeof"] = typeof_,
				children = nil,
				props = {
					content = {
						["$$typeof"] = typeof_,
						children = {'main content here'},
						type = 'Content',
					},
					sidebar = {
						["$$typeof"] = typeof_,
						children = nil,
						props = {
							user = '0123456789abcdef',
						},
						type = 'UserStats',
					},
				},
				type = 'Body',
			}
			local indented = formatLines2(val)
			local dedented = formatLines0(val)

			jestExpect(dedentLines(indented)).toEqual(dedented)
		end)
	end)

	describe('dedentLines null', function()
		for key, value in pairs({
			{'object key multi-line', {['multi\nline\nkey'] = false}},
			{'object value multi-line', {key = 'multi\nline\nvalue'}},
			{'object key and value multi-line', {['multi\nline'] = '\nleading nl'}},
		}) do
			local name = value[1]
			local val = value[2]
			it(string.format('%s', name), function()
				jestExpect(dedentLines(formatLines2(val))).toEqual(nil)
			end)
		end

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup prop multi-line', function()
			local val = {
				["$$typeof"] = typeof_,
				children = nil,
				props = {
					alt = 'trailing newline\n',
					src = 'jest.svg',
				},
				type = 'img',
			}
			local indented = formatLines2(val)

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup prop component with multi-line text', function()
		-- // https://daveceddia.com/pluggable-slots-in-react-components/
			local val = {
				["$$typeof"] = typeof_,
				children = {
					{
						["$$typeof"] = typeof_,
						children = nil,
						props = {
							content = {
								["$$typeof"] = typeof_,
								children = {'\n'},
								type = 'Content',
							},
							sidebar = {
								["$$typeof"] = typeof_,
								children = nil,
								props = {
									user = '0123456789abcdef',
								},
								type = 'UserStats',
							},
						},
						type = 'Body',
					},
				},
				type = 'main',
			}
			local indented = formatLines2(val)

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup text multi-line', function()
			local text = table.concat({
				'for (key in foo) {',
				'  if (Object.prototype.hasOwnProperty.call(foo, key)) {',
				'    doSomething(key);',
				'  }',
				'}',
			}, '\n')
			local val = {
				["$$typeof"] = typeof_,
				children = {
					{
						["$$typeof"] = typeof_,
						children = {text = text},
						props = {
							className = 'language-js',
						},
						type = 'pre',
					},
				},
				type = 'div',
			}
			local indented = formatLines2(val)

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)

		-- deviation: test skipped because we don't have support for react elements
		itSKIP('markup text multiple lines', function()
			local lines = {
				'for (key in foo) {',
				'  if (Object.prototype.hasOwnProperty.call(foo, key)) {',
				'    doSomething(key);',
				'  }',
				'}',
			}
			local val = {
				["$$typeof"] = typeof_,
				children = {
					{
						["$$typeof"] = typeof_,
						children = lines,
						props = {
							className = 'language-js',
						},
						type = 'pre',
					},
				},
				type = 'div',
			}
			local indented = formatLines2(val)

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)

		it('markup unclosed self-closing start tag', function()
			local indented = {'<img', '  alt="Jest logo"', '  src="jest.svg"'}

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)

		it('markup unclosed because no end tag', function()
			local indented = {'<p>', '  Delightful JavaScript testing'}

			jestExpect(dedentLines(indented)).toEqual(nil)
		end)
	end)
end