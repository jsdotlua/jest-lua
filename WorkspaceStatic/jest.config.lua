local Workspace = script.Parent

local projects = {}

for _, child in Workspace:GetChildren() do
	pcall(function()
		table.insert(projects, child[child.Name])
	end)
end

return {
	projects = projects,
}
