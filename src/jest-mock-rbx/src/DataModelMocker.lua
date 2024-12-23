--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
--!strict
-- ROBLOX NOTE: no upstream

local InstanceProxy = require("./InstanceProxy")
type InstanceProxy<ClassType = Instance> = InstanceProxy.InstanceProxy<ClassType>

export type DataModelMocker = {
	mockInstance: <ClassType>(self: DataModelMocker, instance: ClassType & Instance) -> InstanceProxy<ClassType>,
}
type DataModelMocker_private = DataModelMocker & {
	_instanceProxies: { [Instance]: InstanceProxy },
}

local DataModelMocker = {}
DataModelMocker.__index = DataModelMocker

function DataModelMocker.mockInstance<ClassType>(
	self: DataModelMocker_private,
	instance: ClassType & Instance
): InstanceProxy<ClassType>
	local proxy = self._instanceProxies[instance]
	if proxy == nil then
		proxy = InstanceProxy.new(instance)
		-- This proxy is never removed from the table, and the strong reference
		-- is necessary so that the proxy is remembered even if the tested Luau
		-- code doesn't hold a reference for some time. This could cause a
		-- memory leak but this mocker is presumably destroyed at the end of the
		-- test suite, so this should be OK.
		self._instanceProxies[instance] = proxy
		--[[
			ROBLOX TODO: mock ancestry/descendants to preserve instance proxies
			created in a hierarchy, not important for GetService mocking
		]]
	end
	return proxy :: any
end

local exports = {}

function exports.new(): DataModelMocker
	local mocker: DataModelMocker_private = setmetatable({
		_instanceProxies = {},
	}, DataModelMocker) :: any
	return mocker
end

return exports
