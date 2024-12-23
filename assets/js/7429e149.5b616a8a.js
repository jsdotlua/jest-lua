"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[522],{5931:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>c,contentTitle:()=>a,default:()=>u,frontMatter:()=>s,metadata:()=>l,toc:()=>d});var t=r(4848),i=r(8453),o=r(4252);const s={id:"jest-benchmark",title:"Jest Benchmark"},a=void 0,l={id:"jest-benchmark",title:"Jest Benchmark",description:"Roblox only",source:"@site/docs/JestBenchmarkAPI.md",sourceDirName:".",slug:"/jest-benchmark",permalink:"/jest-lua/jest-benchmark",draft:!1,unlisted:!1,tags:[],version:"current",frontMatter:{id:"jest-benchmark",title:"Jest Benchmark"},sidebar:"api",previous:{title:"The Jest Object",permalink:"/jest-lua/jest-object"},next:{title:"Configuring Jest",permalink:"/jest-lua/configuration"}},c={},d=[{value:"Methods",id:"methods",level:2},{value:"<code>benchmark(name, fn, timeout)</code>",id:"benchmarkname-fn-timeout",level:3},{value:"Reporter",id:"reporter",level:2},{value:"<code>initializeReporter(metricName, fn)</code>",id:"initializereportermetricname-fn",level:3},{value:"<code>Reporter.start(sectionName)</code>",id:"reporterstartsectionname",level:3},{value:"<code>Reporter.stop()</code>",id:"reporterstop",level:3},{value:"<code>Reporter.report(number)</code>",id:"reporterreportnumber",level:3},{value:"<code>Reporter.finish()</code>",id:"reporterfinish",level:3},{value:"Profiler",id:"profiler",level:2},{value:"<code>initializeProfiler(reporters, fn, prefix?)</code>",id:"initializeprofilerreporters-fn-prefix",level:3},{value:"<code>Profiler.start(sectionName)</code>",id:"profilerstartsectionname",level:3},{value:"<code>Profiler.stop()</code>",id:"profilerstop",level:3},{value:"<code>Profiler.finish()</code>",id:"profilerfinish",level:3},{value:"CustomReporters",id:"customreporters",level:2},{value:"MetricLogger",id:"metriclogger",level:2}];function h(e){const n={a:"a",code:"code",h2:"h2",h3:"h3",img:"img",p:"p",pre:"pre",...(0,i.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.p,{children:(0,t.jsx)(n.img,{alt:"Roblox only",src:r(9837).A+"",width:"99",height:"20"})}),"\n",(0,t.jsxs)(n.p,{children:["Benchmarks are useful tools for gating performance in CI, optimizing code, and capturing performance gains. ",(0,t.jsx)(n.code,{children:"JestBenchmark"})," aims to make it easier to write benchmarks in the Luau language."]}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"JestBenchmark"})," must be added as a dev dependency to your ",(0,t.jsx)(n.code,{children:"rotriever.toml"})," and imported."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-yaml",metastring:'title="rotriever.toml"',children:'JestBenchmark = "3.9.1"\n'})}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:"local JestBenchmark = require(Packages.Dev.JestBenchmark)\nlocal benchmark = JestBenchmark.benchmark\nlocal CustomReporters = JestBenchmark.CustomReporters\n"})}),"\n",(0,t.jsx)(n.h2,{id:"methods",children:"Methods"}),"\n","\n","\n",(0,t.jsx)(o.A,{toc:d.slice(1)}),"\n",(0,t.jsx)(n.h3,{id:"benchmarkname-fn-timeout",children:(0,t.jsx)(n.code,{children:"benchmark(name, fn, timeout)"})}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"benchmark"})," function is a wrapper around ",(0,t.jsx)(n.code,{children:"test"})," that provides automatic profiling for FPS and benchmark running time. Similar to ",(0,t.jsx)(n.code,{children:"test"}),", it exposes ",(0,t.jsx)(n.code,{children:"benchmark.only"})," and ",(0,t.jsx)(n.code,{children:"benchmark.skip"})," to focus and skip tests, respectively."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'describe("Home Page Benchmarks", function()\n\tbenchmark("First Render Performance", function(Profiler, reporters)\n\t\trender(React.createElement(HomePage))\n\n\t\tlocal GameCarousel = screen.getByText("Continue"):expect()\n\n\t\texpect(GameCarousel).toBeDefined()\n\tend)\nend)\n'})}),"\n",(0,t.jsx)(n.h2,{id:"reporter",children:"Reporter"}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"Reporter"})," object collects and aggregates data generated during a benchmark. For example, you may have an FPS reporter that collects the delta time between each frame in a benchmark and calculates the average FPS over the benchmark."]}),"\n",(0,t.jsx)(n.h3,{id:"initializereportermetricname-fn",children:(0,t.jsx)(n.code,{children:"initializeReporter(metricName, fn)"})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"initializeReporter"})," accepts a metric name and collector function as arguments and returns a ",(0,t.jsx)(n.code,{children:"Reporter"})," object. The metric name is the label given to the data collected. The collector function accepts a list of values and reduces them to a single value."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'local function average(nums: { number }): num\n\tif #nums == 0 then\n\t\treturn 0\n\tend\n\n\tlocal sum = 0\n\tfor _, v in nums do\n\t\tsum += v\n\tend\n\n\treturn sum / #nums\nend\n\nlocal averageReporter = initializeReporter("average", average)\n'})}),"\n",(0,t.jsx)(n.h3,{id:"reporterstartsectionname",children:(0,t.jsx)(n.code,{children:"Reporter.start(sectionName)"})}),"\n",(0,t.jsxs)(n.p,{children:["A reporting segment is initialized with ",(0,t.jsx)(n.code,{children:"Reporter.start(sectionName: string)"}),". All values reported within the segment are collected as a group and reduced to a single value in ",(0,t.jsx)(n.code,{children:"Reporter.finish"}),". The segment is labeled with the ",(0,t.jsx)(n.code,{children:"sectionName"})," argument. Reporter segments can be nested or can run sequentially. All Reporter segments must be concluded by calling ",(0,t.jsx)(n.code,{children:"Reporter.stop"})]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'averageReporter.start("total")\n\naverageReporter.start("section1")\naverageReporter.report(1)\naverageReporter.report(3)\naverageReporter.stop() -- closes section1\n\naverageReporter.start("section2")\naverageReporter.report(5)\naverageReporter.report(7)\naverageReporter.stop() -- closes section2\n\naverageReporter.stop() -- closes total\n\nlocal sectionNames, sectionValues = averageReporter.finish()\n-- sectionNames: {"section1", "section2", "total"}\n-- sectionValues: {2, 6, 4}\n'})}),"\n",(0,t.jsx)(n.h3,{id:"reporterstop",children:(0,t.jsx)(n.code,{children:"Reporter.stop()"})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"Reporter.stop"})," is called, the reporter section at the top of the stack is popped off, and a section of reported values are marked for collection at the end of benchmark. No collection is done during the benchmark runtime, since this could reduce performance."]}),"\n",(0,t.jsx)(n.h3,{id:"reporterreportnumber",children:(0,t.jsx)(n.code,{children:"Reporter.report(number)"})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"Reporter.report(value: T)"})," is called, a value is added to the report queue. The values passed to report are reduced when ",(0,t.jsx)(n.code,{children:"reporter.finish"})," is called."]}),"\n",(0,t.jsx)(n.h3,{id:"reporterfinish",children:(0,t.jsx)(n.code,{children:"Reporter.finish()"})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"Reporter.finish"})," should be called at the end of the benchmark runtime. It returns a list of section names and a list of section values generated according to the ",(0,t.jsx)(n.code,{children:"collectorFn"}),". Values are returned in order of completion."]}),"\n",(0,t.jsx)(n.h2,{id:"profiler",children:"Profiler"}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"Profiler"})," object controls a set of reporters and reports data generated during a benchmark. The Profiler is initialized with the ",(0,t.jsx)(n.code,{children:"initializeProfiler"})," function. A profiling segment is started by calling ",(0,t.jsx)(n.code,{children:"Profiler.start"})," and stopped by calling ",(0,t.jsx)(n.code,{children:"Profiler.stop"}),". These segments can be called sequentially or can be nested. Results are generated by calling ",(0,t.jsx)(n.code,{children:"Profiler.finish"}),"."]}),"\n",(0,t.jsx)(n.h3,{id:"initializeprofilerreporters-fn-prefix",children:(0,t.jsx)(n.code,{children:"initializeProfiler(reporters, fn, prefix?)"})}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"intializeProfiler"})," accepts a list of reporters and an outputFn as arguments and returns a ",(0,t.jsx)(n.code,{children:"Profiler"})," object. An optional ",(0,t.jsx)(n.code,{children:"prefix"})," string can be appended to all the section names."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'local reporters = {\n\tinitializeReporter("average", average),\n\tinitializeReporter("sectionTime", sectionTime),\n}\n\nlocal outputFn = function(metricName: string, value: any)\n\tprint(`{metricName}, {value}`)\nend\n\nlocal profiler = initializeProfiler(reporters, outputFn)\n'})}),"\n",(0,t.jsx)(n.h3,{id:"profilerstartsectionname",children:(0,t.jsx)(n.code,{children:"Profiler.start(sectionName)"})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"Profiler.start(sectionName: string)"})," is called, ",(0,t.jsx)(n.code,{children:"reporter.start"})," is called for each reporter in the reporters list. Each Profiler section must be concluded with a ",(0,t.jsx)(n.code,{children:"Profiler.stop()"})," call."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'Profiler.start("section1")\n\nProfiler.stop()\n'})}),"\n",(0,t.jsx)(n.h3,{id:"profilerstop",children:(0,t.jsx)(n.code,{children:"Profiler.stop()"})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"Profiler.stop()"})," is called, reporter.stop is called for each reporter in the reporters list. Calling ",(0,t.jsx)(n.code,{children:"Profiler.stop"})," without first calling ",(0,t.jsx)(n.code,{children:"Profiler.start"})," will result in an error."]}),"\n",(0,t.jsx)(n.h3,{id:"profilerfinish",children:(0,t.jsx)(n.code,{children:"Profiler.finish()"})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"Profiler.finish"})," is called, reporter.finish is called for each reporter in the reporters list. The results of each finish call is then printed by the outputFn passed to the Profiler."]}),"\n",(0,t.jsx)(n.h2,{id:"customreporters",children:"CustomReporters"}),"\n",(0,t.jsxs)(n.p,{children:["By default, the ",(0,t.jsx)(n.code,{children:"benchmark"})," function has two reporters attached: ",(0,t.jsx)(n.code,{children:"FPSReporter"})," and ",(0,t.jsx)(n.code,{children:"SectionTimeReporter"}),". However, you may want to add custom reporters, perhaps to track Rodux action dispatches, time to interactive, or React re-renders. To enable this, the CustomReporters object exports ",(0,t.jsx)(n.code,{children:"useCustomReporters"}),", which allows the user to add additional reporters to the Profiler. These reporters are passed in a key-value table as the second argument in the provided benchmark function. This should be used in combination with ",(0,t.jsx)(n.code,{children:"useDefaultReporters"}),", which removes all custom reporters from the Profiler."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'local MetricLogger = JestBenchmarks.CustomReporters\n\nbeforeEach(function()\n\tCustomReporters.useCustomReporters({\n\t\tsum = initializeReporter("sum", function(nums)\n\t\t\tlocal sum = 0\n\t\t\tfor _, v in nums do\n\t\t\t\tsum += v\n\t\t\tend\n\t\t\treturn sum\n\t\tend)\n\t})\nend)\n\nbenchmark("Total renders", function(Profiler, reporters)\n\tlocal renderCount = getRenderCount()\n\treporters.sum.report(renderCount)\nend)\n\nafterEach(function()\n\tCustomReporters.useDefaultReporters()\nend)\n'})}),"\n",(0,t.jsx)(n.h2,{id:"metriclogger",children:"MetricLogger"}),"\n",(0,t.jsxs)(n.p,{children:["By default, benchmarks output directly to stdout. This may not be desirable in all cases. For example, you may want to output results to a BindableEvent or a file stream. The MetricLogger object exposes a ",(0,t.jsx)(n.code,{children:"useCustomMetricLogger"})," function, which allows the user to override the default output function. This should be used in combination with ",(0,t.jsx)(n.code,{children:"useDefaultMetricLogger"}),", which resets the output function to the default value"]}),"\n",(0,t.jsxs)(n.p,{children:["For example, to encode the benchmark metrics as a JSON and write the output to a ",(0,t.jsx)(n.code,{children:"json"})," file for each test file, you may configure the following custom metric logger in a ",(0,t.jsx)(n.a,{href:"configuration#setupfilesafterenv-arraymodulescript",children:(0,t.jsx)(n.code,{children:"setupFilesAfterEnv"})}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-lua",children:'local MetricLogger = JestBenchmarks.MetricLogger\n\nlocal benchmarks\n\nbeforeAll(function()\n\tbenchmarks = {}\nend)\n\nbeforeEach(function()\n\tMetricLogger.useCustomMetricLogger(function(metricName: string, value: any)\n\t\ttable.insert(benchmarks, HttpService:JSONEncode({\n\t\t\tmetric = metricName,\n\t\t\tvalue = value\n\t\t}))\n\tend)\nend)\n\nafterAll(function()\n\tlocal benchmarkFile = tostring(expect.getState().testPath) .. ".json"\n\tFileSystemService:WriteFile(benchmarkFile, benchmarks)\n\tMetricLogger.useDefaultMetricLogger()\nend)\n'})})]})}function u(e={}){const{wrapper:n}={...(0,i.R)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(h,{...e})}):h(e)}},4252:(e,n,r)=>{r.d(n,{A:()=>s});r(6540);var t=r(5195);const i={tableOfContentsInline:"tableOfContentsInline_prmo"};var o=r(4848);function s(e){let{toc:n,minHeadingLevel:r,maxHeadingLevel:s}=e;return(0,o.jsx)("div",{className:i.tableOfContentsInline,children:(0,o.jsx)(t.A,{toc:n,minHeadingLevel:r,maxHeadingLevel:s,className:"table-of-contents",linkClassName:null})})}},5195:(e,n,r)=>{r.d(n,{A:()=>f});var t=r(6540),i=r(6342);function o(e){const n=e.map((e=>({...e,parentIndex:-1,children:[]}))),r=Array(7).fill(-1);n.forEach(((e,n)=>{const t=r.slice(2,e.level);e.parentIndex=Math.max(...t),r[e.level]=n}));const t=[];return n.forEach((e=>{const{parentIndex:r,...i}=e;r>=0?n[r].children.push(i):t.push(i)})),t}function s(e){let{toc:n,minHeadingLevel:r,maxHeadingLevel:t}=e;return n.flatMap((e=>{const n=s({toc:e.children,minHeadingLevel:r,maxHeadingLevel:t});return function(e){return e.level>=r&&e.level<=t}(e)?[{...e,children:n}]:n}))}function a(e){const n=e.getBoundingClientRect();return n.top===n.bottom?a(e.parentNode):n}function l(e,n){let{anchorTopOffset:r}=n;const t=e.find((e=>a(e).top>=r));if(t){return function(e){return e.top>0&&e.bottom<window.innerHeight/2}(a(t))?t:e[e.indexOf(t)-1]??null}return e[e.length-1]??null}function c(){const e=(0,t.useRef)(0),{navbar:{hideOnScroll:n}}=(0,i.p)();return(0,t.useEffect)((()=>{e.current=n?0:document.querySelector(".navbar").clientHeight}),[n]),e}function d(e){const n=(0,t.useRef)(void 0),r=c();(0,t.useEffect)((()=>{if(!e)return()=>{};const{linkClassName:t,linkActiveClassName:i,minHeadingLevel:o,maxHeadingLevel:s}=e;function a(){const e=function(e){return Array.from(document.getElementsByClassName(e))}(t),a=function(e){let{minHeadingLevel:n,maxHeadingLevel:r}=e;const t=[];for(let i=n;i<=r;i+=1)t.push(`h${i}.anchor`);return Array.from(document.querySelectorAll(t.join()))}({minHeadingLevel:o,maxHeadingLevel:s}),c=l(a,{anchorTopOffset:r.current}),d=e.find((e=>c&&c.id===function(e){return decodeURIComponent(e.href.substring(e.href.indexOf("#")+1))}(e)));e.forEach((e=>{!function(e,r){r?(n.current&&n.current!==e&&n.current.classList.remove(i),e.classList.add(i),n.current=e):e.classList.remove(i)}(e,e===d)}))}return document.addEventListener("scroll",a),document.addEventListener("resize",a),a(),()=>{document.removeEventListener("scroll",a),document.removeEventListener("resize",a)}}),[e,r])}var h=r(8774),u=r(4848);function m(e){let{toc:n,className:r,linkClassName:t,isChild:i}=e;return n.length?(0,u.jsx)("ul",{className:i?void 0:r,children:n.map((e=>(0,u.jsxs)("li",{children:[(0,u.jsx)(h.A,{to:`#${e.id}`,className:t??void 0,dangerouslySetInnerHTML:{__html:e.value}}),(0,u.jsx)(m,{isChild:!0,toc:e.children,className:r,linkClassName:t})]},e.id)))}):null}const p=t.memo(m);function f(e){let{toc:n,className:r="table-of-contents table-of-contents__left-border",linkClassName:a="table-of-contents__link",linkActiveClassName:l,minHeadingLevel:c,maxHeadingLevel:h,...m}=e;const f=(0,i.p)(),g=c??f.tableOfContents.minHeadingLevel,x=h??f.tableOfContents.maxHeadingLevel,j=function(e){let{toc:n,minHeadingLevel:r,maxHeadingLevel:i}=e;return(0,t.useMemo)((()=>s({toc:o(n),minHeadingLevel:r,maxHeadingLevel:i})),[n,r,i])}({toc:n,minHeadingLevel:g,maxHeadingLevel:x});return d((0,t.useMemo)((()=>{if(a&&l)return{linkClassName:a,linkActiveClassName:l,minHeadingLevel:g,maxHeadingLevel:x}}),[a,l,g,x])),(0,u.jsx)(p,{toc:j,className:r,linkClassName:a,...m})}},9837:(e,n,r)=>{r.d(n,{A:()=>t});const t="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iOTkiIGhlaWdodD0iMjAiIHJvbGU9ImltZyIgYXJpYS1sYWJlbD0iUm9ibG94LW9ubHkiPjx0aXRsZT5Sb2Jsb3ggb25seTwvdGl0bGU+PGcgc2hhcGUtcmVuZGVyaW5nPSJjcmlzcEVkZ2VzIj48cmVjdCB3aWR0aD0iMjQiIGhlaWdodD0iMjAiIGZpbGw9IiMyNTI1MjUiLz48cmVjdCB4PSIyNCIgd2lkdGg9Ijc1IiBoZWlnaHQ9IjIwIiBmaWxsPSIjMjUyNTI1Ii8+PC9nPjxnIGZpbGw9IiNmZmYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtZmFtaWx5PSJWZXJkYW5hLEdlbmV2YSxEZWphVnUgU2FucyxzYW5zLXNlcmlmIiB0ZXh0LXJlbmRlcmluZz0iZ2VvbWV0cmljUHJlY2lzaW9uIiBmb250LXNpemU9IjExMCI+PGltYWdlIHg9IjUiIHk9IjMiIHdpZHRoPSIxNCIgaGVpZ2h0PSIxNCIgeGxpbms6aHJlZj0iZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCbWFXeHNQU0ozYUdsMFpTSWdjbTlzWlQwaWFXMW5JaUIyYVdWM1FtOTRQU0l3SURBZ01qUWdNalFpSUhodGJHNXpQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh5TURBd0wzTjJaeUkrUEhScGRHeGxQbEp2WW14dmVEd3ZkR2wwYkdVK1BIQmhkR2dnWkQwaWJURXpMak00TXlBeE5DNHpOREV0TXk0M01qWXRMamsxT0M0NU5Ua3RNeTQzTWpZZ015NDNNall1T1RVNUxTNDVOaUF6TGpjeU5ucE5OQzQ1TVRNZ01DQXdJREU1TGpBNE9DQXhPUzR3T0RnZ01qUWdNalFnTkM0NU1USWdOQzQ1TVRJZ01Ib2lMejQ4TDNOMlp6ND0iLz48dGV4dCB4PSI2MDUiIHk9IjE0MCIgdHJhbnNmb3JtPSJzY2FsZSguMSkiIGZpbGw9IiNmZmYiIHRleHRMZW5ndGg9IjY1MCI+Um9ibG94IG9ubHk8L3RleHQ+PC9nPjwvc3ZnPg=="},8453:(e,n,r)=>{r.d(n,{R:()=>s,x:()=>a});var t=r(6540);const i={},o=t.createContext(i);function s(e){const n=t.useContext(o);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function a(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:s(e.components),t.createElement(o.Provider,{value:n},e.children)}}}]);