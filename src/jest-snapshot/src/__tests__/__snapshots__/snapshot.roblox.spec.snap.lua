-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local exports = {}

exports[ [=[custom snapshot matchers: toMatchTrimmedSnapshot 1]=] ] = [=[
"extra long"]=]

exports[ [=[native lua errors 1]=] ] = [=[
"LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec:33: oops"]=]

exports[ [=[test with newlines
in the name
and body 1]=] ] = [=[

"a
b"
]=]

exports[ [=[tests snapshots with asymmetric matchers 1]=] ] = [=[

Table {
  "createdAt": Any<DateTime>,
  "id": Any<number>,
  "name": "LeBron James",
}
]=]

exports[ [=[tests snapshots with asymmetric matchers and a subset of properties 1]=] ] = [=[

Table {
  "createdAt": Any<DateTime>,
  "id": Any<number>,
  "name": "LeBron James",
}
]=]

return exports
