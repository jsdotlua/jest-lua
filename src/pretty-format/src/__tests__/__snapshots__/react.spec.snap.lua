-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/pretty-format/src/__tests__/__snapshots__/react.test.tsx.snap

-- Jest Snapshot v1, https://goo.gl/fbAQLP
local exports = {}

exports["ReactElement plugin highlights syntax 1"] = [[

"<cyan><Mouse</>
  <yellow>prop</>=<green>{
    <cyan><div></>
      </>mouse</>
      <cyan><span></>
        </>rat</>
      <cyan></span></>
    <cyan></div></>
  }</>
<cyan>/></>"
]]
exports["ReactElement plugin highlights syntax with color from theme option 1"] = [[

"<cyan><Mouse</>
  <yellow>style</>=<red>\"color:red\"</>
<cyan>></>
  </>Hello, Mouse!</>
<cyan></Mouse></>"
]]
exports["ReactTestComponent plugin highlights syntax 1"] = [[

"<cyan><Mouse</>
  <yellow>prop</>=<green>{
    <cyan><div></>
      </>mouse</>
      <cyan><span></>
        </>rat</>
      <cyan></span></>
    <cyan></div></>
  }</>
<cyan>/></>"
]]
exports["ReactTestComponent plugin highlights syntax with color from theme option 1"] = [[

"<cyan><Mouse</>
  <yellow>style</>=<red>\"color:red\"</>
<cyan>></>
  </>Hello, Mouse!</>
<cyan></Mouse></>"
]]
exports["ReactTestComponent removes undefined props 1"] = [[

"<cyan><Mouse</>
  <yellow>xyz</>=<red>{true}</>
<cyan>/></>"
]]

return exports
