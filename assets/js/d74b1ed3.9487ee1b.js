"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[807],{4377:(e,d,T)=>{T.r(d),T.d(d,{assets:()=>R,contentTitle:()=>l,default:()=>o,frontMatter:()=>a,metadata:()=>N,toc:()=>s});var t=T(4848),n=T(8453);const a={id:"asynchronous",title:"Testing Asynchronous Code"},l=void 0,N={id:"asynchronous",title:"Testing Asynchronous Code",description:"Jest",source:"@site/docs/TestingAsyncCode.md",sourceDirName:".",slug:"/asynchronous",permalink:"/jest-lua/asynchronous",draft:!1,unlisted:!1,tags:[],version:"current",frontMatter:{id:"asynchronous",title:"Testing Asynchronous Code"},sidebar:"docs",previous:{title:"Using Matchers",permalink:"/jest-lua/using-matchers"},next:{title:"Setup and Teardown",permalink:"/jest-lua/setup-teardown"}},R={},s=[{value:"Promises",id:"promises",level:2},{value:"Callbacks",id:"callbacks",level:2}];function U(e){const d={a:"a",admonition:"admonition",code:"code",em:"em",h2:"h2",img:"img",p:"p",pre:"pre",strong:"strong",...(0,n.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(d.p,{children:(0,t.jsx)(d.a,{href:"https://jest-archive-august-2023.netlify.app/docs/27.x/asynchronous",children:(0,t.jsx)(d.img,{alt:"Jest",src:T(8143).A+"",width:"87",height:"20"})})}),"\n",(0,t.jsx)(d.p,{children:"It's common in Lua for code to run asynchronously. When you have code that runs asynchronously, Jest Lua needs to know when the code it is testing has completed, before it can move on to another test. Jest Lua has several ways to handle this."}),"\n",(0,t.jsx)(d.h2,{id:"promises",children:"Promises"}),"\n",(0,t.jsxs)(d.p,{children:["Return a ",(0,t.jsx)(d.a,{href:"https://github.com/evaera/roblox-lua-promise",children:"promise"})," from your test, and Jest Lua will wait for that promise to resolve. If the promise is rejected, the test will fail."]}),"\n",(0,t.jsxs)(d.p,{children:["For example, let's say that ",(0,t.jsx)(d.code,{children:"fetchData"})," returns a promise that is supposed to resolve to the string ",(0,t.jsx)(d.code,{children:"'peanut butter'"}),". We could test it with:"]}),"\n",(0,t.jsx)(d.admonition,{type:"note",children:(0,t.jsxs)(d.p,{children:["Tests can ",(0,t.jsx)(d.strong,{children:"ONLY"})," return either a ",(0,t.jsx)(d.code,{children:"Promise"})," or ",(0,t.jsx)(d.code,{children:"nil"}),"."]})}),"\n",(0,t.jsx)(d.pre,{children:(0,t.jsx)(d.code,{className:"language-lua",children:"test('the data is peanut butter', function()\n\treturn Promise.resolve()\n\t\t:andThen(function()\n\t\t\tlocal data = fetchData()\n\t\t\texpect(data).toBe('peanut butter')\n\t\tend)\nend)\n"})}),"\n",(0,t.jsx)(d.h2,{id:"callbacks",children:"Callbacks"}),"\n",(0,t.jsxs)(d.p,{children:["If you don't use promises, you can use callbacks. For example, let's say that ",(0,t.jsx)(d.code,{children:"fetchData"}),", instead of returning a promise, expects a callback, i.e. fetches some data and calls ",(0,t.jsx)(d.code,{children:"callback(error, data)"})," when it is complete. You want to test that this returned data is the string ",(0,t.jsx)(d.code,{children:"'peanut butter'"}),"."]}),"\n",(0,t.jsxs)(d.p,{children:["By default, Jest Lua tests complete once they reach the end of their execution. That means this test will ",(0,t.jsx)(d.em,{children:"not"})," work as intended:"]}),"\n",(0,t.jsx)(d.pre,{children:(0,t.jsx)(d.code,{className:"language-lua",children:"-- Don't do this!\ntest('the data is peanut butter', function()\n\tlocal function callback(error_, data)\n\t\tif error_ then\n\t\t\terror(error_)\n\t\tend\n\t\texpect(data).toBe('peanut butter')\n\tend\n\n\tfetchData(callback)\nend)\n"})}),"\n",(0,t.jsxs)(d.p,{children:["The problem is that the test will complete as soon as ",(0,t.jsx)(d.code,{children:"fetchData"})," completes, before ever calling the callback."]}),"\n",(0,t.jsxs)(d.p,{children:["There is an alternate form of ",(0,t.jsx)(d.code,{children:"test"})," that fixes this. Instead of putting the test in a function with an empty argument, use a single argument called ",(0,t.jsx)(d.code,{children:"done"}),", which is passed as a second parameter to the ",(0,t.jsx)(d.code,{children:"test"})," function. Jest Lua will wait until the ",(0,t.jsx)(d.code,{children:"done"})," callback is called before finishing the test."]}),"\n",(0,t.jsx)(d.pre,{children:(0,t.jsx)(d.code,{className:"language-lua",children:"test('the data is peanut butter', function(_, done)\n\tlocal function callback(error_, data)\n\t\tif error_ then\n\t\t\tdone(error_)\n\t\t\treturn\n\t\tend\n\t\txpcall(function()\n\t\t\texpect(data).toBe('peanut butter')\n\t\t\tdone()\n\t\tend, function(err)\n\t\t\tdone(err)\n\t\tend)\n\tend\n\n\tfetchData(callback)\nend)\n"})}),"\n",(0,t.jsxs)(d.p,{children:["If ",(0,t.jsx)(d.code,{children:"done()"})," is never called, the test will fail (with timeout error), which is what you want to happen."]}),"\n",(0,t.jsxs)(d.p,{children:["If the ",(0,t.jsx)(d.code,{children:"expect"})," statement fails, it throws an error and ",(0,t.jsx)(d.code,{children:"done()"})," is not called. If we want to see in the test log why it failed, we have to wrap ",(0,t.jsx)(d.code,{children:"expect"})," in a ",(0,t.jsx)(d.code,{children:"xpcall"})," block and pass the error in the error handler to ",(0,t.jsx)(d.code,{children:"done"}),". Otherwise, we end up with an opaque timeout error that doesn't show what value was received by ",(0,t.jsx)(d.code,{children:"expect(data)"}),"."]}),"\n",(0,t.jsx)(d.admonition,{type:"danger",children:(0,t.jsxs)(d.p,{children:[(0,t.jsx)(d.code,{children:"done()"})," should not be mixed with Promises in your tests."]})})]})}function o(e={}){const{wrapper:d}={...(0,n.R)(),...e.components};return d?(0,t.jsx)(d,{...e,children:(0,t.jsx)(U,{...e})}):U(e)}},8143:(e,d,T)=>{T.d(d,{A:()=>t});const t="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iODciIGhlaWdodD0iMjAiIHJvbGU9ImltZyIgYXJpYS1sYWJlbD0iSmVzdCBEb2NzIj48dGl0bGU+SmVzdCBEb2NzPC90aXRsZT48ZyBzaGFwZS1yZW5kZXJpbmc9ImNyaXNwRWRnZXMiPjxyZWN0IHdpZHRoPSIyNCIgaGVpZ2h0PSIyMCIgZmlsbD0iI2MyMTMyNSIvPjxyZWN0IHg9IjI0IiB3aWR0aD0iNjMiIGhlaWdodD0iMjAiIGZpbGw9IiNjMjEzMjUiLz48L2c+PGcgZmlsbD0iI2ZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZm9udC1mYW1pbHk9IlZlcmRhbmEsR2VuZXZhLERlamFWdSBTYW5zLHNhbnMtc2VyaWYiIHRleHQtcmVuZGVyaW5nPSJnZW9tZXRyaWNQcmVjaXNpb24iIGZvbnQtc2l6ZT0iMTEwIj48aW1hZ2UgeD0iNSIgeT0iMyIgd2lkdGg9IjE0IiBoZWlnaHQ9IjE0IiB4bGluazpocmVmPSJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUJtYVd4c1BTSjNhR2wwWlNJZ2NtOXNaVDBpYVcxbklpQjJhV1YzUW05NFBTSXdJREFnTWpRZ01qUWlJSGh0Ykc1elBTSm9kSFJ3T2k4dmQzZDNMbmN6TG05eVp5OHlNREF3TDNOMlp5SStQSFJwZEd4bFBrcGxjM1E4TDNScGRHeGxQanh3WVhSb0lHUTlJazB5TWk0eU5URWdNVEV1T0RKaE15NHhNVGNnTXk0eE1UY2dNQ0F3SURBdE1pNHpNamd0TXk0d01Vd3lNaTQ1TVRFZ01FZzRMakV3TkV3eE1TNHhJRGd1T0RNNFlUTXVNVEUySURNdU1URTJJREFnTUNBd0xUSXVNalEwSURJdU9UZzRZekFnTVM0d05ETXVOVElnTVM0NU5qY2dNUzR6TVRNZ01pNDFNelpoT0M0eU56a2dPQzR5TnprZ01DQXdJREV0TVM0d09EUWdNUzR5TkRRZ09DNHhOQ0E0TGpFMElEQWdNQ0F4TFRJdU5UVWdNUzQyTkRkakxTNDRNelF0TGpVMk15MHhMakU1TlMweExqVTFOaTB1T0RZNUxUSXVORFEyWVRNdU1URWdNeTR4TVNBd0lEQWdNQzB1T1RFdE5pNHdPQ0F6TGpFeE55QXpMakV4TnlBd0lEQWdNQzB6TGpFeE15QXpMakV4TTJNd0lDNDRORGd1TXpRM0lERXVOakkyTGprd015QXlMakU0TWkwdU1EUTRMakE1TnkwdU1EazNMakU1TlMwdU1UUTJMakk1T1MwdU5EWTFMamsxT1MwdU9Ua3pJREl1TURRekxURXVNVGsxSURNdU1qVTVMUzQwTURNZ01pNDBNekl1TWpVM0lEUXVNemcwSURFdU9EUTVJRFV1TkRnNVFUVXVNRGt6SURVdU1Ea3pJREFnTUNBd0lEVXVPVGs1SURJMFl6RXVPREkzSURBZ015NDJPREl0TGpreE55QTFMalEzTlMweExqZ3dOeUF4TGpJM09TMHVOak15SURJdU5UazVMVEV1TWpreUlETXVPRGs0TFRFdU5qRXlMalE0TFM0eE1UZ3VPVGd0TGpFNE55QXhMalV3T0MwdU1qWTBJREV1TURjdExqRTFNeUF5TGpFM05TMHVNekV5SURNdU1UWTRMUzQ0T1dFMExqUTRNaUEwTGpRNE1pQXdJREFnTUNBeUxqRTRNaTB6TGpBNU1XTXVNVGMwTFM0NU9UUWdNQzB4TGprNU5DMHVORFEwTFRJdU9EY3VNams0TFM0ME9DNDBOalV0TVM0d05ESXVORFkxTFRFdU5qUTNlbTB0TVM0ek5UVWdNR013SUM0NU5qVXRMamM0TlNBeExqYzFMVEV1TnpVZ01TNDNOV0V4TGpjMU15QXhMamMxTXlBd0lEQWdNUzB4TGpBNE5TMHpMakV5Tm13dU1EQTNMUzR3TURkakxqQTFOaTB1TURReUxqRXhPQzB1TURnMExqRTRMUzR4TWpVZ01DQXdJQzR3TURnZ01DQXVNREE0TFM0d01EY3VNREk0TFM0d01UUXVNRFUxTFM0d016VXVNRGd6TFM0d05TNHdNRGNnTUNBdU1ERTBMUzR3TURZdU1ESXhMUzR3TURZdU1ESTRMUzR3TVRRdU1EWXpMUzR3TWpndU1EazNMUzR3TkRJdU1ETTFMUzR3TVRRdU1EY3RMakF5Tnk0d09UZ3RMakEwTVM0d01EY2dNQ0F1TURFekxTNHdNRGN1TURJdExqQXdOeTR3TWpndExqQXdOeTR3TlRZdExqQXlNUzR3T0RRdExqQXlPQzR3TURjZ01DQXVNREl0TGpBd055NHdNamd0TGpBd055NHdNelF0TGpBd055NHdOakl0TGpBeE5DNHdPVGN0TGpBeWFDNHdNRGRzTGpFd05DMHVNREl5WXk0d01EY2dNQ0F1TURJZ01DQXVNREk0TFM0d01EY3VNREk0SURBZ0xqQTFOUzB1TURBM0xqQTRNeTB1TURBM2FDNHdNelZqTGpBek5TQXdJQzR3TnkwdU1EQTNMakV4TVMwdU1EQTNhQzR3T1dNdU1ESTRJREFnTGpBMUlEQWdMakEzTnk0d01EZG9MakF4TkdNdU1EVTFMakF3Tnk0eE1URXVNREUwTGpFMk55NHdNamhoTVM0M05qWWdNUzQzTmpZZ01DQXdJREVnTVM0ek9UWWdNUzQzTWpONlRURXdMakEwTXlBeExqTTVhREV3TGpremJDMHlMalV3T1NBM0xqUmpMUzR4TURRdU1ESXRMakl3T0M0d05UVXRMak14TWk0d09Xd3RNaTQyTkMwMUxqTTROUzB5TGpZME9DQTFMak0xWXkwdU1UQTBMUzR3TXpRdExqSXhOaTB1TURVMUxTNHpNamN0TGpBM05td3RNaTQwT1RRdE55NHpPSHB0TkM0NU5qZ2dPUzQ0TWpWaE15NHdPRE1nTXk0d09ETWdNQ0F3SURBdExqa3pPQzB4TGpZMk9Hd3hMalF6T0MweUxqa3dOQ0F4TGpRMU1pQXlMamsyTjJNdExqUXpMalF6TFM0M05ETXVPVGd0TGpnMk9DQXhMall3TlVneE5TNHdNWHB0TFRNdU5EZ3hMVEV1TURrNFl5NHdNelF0TGpBd055NHdOakl0TGpBeE5DNHdPVGN0TGpBeWFDNHdNbU11TURJNUxTNHdNRGd1TURVMkxTNHdNRGd1TURnMExTNHdNVFZvTGpBeU9HTXVNREk0SURBZ0xqQTBPUzB1TURBM0xqQTNOaTB1TURBM2FDNHlOekZqTGpBeU9DQXdJQzR3TkRrdU1EQTNMakEzTGpBd055NHdNVFFnTUNBdU1ESWdNQ0F1TURNMUxqQXdOeTR3TWpjdU1EQTNMakEwT0M0d01EY3VNRGMyTGpBeE5DNHdNRGNnTUNBdU1ERTBJREFnTGpBeU9DNHdNRGRzTGpBNU55NHdNbWd1TURBM1l5NHdNamd1TURBNExqQTFOaTR3TVRVdU1EZ3pMakF5T1M0d01EY2dNQ0F1TURFMExqQXdOeTR3TWpndU1EQTNMakF5TVM0d01EY3VNRFE1TGpBeE5DNHdOeTR3TWpjdU1EQTNJREFnTGpBeE5DNHdNRGN1TURJdU1EQTNMakF5T0M0d01UUXVNRFUyTGpBeU1TNHdPRFF1TURNMWFDNHdNRGRoTGpNM05DNHpOelFnTUNBd0lERWdMakE1TGpBME9XZ3VNREEzWXk0d01qZ3VNREUwTGpBMU5pNHdNelF1TURnMExqQTBPQzR3TURjZ01DQXVNREEzTGpBd055NHdNVE11TURBM0xqQXlPQzR3TVRRdU1EVXVNRE0xTGpBM055NHdORGxzTGpBd055NHdNRGRqTGpBNE15NHdOakl1TVRZdU1UTXlMakl6Tmk0eU1ERnNMakF3Tnk0d01EZGhNUzQzTkRjZ01TNDNORGNnTUNBd0lERWdMalE0SURFdU1qQTVJREV1TnpVeUlERXVOelV5SURBZ01DQXhMVE11TlRBeUlEQWdNUzQzTkRJZ01TNDNORElnTUNBd0lERWdNUzR6TWkweExqWTVOWHB0TFRZdU9ETTRMUzR3TkRsakxqazJOaUF3SURFdU56VXhMamM0TmlBeExqYzFNU0F4TGpjMU1YTXRMamM0TlNBeExqYzFNUzB4TGpjMUlERXVOelV4TFRFdU56VXlMUzQzT0RVdE1TNDNOVEl0TVM0M05TNDNPRFl0TVM0M05USWdNUzQzTlRFdE1TNDNOVEo2YlRFMkxqRTJNeUEyTGpBeU5XRXpMakEzSURNdU1EY2dNQ0F3SURFdE1TNDFNRGdnTWk0eE16TmpMUzQzTlRndU5ETTRMVEV1TmpnNUxqVTNOeTB5TGpZMk9TNDNNVFpoTVRjdU1qa2dNVGN1TWprZ01DQXdJREF0TVM0Mk5DNHlPVEZqTFRFdU5EUTFMak0xTlMweUxqZ3pOQ0F4TGpBMUxUUXVNVGd5SURFdU56RTNMVEV1TnpJMExqZzFOQzB6TGpNMUlERXVOall0TkM0NE5UY2dNUzQyTm1FekxqWTBOU0F6TGpZME5TQXdJREFnTVMweUxqRTFOQzB1TmpnNFl5MHhMalV5T1MweExqQTFOaTB4TGpRMU15MHpMakF6TmkweExqSTNNaTAwTGpFeUxqRTJOeTB4TGpBeE5TNDJNekl0TVM0NU5qWWdNUzR3TnpjdE1pNDROemN1TURJNExTNHdOVFV1TURRNUxTNHhNRFF1TURjM0xTNHhOaTR4TlRJdU1EVTJMak14TWk0d09UZ3VORGM1TGpFeU5pMHVNalkwSURFdU5EY3pMalE0TmlBeUxqazVOQ0F4TGprME5pQXpMamMwTld3dU1qWTBMakV6T1M0eU9EUXRMakV3TkdNeExqSXhOaTB1TkRNeElESXVNelF5TFRFdU1UTXpJRE11TXpNMkxUSXVNRGN4WVRrdU16TTBJRGt1TXpNMElEQWdNQ0F3SURFdU5EUTFMVEV1TnpFMll5NHhOaTR3TWpjdU16SXVNRE0wTGpRNExqQXpOR0V6TGpFeE55QXpMakV4TnlBd0lEQWdNQ0F6TGpBd09DMHlMak15TjJneExqRTJOMkV6TGpFd09TQXpMakV3T1NBd0lEQWdNQ0F6TGpBeElESXVNekkzWXk0MU56WWdNQ0F4TGpFeExTNHhOaUF4TGpVM0xTNDBNeTR4T0M0MU1pNHlNellnTVM0d05qTXVNVE01SURFdU5qQTFlaUl2UGp3dmMzWm5QZz09Ii8+PHRleHQgeD0iNTQ1IiB5PSIxNDAiIHRyYW5zZm9ybT0ic2NhbGUoLjEpIiBmaWxsPSIjZmZmIiB0ZXh0TGVuZ3RoPSI1MzAiPkplc3QgRG9jczwvdGV4dD48L2c+PC9zdmc+"},8453:(e,d,T)=>{T.d(d,{R:()=>l,x:()=>N});var t=T(6540);const n={},a=t.createContext(n);function l(e){const d=t.useContext(a);return t.useMemo((function(){return"function"==typeof e?e(d):{...d,...e}}),[d,e])}function N(e){let d;return d=e.disableParentContext?"function"==typeof e.components?e.components(n):e.components||n:l(e.components),t.createElement(a.Provider,{value:d},e.children)}}}]);