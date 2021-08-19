--!nocheck
return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(CurrentModule)

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Set = LuauPolyfill.Set

	local CustomClass = {}
	CustomClass.__index = CustomClass

	function CustomClass.new()
	    return setmetatable({ foo = true }, CustomClass)
	end

	-- test cases devised from https://github.com/Roblox/jest-roblox/pull/27#discussion_r561374828
	it("tests toStrictEqual matcher with example class", function()
		jestExpect(CustomClass.new()).never.toBe(CustomClass.new()) -- not the same table
		jestExpect(CustomClass.new()).toStrictEqual(CustomClass.new()) -- not the same table, but same shape and same class
		jestExpect(CustomClass.new()).never.toStrictEqual({ foo = true}) -- same shape but not same class
		jestExpect(CustomClass.new()).toEqual({ foo = true}) -- same shape
	end)

	-- test case taken from Jest docs
	local LaCroix = {}
	LaCroix.__index = LaCroix
	function LaCroix.new(flavor)
		return setmetatable({
			flavor = flavor
		}, LaCroix)
	end

	it('the La Croix cans on my desk are not semantically the same', function()
		jestExpect(LaCroix.new('lemon')).toEqual({flavor = 'lemon'})
		jestExpect(LaCroix.new('lemon')).never.toStrictEqual({flavor = 'lemon'})
	end)

	it("tests the set polyfill", function()
		jestExpect(Set.new({1, 2, 5})).toEqual(Set.new{2, 5, 1})
		jestExpect(Set.new({1, 2, 6})).never.toEqual(Set.new{1, 2, 5})
		jestExpect(Set.new({{1, 2}, {3, 4}})).toEqual(Set.new{{3, 4}, {1, 2}})
		jestExpect(Set.new({{1, 2}, {3, 4}})).never.toEqual(Set.new{{1, 2}, {3, 5}})
		jestExpect(Set.new({"a"})).toContain("a")
	end)
end