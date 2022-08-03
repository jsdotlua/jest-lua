local CurrentModule = script

local nodeUtilsModule = require(CurrentModule.nodeUtils)
export type NodeJS_WriteStream = nodeUtilsModule.NodeJS_WriteStream
local exports = {
	dedent = require(CurrentModule.dedent).dedent,
	expect = require(CurrentModule.expect),
	getRelativePath = require(CurrentModule.getRelativePath),
	RobloxInstance = require(CurrentModule.RobloxInstance),
	nodeUtils = nodeUtilsModule,
}

local WriteableModule = require(CurrentModule.Writeable)
exports.Writeable = WriteableModule.Writeable
export type Writeable = WriteableModule.Writeable

return exports
