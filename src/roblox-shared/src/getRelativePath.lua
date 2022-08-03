-- ROBLOX NOTE: no upstream

local function getRelativePath(script_: Instance, rootDir: Instance?): string
	local path = script_.Name

	local curr: Instance = script_
	while curr.Parent and curr ~= rootDir do
		curr = curr.Parent
		path = curr.Name .. "/" .. path
	end

	return if rootDir ~= nil then path else "/" .. path
end

return getRelativePath
