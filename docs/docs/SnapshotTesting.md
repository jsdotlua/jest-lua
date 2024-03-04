---
id: snapshot-testing
title: Snapshot Testing
---
<p><a href='https://jestjs.io/docs/27.x/snapshot-testing' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a></p>

Snapshot tests are a very useful tool whenever you want to make sure your UI does not change unexpectedly.

A typical snapshot test case renders a UI component, takes a snapshot, then compares it to a reference snapshot file stored alongside the test. The test will fail if the two snapshots do not match: either the change is unexpected, or the reference snapshot needs to be updated to the new version of the UI component.

## Snapshot Testing with Jest

Consider this test:
```lua
it('table', function()
	expect({
		a = 1,
		b = "test",
		c = { "array", "of", "strings" }
	}).toMatchSnapshot()
end)
```

The first time this test is run, Jest creates a snapshot file that looks like this:
```lua
exports[ [=[describe table 1]=] ] = [=[

Table {
  "a": 1,
  "b": "test",
  "c": Table {
	"array",
	"of",
	"strings",
  },
}
]=]
```

The snapshot artifact should be committed alongside code changes, and reviewed as part of your code review process. Jest Lua uses [pretty-format](https://github.com/Roblox/jest-roblox/tree/master/src/pretty-format) to make snapshots human-readable during code review. On subsequent test runs, Jest Lua will compare the rendered output with the previous snapshot. If they match, the test will pass. If they don't match, either the test runner found a bug in your code that should be fixed, or the implementation has changed and the snapshot needs to be updated.

### Updating Snapshots
<img alt='deviation' src='img/deviation.svg'/>

It's straightforward to spot when a snapshot test fails after a bug has been introduced. When that happens, go ahead and fix the issue and make sure your snapshot tests are passing again. Now, let's talk about the case when a snapshot test is failing due to an intentional implementation change.

One such situation can arise if we intentionally change the values in our example.
```lua
it("table", function()
	expect({
		a = 2,
		b = "test",
		c = { "array", "of", "strings" }
	}).toMatchSnapshot()
end)
```

In that case, Jest Lua will print this output:
```
Snapshot name: `describe table 1`

- Snapshot  - 1
+ Received  + 1

@@ -1,7 +1,7 @@
  Table {
-   "a": 1,
+   "a": 2,
	"b": "test",
	"c": Table {
	  "array",
	  "of",
	  "strings",
```

Since we just updated our component, it's reasonable to expect changes in the snapshot for this component. Our snapshot test case is failing because the snapshot for our updated component no longer matches the snapshot artifact for this test case.

To resolve this, we will need to update our snapshot artifacts. You can call `runCLI` with an option that will tell it to re-generate snapshots:

```lua
runCLI(Project, {
	updateSnapshot = "true"
}, { Project }):awaitStatus()
```

You'll also need to pass the following flags to give `roblox-cli` the proper permissions to update snapshots:

```
--load.asRobloxScript --fs.readwrite="$(pwd)" 
```

:::tip
You can pass in configuration options into Jest Lua by setting Lua globals in `roblox-cli`.

```lua
runCLI(Project, {
	updateSnapshot = _G.UPDATESNAPSHOT == "true"
}, { Project }):awaitStatus()
```

Add the `--lua.globals` flag into `roblox-cli`.
```bash
--lua.globals=UPDATESNAPSHOT=true
```
:::

This will re-generate snapshot artifacts for all failing snapshot tests. If we had any additional failing snapshot tests due to an unintentional bug, we would need to fix the bug before re-generating snapshots to avoid recording snapshots of the buggy behavior.

If you'd like to limit which snapshot test cases get re-generated, you can pass an additional `testNamePattern` flag to re-record snapshots only for those tests that match the pattern.

### Property Matchers

Often there are fields in the object you want to snapshot which are generated (like IDs and DateTimes). If you try to snapshot these objects, they will force the snapshot to fail on every run:

```lua
it('will fail every time', function()
	local user = {
		createdAt = DateTime.now(),
		id = math.floor(math.random() * 20),
		name = "LeBron James"
	}

	expect(user).toMatchSnapshot()
end)

-- Snapshot
exports[ [=[will fail every time 1]=] ] = [=[

Table {
  "createdAt": 2021-07-28T22:04:02.166Z,
  "id": 14,
  "name": "LeBron James",
}
]=]
```

For these cases, Jest Lua allows providing an asymmetric matcher for any property. These matchers are checked before the snapshot is written or tested, and then saved to the snapshot file instead of the received value:

```lua
it("will check the matchers and pass", function()
	local user = {
		createdAt = DateTime.now(),
		id = math.floor(math.random() * 20),
		name = "LeBron James"
	}

	expect(user).toMatchSnapshot({
		createdAt = expect.any("DateTime"),
		id = expect.any("number"),
		name = expect.any("string")
	})
end)

-- Snapshot
exports[ [=[will check the matchers and pass 1]=] ] = [=[

Table {
  "createdAt": Any<DateTime>,
  "id": Any<number>,
  "name": Any<string>,
}
]=]
```

Any given value that is not a matcher will be checked exactly and saved to the snapshot:

```lua
it("will check the values and pass", function()
	local user = {
		createdAt = DateTime.now(),
		name = "Bond... James Bond"
	}

	expect(user).toMatchSnapshot({
		createdAt = expect.any("DateTime"),
		name = "Bond... James Bond"
	})
end)

-- Snapshot
exports[ [=[will check the values and pass 1]=] ] = [=[

Table {
  "createdAt": Any<DateTime>,
  "name": "Bond... James Bond",
}
]=]
```

## Best Practices

Snapshots are a fantastic tool for identifying unexpected interface changes within your application – whether that interface is an API response, UI, logs, or error messages. As with any testing strategy, there are some best-practices you should be aware of, and guidelines you should follow, in order to use them effectively.

### 1. Treat snapshots as code

Commit snapshots and review them as part of your regular code review process. This means treating snapshots as you would any other type of test or code in your project.

Ensure that your snapshots are readable by keeping them focused, short, and by using tools that enforce these stylistic conventions.

The goal is to make it easy to review snapshots in pull requests, and fight against the habit of regenerating snapshots when test suites fail instead of examining the root causes of their failure.

### 2. Tests should be deterministic

Your tests should be deterministic. Running the same tests multiple times on a component that has not changed should produce the same results every time. You're responsible for making sure your generated snapshots do not include platform specific or other non-deterministic data.

For example, you can use property matchers or mocking to ensure that the snapshot test is deterministic regardless of when the test is run.

### 3. Use descriptive snapshot names

Always strive to use descriptive test and/or snapshot names for snapshots. The best names describe the expected snapshot content. This makes it easier for reviewers to verify the snapshots during review, and for anyone to know whether or not an outdated snapshot is the correct behavior before updating.

For example, compare:

```lua
exports[ [=[test case 1]=] ] = [=[
nil]=]

exports[ [=[some other test case 1]=] ] = [=[
"Alan Turing"]=]
```

To:

```lua
exports[ [=[should be nil 1]=] ] = [=[
nil]=]

exports[ [=[should be Alan Turing 1]=] ] = [=[
"Alan Turing"]=]
```

Since the later describes exactly what's expected in the output, it's more clear to see when it's wrong:

```lua
exports[ [=[should be nil 1]=] ] = [=[
"Alan Turing"]=]

exports[ [=[should be Alan Turing 1]=] ] = [=[
nil]=]
```

## Frequently Asked Questions

### Are snapshots written automatically on Continuous Integration (CI) systems?

No, snapshots in Jest Lua are not automatically written when Jest Lua is run in a CI system without explicitly passing `UPDATESNAPSHOT`. It is expected that all snapshots are part of the code that is run on CI and since new snapshots automatically pass, they should not pass a test run on a CI system. It is recommended to always commit all snapshots and to keep them in version control.

### Should snapshot files be committed?

Yes, all snapshot files should be committed alongside the modules they are covering and their tests. They should be considered part of a test, similar to the value of any other assertion in Jest Lua. In fact, snapshots represent the state of the source modules at any given point in time. In this way, when the source modules are modified, Jest Lua can tell what changed from the previous version. It can also provide a lot of additional context during code review in which reviewers can study your changes better.

### Does snapshot testing replace unit testing?

Snapshot testing is only one of more than 20 assertions that ship with Jest Lua. The aim of snapshot testing is not to replace existing unit tests, but to provide additional value and make testing painless. In some scenarios, snapshot testing can potentially remove the need for unit testing for a particular set of functionalities (e.g. React components), but they can work together as well.

### How do I resolve conflicts within snapshot files?

Snapshot files must always represent the current state of the modules they are covering. Therefore, if you are merging two branches and encounter a conflict in the snapshot files, you can either resolve the conflict manually or update the snapshot file by running Jest Lua and inspecting the result.

### Is it possible to apply test-driven development principles with snapshot testing?

Although it is possible to write snapshot files manually, that is usually not approachable. Snapshots help to figure out whether the output of the modules covered by tests is changed, rather than giving guidance to design the code in the first place.

### Does code coverage work with snapshot testing?

Yes, as well as with any other test.