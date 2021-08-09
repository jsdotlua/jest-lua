local exports = {}

exports["native lua errors 1"] = [=[
"LoadedCode.JestRoblox.Root.src.Submodules.JestSnapshot.__tests__.snapshot.roblox.spec:21: oops"]=]

exports["custom snapshot matchers: toMatchTrimmedSnapshot 1"] = [=[
"extra long"]=]

exports["tests snapshots with asymmetric matchers 1"] = [=[

Table {
  "createdAt": Any<DateTime>,
  "id": Any<number>,
  "name": "LeBron James",
}
]=]

exports["tests snapshots with asymmetric matchers and a subset of properties 1"] = [=[

Table {
  "createdAt": Any<DateTime>,
  "id": Any<number>,
  "name": "LeBron James",
}
]=]

return exports