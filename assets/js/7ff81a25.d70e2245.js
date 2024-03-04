"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[271],{9158:(e,t,s)=>{s.r(t),s.d(t,{assets:()=>h,contentTitle:()=>i,default:()=>d,frontMatter:()=>o,metadata:()=>r,toc:()=>l});var n=s(4848),a=s(8453);const o={id:"snapshot-testing",title:"Snapshot Testing"},i=void 0,r={id:"snapshot-testing",title:"Snapshot Testing",description:"Snapshot tests are a very useful tool whenever you want to make sure your UI does not change unexpectedly.",source:"@site/docs/SnapshotTesting.md",sourceDirName:".",slug:"/snapshot-testing",permalink:"/jest-lua/snapshot-testing",draft:!1,unlisted:!1,tags:[],version:"current",frontMatter:{id:"snapshot-testing",title:"Snapshot Testing"},sidebar:"docs",previous:{title:"Mock Functions",permalink:"/jest-lua/mock-functions"},next:{title:"Timer Mocks",permalink:"/jest-lua/timer-mocks"}},h={},l=[{value:"Snapshot Testing with Jest",id:"snapshot-testing-with-jest",level:2},{value:"Updating Snapshots",id:"updating-snapshots",level:3},{value:"Property Matchers",id:"property-matchers",level:3},{value:"Best Practices",id:"best-practices",level:2},{value:"1. Treat snapshots as code",id:"1-treat-snapshots-as-code",level:3},{value:"2. Tests should be deterministic",id:"2-tests-should-be-deterministic",level:3},{value:"3. Use descriptive snapshot names",id:"3-use-descriptive-snapshot-names",level:3},{value:"Frequently Asked Questions",id:"frequently-asked-questions",level:2},{value:"Are snapshots written automatically on Continuous Integration (CI) systems?",id:"are-snapshots-written-automatically-on-continuous-integration-ci-systems",level:3},{value:"Should snapshot files be committed?",id:"should-snapshot-files-be-committed",level:3},{value:"Does snapshot testing replace unit testing?",id:"does-snapshot-testing-replace-unit-testing",level:3},{value:"How do I resolve conflicts within snapshot files?",id:"how-do-i-resolve-conflicts-within-snapshot-files",level:3},{value:"Is it possible to apply test-driven development principles with snapshot testing?",id:"is-it-possible-to-apply-test-driven-development-principles-with-snapshot-testing",level:3},{value:"Does code coverage work with snapshot testing?",id:"does-code-coverage-work-with-snapshot-testing",level:3}];function c(e){const t={a:"a",admonition:"admonition",code:"code",h2:"h2",h3:"h3",p:"p",pre:"pre",...(0,a.R)(),...e.components};return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)("p",{children:(0,n.jsx)("a",{href:"https://jestjs.io/docs/27.x/snapshot-testing",target:"_blank",children:(0,n.jsx)("img",{alt:"Jest",src:"img/jestjs.svg"})})}),"\n",(0,n.jsx)(t.p,{children:"Snapshot tests are a very useful tool whenever you want to make sure your UI does not change unexpectedly."}),"\n",(0,n.jsx)(t.p,{children:"A typical snapshot test case renders a UI component, takes a snapshot, then compares it to a reference snapshot file stored alongside the test. The test will fail if the two snapshots do not match: either the change is unexpected, or the reference snapshot needs to be updated to the new version of the UI component."}),"\n",(0,n.jsx)(t.h2,{id:"snapshot-testing-with-jest",children:"Snapshot Testing with Jest"}),"\n",(0,n.jsx)(t.p,{children:"Consider this test:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'it(\'table\', function()\n\texpect({\n\t\ta = 1,\n\t\tb = "test",\n\t\tc = { "array", "of", "strings" }\n\t}).toMatchSnapshot()\nend)\n'})}),"\n",(0,n.jsx)(t.p,{children:"The first time this test is run, Jest creates a snapshot file that looks like this:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'exports[ [=[describe table 1]=] ] = [=[\n\nTable {\n  "a": 1,\n  "b": "test",\n  "c": Table {\n\t"array",\n\t"of",\n\t"strings",\n  },\n}\n]=]\n'})}),"\n",(0,n.jsxs)(t.p,{children:["The snapshot artifact should be committed alongside code changes, and reviewed as part of your code review process. Jest Lua uses ",(0,n.jsx)(t.a,{href:"https://github.com/Roblox/jest-roblox/tree/master/src/pretty-format",children:"pretty-format"})," to make snapshots human-readable during code review. On subsequent test runs, Jest Lua will compare the rendered output with the previous snapshot. If they match, the test will pass. If they don't match, either the test runner found a bug in your code that should be fixed, or the implementation has changed and the snapshot needs to be updated."]}),"\n",(0,n.jsx)(t.h3,{id:"updating-snapshots",children:"Updating Snapshots"}),"\n",(0,n.jsx)("img",{alt:"deviation",src:"img/deviation.svg"}),"\n",(0,n.jsx)(t.admonition,{type:"warning",children:(0,n.jsxs)(t.p,{children:["It is not currently possible to update snapshot tests. The functionality depends on file system write APIs provided by ",(0,n.jsx)(t.code,{children:"roblox-cli"}),", a tool only available to internal Roblox engineers. See issue ",(0,n.jsx)(t.a,{href:"https://github.com/jsdotlua/jest-lua/issues/4",children:"#4"})," for more."]})}),"\n",(0,n.jsx)(t.p,{children:"It's straightforward to spot when a snapshot test fails after a bug has been introduced. When that happens, go ahead and fix the issue and make sure your snapshot tests are passing again. Now, let's talk about the case when a snapshot test is failing due to an intentional implementation change."}),"\n",(0,n.jsx)(t.p,{children:"One such situation can arise if we intentionally change the values in our example."}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'it("table", function()\n\texpect({\n\t\ta = 2,\n\t\tb = "test",\n\t\tc = { "array", "of", "strings" }\n\t}).toMatchSnapshot()\nend)\n'})}),"\n",(0,n.jsx)(t.p,{children:"In that case, Jest Lua will print this output:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{children:'Snapshot name: `describe table 1`\n\n- Snapshot  - 1\n+ Received  + 1\n\n@@ -1,7 +1,7 @@\n  Table {\n-   "a": 1,\n+   "a": 2,\n\t"b": "test",\n\t"c": Table {\n\t  "array",\n\t  "of",\n\t  "strings",\n'})}),"\n",(0,n.jsx)(t.p,{children:"Since we just updated our component, it's reasonable to expect changes in the snapshot for this component. Our snapshot test case is failing because the snapshot for our updated component no longer matches the snapshot artifact for this test case."}),"\n",(0,n.jsxs)(t.p,{children:["To resolve this, we will need to update our snapshot artifacts. You can call ",(0,n.jsx)(t.code,{children:"runCLI"})," with an option that will tell it to re-generate snapshots:"]}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'runCLI(Project, {\n\tupdateSnapshot = "true"\n}, { Project }):awaitStatus()\n'})}),"\n",(0,n.jsxs)(t.p,{children:["You'll also need to pass the following flags to give ",(0,n.jsx)(t.code,{children:"roblox-cli"})," the proper permissions to update snapshots:"]}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{children:'--load.asRobloxScript --fs.readwrite="$(pwd)" \n'})}),"\n",(0,n.jsxs)(t.admonition,{type:"tip",children:[(0,n.jsxs)(t.p,{children:["You can pass in configuration options into Jest Lua by setting Lua globals in ",(0,n.jsx)(t.code,{children:"roblox-cli"}),"."]}),(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'runCLI(Project, {\n\tupdateSnapshot = _G.UPDATESNAPSHOT == "true"\n}, { Project }):awaitStatus()\n'})}),(0,n.jsxs)(t.p,{children:["Add the ",(0,n.jsx)(t.code,{children:"--lua.globals"})," flag into ",(0,n.jsx)(t.code,{children:"roblox-cli"}),"."]}),(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-bash",children:"--lua.globals=UPDATESNAPSHOT=true\n"})})]}),"\n",(0,n.jsx)(t.p,{children:"This will re-generate snapshot artifacts for all failing snapshot tests. If we had any additional failing snapshot tests due to an unintentional bug, we would need to fix the bug before re-generating snapshots to avoid recording snapshots of the buggy behavior."}),"\n",(0,n.jsxs)(t.p,{children:["If you'd like to limit which snapshot test cases get re-generated, you can pass an additional ",(0,n.jsx)(t.code,{children:"testNamePattern"})," flag to re-record snapshots only for those tests that match the pattern."]}),"\n",(0,n.jsx)(t.h3,{id:"property-matchers",children:"Property Matchers"}),"\n",(0,n.jsx)(t.p,{children:"Often there are fields in the object you want to snapshot which are generated (like IDs and DateTimes). If you try to snapshot these objects, they will force the snapshot to fail on every run:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'it(\'will fail every time\', function()\n\tlocal user = {\n\t\tcreatedAt = DateTime.now(),\n\t\tid = math.floor(math.random() * 20),\n\t\tname = "LeBron James"\n\t}\n\n\texpect(user).toMatchSnapshot()\nend)\n\n-- Snapshot\nexports[ [=[will fail every time 1]=] ] = [=[\n\nTable {\n  "createdAt": 2021-07-28T22:04:02.166Z,\n  "id": 14,\n  "name": "LeBron James",\n}\n]=]\n'})}),"\n",(0,n.jsx)(t.p,{children:"For these cases, Jest Lua allows providing an asymmetric matcher for any property. These matchers are checked before the snapshot is written or tested, and then saved to the snapshot file instead of the received value:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'it("will check the matchers and pass", function()\n\tlocal user = {\n\t\tcreatedAt = DateTime.now(),\n\t\tid = math.floor(math.random() * 20),\n\t\tname = "LeBron James"\n\t}\n\n\texpect(user).toMatchSnapshot({\n\t\tcreatedAt = expect.any("DateTime"),\n\t\tid = expect.any("number"),\n\t\tname = expect.any("string")\n\t})\nend)\n\n-- Snapshot\nexports[ [=[will check the matchers and pass 1]=] ] = [=[\n\nTable {\n  "createdAt": Any<DateTime>,\n  "id": Any<number>,\n  "name": Any<string>,\n}\n]=]\n'})}),"\n",(0,n.jsx)(t.p,{children:"Any given value that is not a matcher will be checked exactly and saved to the snapshot:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'it("will check the values and pass", function()\n\tlocal user = {\n\t\tcreatedAt = DateTime.now(),\n\t\tname = "Bond... James Bond"\n\t}\n\n\texpect(user).toMatchSnapshot({\n\t\tcreatedAt = expect.any("DateTime"),\n\t\tname = "Bond... James Bond"\n\t})\nend)\n\n-- Snapshot\nexports[ [=[will check the values and pass 1]=] ] = [=[\n\nTable {\n  "createdAt": Any<DateTime>,\n  "name": "Bond... James Bond",\n}\n]=]\n'})}),"\n",(0,n.jsx)(t.h2,{id:"best-practices",children:"Best Practices"}),"\n",(0,n.jsx)(t.p,{children:"Snapshots are a fantastic tool for identifying unexpected interface changes within your application \u2013 whether that interface is an API response, UI, logs, or error messages. As with any testing strategy, there are some best-practices you should be aware of, and guidelines you should follow, in order to use them effectively."}),"\n",(0,n.jsx)(t.h3,{id:"1-treat-snapshots-as-code",children:"1. Treat snapshots as code"}),"\n",(0,n.jsx)(t.p,{children:"Commit snapshots and review them as part of your regular code review process. This means treating snapshots as you would any other type of test or code in your project."}),"\n",(0,n.jsx)(t.p,{children:"Ensure that your snapshots are readable by keeping them focused, short, and by using tools that enforce these stylistic conventions."}),"\n",(0,n.jsx)(t.p,{children:"The goal is to make it easy to review snapshots in pull requests, and fight against the habit of regenerating snapshots when test suites fail instead of examining the root causes of their failure."}),"\n",(0,n.jsx)(t.h3,{id:"2-tests-should-be-deterministic",children:"2. Tests should be deterministic"}),"\n",(0,n.jsx)(t.p,{children:"Your tests should be deterministic. Running the same tests multiple times on a component that has not changed should produce the same results every time. You're responsible for making sure your generated snapshots do not include platform specific or other non-deterministic data."}),"\n",(0,n.jsx)(t.p,{children:"For example, you can use property matchers or mocking to ensure that the snapshot test is deterministic regardless of when the test is run."}),"\n",(0,n.jsx)(t.h3,{id:"3-use-descriptive-snapshot-names",children:"3. Use descriptive snapshot names"}),"\n",(0,n.jsx)(t.p,{children:"Always strive to use descriptive test and/or snapshot names for snapshots. The best names describe the expected snapshot content. This makes it easier for reviewers to verify the snapshots during review, and for anyone to know whether or not an outdated snapshot is the correct behavior before updating."}),"\n",(0,n.jsx)(t.p,{children:"For example, compare:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'exports[ [=[test case 1]=] ] = [=[\nnil]=]\n\nexports[ [=[some other test case 1]=] ] = [=[\n"Alan Turing"]=]\n'})}),"\n",(0,n.jsx)(t.p,{children:"To:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'exports[ [=[should be nil 1]=] ] = [=[\nnil]=]\n\nexports[ [=[should be Alan Turing 1]=] ] = [=[\n"Alan Turing"]=]\n'})}),"\n",(0,n.jsx)(t.p,{children:"Since the later describes exactly what's expected in the output, it's more clear to see when it's wrong:"}),"\n",(0,n.jsx)(t.pre,{children:(0,n.jsx)(t.code,{className:"language-lua",children:'exports[ [=[should be nil 1]=] ] = [=[\n"Alan Turing"]=]\n\nexports[ [=[should be Alan Turing 1]=] ] = [=[\nnil]=]\n'})}),"\n",(0,n.jsx)(t.h2,{id:"frequently-asked-questions",children:"Frequently Asked Questions"}),"\n",(0,n.jsx)(t.h3,{id:"are-snapshots-written-automatically-on-continuous-integration-ci-systems",children:"Are snapshots written automatically on Continuous Integration (CI) systems?"}),"\n",(0,n.jsxs)(t.p,{children:["No, snapshots in Jest Lua are not automatically written when Jest Lua is run in a CI system without explicitly passing ",(0,n.jsx)(t.code,{children:"UPDATESNAPSHOT"}),". It is expected that all snapshots are part of the code that is run on CI and since new snapshots automatically pass, they should not pass a test run on a CI system. It is recommended to always commit all snapshots and to keep them in version control."]}),"\n",(0,n.jsx)(t.h3,{id:"should-snapshot-files-be-committed",children:"Should snapshot files be committed?"}),"\n",(0,n.jsx)(t.p,{children:"Yes, all snapshot files should be committed alongside the modules they are covering and their tests. They should be considered part of a test, similar to the value of any other assertion in Jest Lua. In fact, snapshots represent the state of the source modules at any given point in time. In this way, when the source modules are modified, Jest Lua can tell what changed from the previous version. It can also provide a lot of additional context during code review in which reviewers can study your changes better."}),"\n",(0,n.jsx)(t.h3,{id:"does-snapshot-testing-replace-unit-testing",children:"Does snapshot testing replace unit testing?"}),"\n",(0,n.jsx)(t.p,{children:"Snapshot testing is only one of more than 20 assertions that ship with Jest Lua. The aim of snapshot testing is not to replace existing unit tests, but to provide additional value and make testing painless. In some scenarios, snapshot testing can potentially remove the need for unit testing for a particular set of functionalities (e.g. React components), but they can work together as well."}),"\n",(0,n.jsx)(t.h3,{id:"how-do-i-resolve-conflicts-within-snapshot-files",children:"How do I resolve conflicts within snapshot files?"}),"\n",(0,n.jsx)(t.p,{children:"Snapshot files must always represent the current state of the modules they are covering. Therefore, if you are merging two branches and encounter a conflict in the snapshot files, you can either resolve the conflict manually or update the snapshot file by running Jest Lua and inspecting the result."}),"\n",(0,n.jsx)(t.h3,{id:"is-it-possible-to-apply-test-driven-development-principles-with-snapshot-testing",children:"Is it possible to apply test-driven development principles with snapshot testing?"}),"\n",(0,n.jsx)(t.p,{children:"Although it is possible to write snapshot files manually, that is usually not approachable. Snapshots help to figure out whether the output of the modules covered by tests is changed, rather than giving guidance to design the code in the first place."}),"\n",(0,n.jsx)(t.h3,{id:"does-code-coverage-work-with-snapshot-testing",children:"Does code coverage work with snapshot testing?"}),"\n",(0,n.jsx)(t.p,{children:"Yes, as well as with any other test."})]})}function d(e={}){const{wrapper:t}={...(0,a.R)(),...e.components};return t?(0,n.jsx)(t,{...e,children:(0,n.jsx)(c,{...e})}):c(e)}},8453:(e,t,s)=>{s.d(t,{R:()=>i,x:()=>r});var n=s(6540);const a={},o=n.createContext(a);function i(e){const t=n.useContext(o);return n.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function r(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(a):e.components||a:i(e.components),n.createElement(o.Provider,{value:t},e.children)}}}]);