-- ROBLOX NOTE: no upstream

local WriteableModule = require(script.Parent.Writeable)
local Writeable = WriteableModule.Writeable
type Writeable = WriteableModule.Writeable
local process = {
	stdout = Writeable.new(),
	stderr = Writeable.new(),
}
local function exit(code: number)
	error(("Exited with code: %d"):format(code))
end
export type NodeJS_WriteStream = Writeable

local HttpService = game:GetService("HttpService")
local JSON = {
	stringify = function(obj: any, ...): string
		if select("#", ...) > 0 then
			warn(
				"JSON.stringify doesn't currently support more than 1 argument. All additional arguments will be ignored."
			)
		end
		return HttpService:JSONEncode(obj)
	end,
	parse = function(str: string, ...): any
		if select("#", ...) > 0 then
			warn("JSON.parse doesn't currently support more than 1 argument. All additional arguments will be ignored.")
		end
		return HttpService:JSONDecode(str)
	end,
}

return {
	process = process,
	exit = exit,
	JSON = JSON,
}
