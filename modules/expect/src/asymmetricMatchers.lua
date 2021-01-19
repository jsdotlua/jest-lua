--!nonstrict
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/asymmetricMatchers.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Workspace = script.Parent
local Packages = Workspace.Parent.Parent.Packages

local Polyfill = require(Packages.LuauPolyfill)
local Array = Polyfill.Array
local Symbol = Polyfill.Symbol

local getType = require(Workspace.Parent.JestGetType).getType

local JasmineUtils = require(Workspace.jasmineUtils)
local equals = JasmineUtils.equals
local hasProperty = JasmineUtils.hasProperty
local isA = JasmineUtils.isA
local isUndefined = JasmineUtils.isUndefined

local emptyObject = require(Workspace.utils).emptyObject

local AsymmetricMatcher = {}
AsymmetricMatcher.__index = AsymmetricMatcher
function AsymmetricMatcher.new(sample: any)
	local self = {
		sample = sample,
		["$$typeof"] = Symbol.for_("jest.asymmetricMatcher"),
	}
	setmetatable(self, AsymmetricMatcher)
	return self
end

-- deviation: our implementation of any has significant deviations, check README for more info
-- > any("number"):asymmetricMatch(1) -- true
-- > any("number"):toAsymmetricMatcher() -- "Any<number>"
-- > any(ClassA):asymmetricMatch(ClassA.new()) -- true
-- > any(ClassA):asymmetricMatch(ClassB.new()) -- false
-- > any(ClassA):asymmetricMatch(DerivedClassA.new()) -- true
local Any = {}
Any.__index = Any
setmetatable(Any, AsymmetricMatcher)
function Any.new(sample: any)
	if typeof(sample) ~= "table" and typeof(sample) ~= "string" then
		error(
			"any() expects to be passed a typename string or a prototype class. " ..
			"Please pass one or use anything() to match any object."
		)
	end
	local self = AsymmetricMatcher.new(sample)
	setmetatable(self, Any)
	return self
end

function Any:asymmetricMatch(other: any): boolean
	-- deviation: simplified since this covers all the cases in Lua
	local selfType = getType(self.sample)
	local otherType = getType(other)
	-- compare metatable to check instance of Lua prototypical class
	if 
		selfType == "table" and
		otherType == "table"
	then
		local mt = getmetatable(other)
		while mt ~= nil do
			if self.sample == mt then
				return true
			end
			mt = getmetatable(mt)
		end
		return false
	-- check type matches type provided by string
	elseif
		selfType == "string" and
		self.sample == otherType
	then
		return true
	end
	return false
end

function Any:toString(): string
	return "Any"
end

function Any:getExpectedType(): string
	-- deviation: simplified since this already covers all the cases in Lua
	return tostring(self.sample)
end

function Any:toAsymmetricMatcher(): string
	return "Any<" .. tostring(self.sample) .. ">"
end

local Anything = {}
Anything.__index = Anything
setmetatable(Anything, AsymmetricMatcher)
function Anything.new(sample: any)
	local self = AsymmetricMatcher.new(sample)
	setmetatable(self, Anything)
	return self
end

function Anything:asymmetricMatch(other: any): boolean
	-- deviation: other !== null is redundant since Lua doesn't distinguish undefined/nil
	return not isUndefined(other)
end

function Anything:toString(): string
	return "Anything"
end

-- // No getExpectedType method, because it matches either null or undefined.

function Anything:toAsymmetricMatcher(): string
	return "Anything"
end

local ArrayContaining = {}
ArrayContaining.__index = ArrayContaining
setmetatable(ArrayContaining, AsymmetricMatcher)
function ArrayContaining.new(sample: { any }, inverse: boolean?)
	local self = AsymmetricMatcher.new(sample)
	self.inverse = inverse or false
	setmetatable(self, ArrayContaining)
	return self
end

function ArrayContaining:asymmetricMatch(other: { any })
	if not Array.isArray(self.sample) then
		error(string.format(
			"You must provide an array to %s, not '%s'.",
			self:toString(),
			typeof(self.sample))
		)
	end

	local result = false
	if #self.sample == 0 then
		result = true
	elseif Array.isArray(other) and
		Array.every(self.sample,
			function(item)
				return Array.some(
					other,
					function(another)
						return equals(item, another)
					end
				)
			end
		)
	then
		result = true
	end

	if self.inverse then
		return not result
	end
	return result
end

function ArrayContaining:toString(): string
	if self.inverse then
		return "ArrayNotContaining"
	end
	return "ArrayContaining"
end

function ArrayContaining:getExpectedType(): string
	return "array"
end

local ObjectContaining = {}
ObjectContaining.__index = ObjectContaining
setmetatable(ObjectContaining, AsymmetricMatcher)
function ObjectContaining.new(sample: { any }, inverse: boolean?)
	local self = AsymmetricMatcher.new(sample)
	self.inverse = inverse or false
	setmetatable(self, ObjectContaining)
	return self
end

function ObjectContaining:asymmetricMatch(other: { any })
	-- deviation: check for type table instead of object
	if typeof(self.sample) ~= "table" then
		error(string.format(
			"You must provide an object to %s, not '%s'.",
			self:toString(),
			typeof(self.sample))
		)
	end

	if self.inverse then
		for property, value in pairs(self.sample) do
			if hasProperty(other, property) and
				equals(value, other[property]) and
				not emptyObject(value) and
				not emptyObject(other[property])
			then
				return false
			end
		end

		return true
	else
		for property, value in pairs(self.sample) do
			if not hasProperty(other, property) or
				not equals(value, other[property])
			then
				return false
			end
		end

		return true
	end
end

function ObjectContaining:toString(): string
	if self.inverse then
		return "ObjectNotContaining"
	end
	return "ObjectContaining"
end

function ObjectContaining:getExpectedType(): string
	return "object"
end

-- deviation: stringContaining shouldn't accept string patterns so we escape special characters
local function escape(s: string): string
	return s:gsub(
		"([%$%%%^%*%(%)%.%[%]%+%-%?])",
		"%%%1"
	)
end

local StringContaining = {}
StringContaining.__index = StringContaining
setmetatable(StringContaining, AsymmetricMatcher)
function StringContaining.new(sample: string, inverse: boolean?)
	if not isA("string", sample) then
		error("Expected is not a String")
	end
	sample = escape(sample)
	local self = AsymmetricMatcher.new(sample)
	self.inverse = inverse or false
	setmetatable(self, StringContaining)
	return self
end

function StringContaining:asymmetricMatch(other: string): boolean
	local result = isA('string', other) and other:find(self.sample)

	if self.inverse then
		return not result
	end
	return not not result
end

function StringContaining:toString(): string
	if self.inverse then
		return "StringNotContaining"
	end
	return "StringContaining"
end

function StringContaining:getExpectedType(): string
	return "string"
end

local StringMatching = {}
StringMatching.__index = StringMatching
setmetatable(StringMatching, AsymmetricMatcher)
function StringMatching.new(sample: string, inverse: boolean?)
	-- deviation: no RegExp type, so we accept matches against a Lua string pattern instead
	if not isA("string", sample) then
		error("Expected is not a String")
	end
	local self = AsymmetricMatcher.new(sample)
	self.inverse = inverse or false
	setmetatable(self, StringMatching)
	return self
end

function StringMatching:asymmetricMatch(other: string): boolean
	local result = isA('string', other) and other:find(self.sample)

	if self.inverse then
		return not result
	end
	return not not result
end

function StringMatching:toString(): string
	if self.inverse then
		return "StringNotMatching"
	end
	return "StringMatching"
end

function StringMatching:getExpectedType(): string
	return "string"
end

return {
	any = function(expectedObject: any) return Any.new(expectedObject) end,
	anything = function() return Anything.new() end,
	arrayContaining = function(sample: { any }) return ArrayContaining.new(sample) end,
	arrayNotContaining = function(sample: { any }) return ArrayContaining.new(sample, true) end,
	objectContaining = function(sample: any) return ObjectContaining.new(sample) end,
	objectNotContaining = function(sample: any) return ObjectContaining.new(sample, true) end,
	stringContaining = function(expected: string) return StringContaining.new(expected) end,
	stringNotContaining = function(expected: string) return StringContaining.new(expected, true) end,
	stringMatching = function(expected: string) return StringMatching.new(expected) end,
	stringNotMatching = function(expected: string) return StringMatching.new(expected, true) end,
}