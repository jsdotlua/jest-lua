-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[getRobloxDefaults() returns default properties and values for Camera 1]=] ] = [=[

Table {
  "Archivable": true,
  "CFrame": CFrame(0, 20, 20, 1, 0, -0, -0, 0.707106829, 0.707106829, 0, -0.707106829, 0.707106829),
  "CameraType": EnumItem(Enum.CameraType.Fixed),
  "ClassName": "Camera",
  "DiagonalFieldOfView": 88.87651062011719,
  "FieldOfView": 70,
  "FieldOfViewMode": EnumItem(Enum.FieldOfViewMode.Vertical),
  "Focus": CFrame(0, 0, -5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
  "HeadLocked": true,
  "HeadScale": 1,
  "MaxAxisFieldOfView": 70,
  "Name": "Camera",
  "NearPlaneZ": -0.5,
  "ViewportSize": Vector2(1, 1),
}
]=]

exports[ [=[getRobloxDefaults() returns default properties and values for TextLabel 1]=] ] = [=[

Table {
  "AbsolutePosition": Vector2(0, 0),
  "AbsoluteRotation": 0,
  "AbsoluteSize": Vector2(0, 0),
  "Active": false,
  "AnchorPoint": Vector2(0, 0),
  "Archivable": true,
  "AutoLocalize": true,
  "AutomaticSize": EnumItem(Enum.AutomaticSize.None),
  "BackgroundColor3": Color3(0.639216, 0.635294, 0.647059),
  "BackgroundTransparency": 0,
  "BorderColor3": Color3(0.105882, 0.164706, 0.207843),
  "BorderMode": EnumItem(Enum.BorderMode.Outline),
  "BorderSizePixel": 1,
  "ClassName": "TextLabel",
  "ClipsDescendants": false,
  "ContentText": "Label",
  "Font": EnumItem(Enum.Font.Legacy),
  "LayoutOrder": 0,
  "LineHeight": 1,
  "MaxVisibleGraphemes": -1,
  "Name": "TextLabel",
  "Position": UDim2({0, 0}, {0, 0}),
  "RichText": false,
  "Rotation": 0,
  "Selectable": false,
  "Size": UDim2({0, 0}, {0, 0}),
  "SizeConstraint": EnumItem(Enum.SizeConstraint.RelativeXY),
  "Text": "Label",
  "TextBounds": Vector2(0, 0),
  "TextColor3": Color3(0.105882, 0.164706, 0.207843),
  "TextFits": false,
  "TextScaled": false,
  "TextSize": 8,
  "TextStrokeColor3": Color3(0, 0, 0),
  "TextStrokeTransparency": 1,
  "TextTransparency": 0,
  "TextTruncate": EnumItem(Enum.TextTruncate.None),
  "TextWrapped": false,
  "TextXAlignment": EnumItem(Enum.TextXAlignment.Center),
  "TextYAlignment": EnumItem(Enum.TextYAlignment.Center),
  "Visible": true,
  "ZIndex": 1,
}
]=]

return exports
