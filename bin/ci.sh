rojo build lest.project.json --output model.rbxmx
roblox-cli analyze lest.project.json
roblox-cli run --load.model model.rbxmx --run bin/spec.lua
