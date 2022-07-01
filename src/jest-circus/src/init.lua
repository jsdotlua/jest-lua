local circusModule = require(script.circus)

local exports = circusModule

export type Event = circusModule.Event
export type State = circusModule.State

-- ROBLOX deviation: exporting runner alongside the main entry point
local runner = require(script.runner);
(exports :: any).runner = runner

return exports :: typeof(circusModule) & { runner: typeof(runner) }
