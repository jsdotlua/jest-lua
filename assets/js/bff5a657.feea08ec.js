"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[793],{6702:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>r,contentTitle:()=>s,default:()=>c,frontMatter:()=>i,metadata:()=>o,toc:()=>l});var a=t(4848),d=t(8453);const i={id:"setup-teardown",title:"Setup and Teardown"},s=void 0,o={id:"setup-teardown",title:"Setup and Teardown",description:"Jest",source:"@site/docs/SetupAndTeardown.md",sourceDirName:".",slug:"/setup-teardown",permalink:"/jest-lua/setup-teardown",draft:!1,unlisted:!1,tags:[],version:"current",frontMatter:{id:"setup-teardown",title:"Setup and Teardown"},sidebar:"docs",previous:{title:"Testing Asynchronous Code",permalink:"/jest-lua/asynchronous"},next:{title:"Mock Functions",permalink:"/jest-lua/mock-functions"}},r={},l=[{value:"Repeating Setup",id:"repeating-setup",level:2},{value:"One-Time Setup",id:"one-time-setup",level:2},{value:"Scoping",id:"scoping",level:2},{value:"Order of Execution",id:"order-of-execution",level:2},{value:"General Advice",id:"general-advice",level:2}];function T(e){const n={a:"a",code:"code",em:"em",h2:"h2",img:"img",p:"p",pre:"pre",...(0,d.R)(),...e.components};return(0,a.jsxs)(a.Fragment,{children:[(0,a.jsx)(n.p,{children:(0,a.jsx)(n.a,{href:"https://jest-archive-august-2023.netlify.app/docs/27.x/setup-teardown",children:(0,a.jsx)(n.img,{alt:"Jest",src:t(8143).A+"",width:"87",height:"20"})})}),"\n",(0,a.jsx)(n.p,{children:"Often while writing tests you have some setup work that needs to happen before tests run, and you have some finishing work that needs to happen after tests run. Jest Lua provides helper functions to handle this."}),"\n",(0,a.jsx)(n.h2,{id:"repeating-setup",children:"Repeating Setup"}),"\n",(0,a.jsxs)(n.p,{children:["If you have some work you need to do repeatedly for many tests, you can use ",(0,a.jsx)(n.code,{children:"beforeEach"})," and ",(0,a.jsx)(n.code,{children:"afterEach"})," hooks."]}),"\n",(0,a.jsxs)(n.p,{children:["For example, let's say that several tests interact with a database of cities. You have a method ",(0,a.jsx)(n.code,{children:"initializeCityDatabase()"})," that must be called before each of these tests, and a method ",(0,a.jsx)(n.code,{children:"clearCityDatabase()"})," that must be called after each of these tests. You can do this with:"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"beforeEach(function()\n\tinitializeCityDatabase()\nend)\n\nafterEach(function()\n\tclearCityDatabase()\nend)\n\ntest('city database has Vienna', function()\n\texpect(isCity('Vienna')).toBeTruthy()\nend)\n\ntest('city database has San Juan', function()\n\texpect(isCity('San Juan')).toBeTruthy()\nend)\n"})}),"\n",(0,a.jsxs)(n.p,{children:[(0,a.jsx)(n.code,{children:"beforeEach"})," and ",(0,a.jsx)(n.code,{children:"afterEach"})," can handle asynchronous code in the same ways that ",(0,a.jsx)(n.a,{href:"asynchronous",children:"tests can handle asynchronous code"})," - they can either take a ",(0,a.jsx)(n.code,{children:"done"})," parameter or return a promise. For example, if ",(0,a.jsx)(n.code,{children:"initializeCityDatabase()"})," returned a promise that resolved when the database was initialized, we would want to return that promise:"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"beforeEach(function()\n\treturn initializeCityDatabase()\nend)\n"})}),"\n",(0,a.jsx)(n.h2,{id:"one-time-setup",children:"One-Time Setup"}),"\n",(0,a.jsxs)(n.p,{children:["In some cases, you only need to do setup once, at the beginning of a file. This can be especially bothersome when the setup is asynchronous, so you can't do it inline. Jest provides ",(0,a.jsx)(n.code,{children:"beforeAll"})," and ",(0,a.jsx)(n.code,{children:"afterAll"})," hooks to handle this situation."]}),"\n",(0,a.jsxs)(n.p,{children:["For example, if both ",(0,a.jsx)(n.code,{children:"initializeCityDatabase()"})," and ",(0,a.jsx)(n.code,{children:"clearCityDatabase()"})," returned promises, and the city database could be reused between tests, we could change our test code to:"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"beforeAll(function()\n\treturn initializeCityDatabase()\nend)\n\nafterAll(function()\n\treturn clearCityDatabase()\nend)\n\ntest('city database has Vienna', function()\n\texpect(isCity('Vienna')).toBeTruthy()\nend)\n\ntest('city database has San Juan', function()\n\texpect(isCity('San Juan')).toBeTruthy()\nend)\n"})}),"\n",(0,a.jsx)(n.h2,{id:"scoping",children:"Scoping"}),"\n",(0,a.jsxs)(n.p,{children:["By default, the ",(0,a.jsx)(n.code,{children:"beforeAll"})," and ",(0,a.jsx)(n.code,{children:"afterAll"})," blocks apply to every test in a file. You can also group tests together using a ",(0,a.jsx)(n.code,{children:"describe"})," block. When they are inside a ",(0,a.jsx)(n.code,{children:"describe"})," block, the ",(0,a.jsx)(n.code,{children:"beforeAll"})," and ",(0,a.jsx)(n.code,{children:"afterAll"})," blocks only apply to the tests within that ",(0,a.jsx)(n.code,{children:"describe"})," block."]}),"\n",(0,a.jsx)(n.p,{children:"For example, let's say we had not just a city database, but also a food database. We could do different setup for different tests:"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"-- Applies to all tests in this file\nbeforeEach(function()\n\treturn initializeCityDatabase()\nend)\n\ntest('city database has Vienna', function()\n\texpect(isCity('Vienna')).toBeTruthy()\nend)\n\ntest('city database has San Juan', function()\n\texpect(isCity('San Juan')).toBeTruthy()\nend)\n\ndescribe('matching cities to foods', function()\n\t-- Applies only to tests in this describe block\n\tbeforeEach(function()\n\t\treturn initializeFoodDatabase()\n\tend)\n\n\ttest('Vienna <3 veal', function()\n\t\texpect(isValidCityFoodPair('Vienna', 'Wiener Schnitzel')).toBe(true)\n\tend)\n\ttest('San Juan <3 plantains', function()\n\t\texpect(isValidCityFoodPair('San Juan', 'Mofongo')).toBe(true)\n\tend)\nend)\n"})}),"\n",(0,a.jsxs)(n.p,{children:["Note that the top-level ",(0,a.jsx)(n.code,{children:"beforeEach"})," is executed before the ",(0,a.jsx)(n.code,{children:"beforeEach"})," inside the ",(0,a.jsx)(n.code,{children:"describe"})," block. It may help to illustrate the order of execution of all hooks."]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"beforeAll(function() print('1 - beforeAll') end)\nafterAll(function() print('1 - afterAll') end)\nbeforeEach(function() print('1 - beforeEach') end)\nafterEach(function() print('1 - afterEach') end)\n\ntest('', function()\n\tprint('1 - test')\nend)\n\ndescribe('Scoped / Nested block', function()\n\tbeforeAll(function() print('2 - beforeAll') end)\n\tafterAll(function() print('2 - afterAll') end)\n\tbeforeEach(function() print('2 - beforeEach') end)\n\tafterEach(function() print('2 - afterEach') end)\n\n\ttest('', function()\n\t\tprint('2 - test')\n\tend)\nend)\n\n-- 1 - beforeAll\n-- 1 - beforeEach\n-- 1 - test\n-- 1 - afterEach\n-- 2 - beforeAll\n-- 1 - beforeEach\n-- 2 - beforeEach\n-- 2 - test\n-- 2 - afterEach\n-- 1 - afterEach\n-- 2 - afterAll\n-- 1 - afterAll\n"})}),"\n",(0,a.jsx)(n.h2,{id:"order-of-execution",children:"Order of Execution"}),"\n",(0,a.jsxs)(n.p,{children:["Jest Lua executes all describe handlers in a test file ",(0,a.jsx)(n.em,{children:"before"})," it executes any of the actual tests. This is another reason to do setup and teardown inside ",(0,a.jsx)(n.code,{children:"before*"})," and ",(0,a.jsx)(n.code,{children:"after*"})," handlers rather than inside the ",(0,a.jsx)(n.code,{children:"describe"})," blocks. Once the ",(0,a.jsx)(n.code,{children:"describe"})," blocks are complete, by default Jest Lua runs all the tests serially in the order they were encountered in the collection phase, waiting for each to finish and be tidied up before moving on."]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"describe('describe outer', function()\n\tprint('describe outer-a')\n\n\tdescribe('describe inner 1', function()\n\t\tprint('describe inner 1')\n\n\t\ttest('test 1', function()\n\t\t\tprint('test 1')\n\t\tend)\n\tend)\n\n\tprint('describe outer-b')\n\n\ttest('test 2', function()\n\t\tprint('test 2')\n\tend)\n\n\tdescribe('describe inner 2', function()\n\t\tprint('describe inner 2')\n\n\t\ttest('test 3', function()\n\t\t\tprint('test 3')\n\t\tend)\n\tend)\n\n\tprint('describe outer-c')\nend)\n\n-- describe outer-a\n-- describe inner 1\n-- describe outer-b\n-- describe inner 2\n-- describe outer-c\n-- test 1\n-- test 2\n-- test 3\n"})}),"\n",(0,a.jsxs)(n.p,{children:["Just like the ",(0,a.jsx)(n.code,{children:"describe"})," and ",(0,a.jsx)(n.code,{children:"test"})," blocks Jest Lua calls the ",(0,a.jsx)(n.code,{children:"before*"})," and ",(0,a.jsx)(n.code,{children:"after*"})," hooks in the order of declaration. Note that the ",(0,a.jsx)(n.code,{children:"after*"})," hooks of the enclosing scope are called first. For example, here is how you can set up and tear down resources which depend on each other:"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"beforeEach(function() print('connection setup') end)\nbeforeEach(function() print('database setup') end)\n\nafterEach(function() print('database teardown') end)\nafterEach(function() print('connection teardown') end)\n\ntest('test 1', function()\n\tprint('test 1')\nend)\n\ndescribe('extra', function()\n\tbeforeEach(function() print('extra database setup') end)\n\n\tafterEach(function() print('extra database teardown') end)\n\n\ttest('test 2', function()\n\t\tprint('test 2')\n\tend)\nend)\n\n-- connection setup\n-- database setup\n-- test 1\n-- database teardown\n-- connection teardown\n\n-- connection setup\n-- database setup\n-- extra database setup\n-- test 2\n-- extra database teardown\n-- database teardown\n-- connection teardown\n"})}),"\n",(0,a.jsx)(n.h2,{id:"general-advice",children:"General Advice"}),"\n",(0,a.jsxs)(n.p,{children:["If a test is failing, one of the first things to check should be whether the test is failing when it's the only test that runs. To run only one test with Jest Lua, temporarily change that ",(0,a.jsx)(n.code,{children:"test"})," command to a ",(0,a.jsx)(n.code,{children:"test.only"}),":"]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"test.only('this will be the only test that runs', function()\n\texpect(true).toBe(false)\nend)\n\ntest('this test will not run', function()\n\texpect('A').toBe('A')\nend)\n"})}),"\n",(0,a.jsxs)(n.p,{children:["If you have a test that often fails when it's run as part of a larger suite, but doesn't fail when you run it alone, it's a good bet that something from a different test is interfering with this one. You can often fix this by clearing some shared state with ",(0,a.jsx)(n.code,{children:"beforeEach"}),". If you're not sure whether some shared state is being modified, you can also try a ",(0,a.jsx)(n.code,{children:"beforeEach"})," that logs data."]})]})}function c(e={}){const{wrapper:n}={...(0,d.R)(),...e.components};return n?(0,a.jsx)(n,{...e,children:(0,a.jsx)(T,{...e})}):T(e)}},8143:(e,n,t)=>{t.d(n,{A:()=>a});const a="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iODciIGhlaWdodD0iMjAiIHJvbGU9ImltZyIgYXJpYS1sYWJlbD0iSmVzdCBEb2NzIj48dGl0bGU+SmVzdCBEb2NzPC90aXRsZT48ZyBzaGFwZS1yZW5kZXJpbmc9ImNyaXNwRWRnZXMiPjxyZWN0IHdpZHRoPSIyNCIgaGVpZ2h0PSIyMCIgZmlsbD0iI2MyMTMyNSIvPjxyZWN0IHg9IjI0IiB3aWR0aD0iNjMiIGhlaWdodD0iMjAiIGZpbGw9IiNjMjEzMjUiLz48L2c+PGcgZmlsbD0iI2ZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZm9udC1mYW1pbHk9IlZlcmRhbmEsR2VuZXZhLERlamFWdSBTYW5zLHNhbnMtc2VyaWYiIHRleHQtcmVuZGVyaW5nPSJnZW9tZXRyaWNQcmVjaXNpb24iIGZvbnQtc2l6ZT0iMTEwIj48aW1hZ2UgeD0iNSIgeT0iMyIgd2lkdGg9IjE0IiBoZWlnaHQ9IjE0IiB4bGluazpocmVmPSJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUJtYVd4c1BTSjNhR2wwWlNJZ2NtOXNaVDBpYVcxbklpQjJhV1YzUW05NFBTSXdJREFnTWpRZ01qUWlJSGh0Ykc1elBTSm9kSFJ3T2k4dmQzZDNMbmN6TG05eVp5OHlNREF3TDNOMlp5SStQSFJwZEd4bFBrcGxjM1E4TDNScGRHeGxQanh3WVhSb0lHUTlJazB5TWk0eU5URWdNVEV1T0RKaE15NHhNVGNnTXk0eE1UY2dNQ0F3SURBdE1pNHpNamd0TXk0d01Vd3lNaTQ1TVRFZ01FZzRMakV3TkV3eE1TNHhJRGd1T0RNNFlUTXVNVEUySURNdU1URTJJREFnTUNBd0xUSXVNalEwSURJdU9UZzRZekFnTVM0d05ETXVOVElnTVM0NU5qY2dNUzR6TVRNZ01pNDFNelpoT0M0eU56a2dPQzR5TnprZ01DQXdJREV0TVM0d09EUWdNUzR5TkRRZ09DNHhOQ0E0TGpFMElEQWdNQ0F4TFRJdU5UVWdNUzQyTkRkakxTNDRNelF0TGpVMk15MHhMakU1TlMweExqVTFOaTB1T0RZNUxUSXVORFEyWVRNdU1URWdNeTR4TVNBd0lEQWdNQzB1T1RFdE5pNHdPQ0F6TGpFeE55QXpMakV4TnlBd0lEQWdNQzB6TGpFeE15QXpMakV4TTJNd0lDNDRORGd1TXpRM0lERXVOakkyTGprd015QXlMakU0TWkwdU1EUTRMakE1TnkwdU1EazNMakU1TlMwdU1UUTJMakk1T1MwdU5EWTFMamsxT1MwdU9Ua3pJREl1TURRekxURXVNVGsxSURNdU1qVTVMUzQwTURNZ01pNDBNekl1TWpVM0lEUXVNemcwSURFdU9EUTVJRFV1TkRnNVFUVXVNRGt6SURVdU1Ea3pJREFnTUNBd0lEVXVPVGs1SURJMFl6RXVPREkzSURBZ015NDJPREl0TGpreE55QTFMalEzTlMweExqZ3dOeUF4TGpJM09TMHVOak15SURJdU5UazVMVEV1TWpreUlETXVPRGs0TFRFdU5qRXlMalE0TFM0eE1UZ3VPVGd0TGpFNE55QXhMalV3T0MwdU1qWTBJREV1TURjdExqRTFNeUF5TGpFM05TMHVNekV5SURNdU1UWTRMUzQ0T1dFMExqUTRNaUEwTGpRNE1pQXdJREFnTUNBeUxqRTRNaTB6TGpBNU1XTXVNVGMwTFM0NU9UUWdNQzB4TGprNU5DMHVORFEwTFRJdU9EY3VNams0TFM0ME9DNDBOalV0TVM0d05ESXVORFkxTFRFdU5qUTNlbTB0TVM0ek5UVWdNR013SUM0NU5qVXRMamM0TlNBeExqYzFMVEV1TnpVZ01TNDNOV0V4TGpjMU15QXhMamMxTXlBd0lEQWdNUzB4TGpBNE5TMHpMakV5Tm13dU1EQTNMUzR3TURkakxqQTFOaTB1TURReUxqRXhPQzB1TURnMExqRTRMUzR4TWpVZ01DQXdJQzR3TURnZ01DQXVNREE0TFM0d01EY3VNREk0TFM0d01UUXVNRFUxTFM0d016VXVNRGd6TFM0d05TNHdNRGNnTUNBdU1ERTBMUzR3TURZdU1ESXhMUzR3TURZdU1ESTRMUzR3TVRRdU1EWXpMUzR3TWpndU1EazNMUzR3TkRJdU1ETTFMUzR3TVRRdU1EY3RMakF5Tnk0d09UZ3RMakEwTVM0d01EY2dNQ0F1TURFekxTNHdNRGN1TURJdExqQXdOeTR3TWpndExqQXdOeTR3TlRZdExqQXlNUzR3T0RRdExqQXlPQzR3TURjZ01DQXVNREl0TGpBd055NHdNamd0TGpBd055NHdNelF0TGpBd055NHdOakl0TGpBeE5DNHdPVGN0TGpBeWFDNHdNRGRzTGpFd05DMHVNREl5WXk0d01EY2dNQ0F1TURJZ01DQXVNREk0TFM0d01EY3VNREk0SURBZ0xqQTFOUzB1TURBM0xqQTRNeTB1TURBM2FDNHdNelZqTGpBek5TQXdJQzR3TnkwdU1EQTNMakV4TVMwdU1EQTNhQzR3T1dNdU1ESTRJREFnTGpBMUlEQWdMakEzTnk0d01EZG9MakF4TkdNdU1EVTFMakF3Tnk0eE1URXVNREUwTGpFMk55NHdNamhoTVM0M05qWWdNUzQzTmpZZ01DQXdJREVnTVM0ek9UWWdNUzQzTWpONlRURXdMakEwTXlBeExqTTVhREV3TGpremJDMHlMalV3T1NBM0xqUmpMUzR4TURRdU1ESXRMakl3T0M0d05UVXRMak14TWk0d09Xd3RNaTQyTkMwMUxqTTROUzB5TGpZME9DQTFMak0xWXkwdU1UQTBMUzR3TXpRdExqSXhOaTB1TURVMUxTNHpNamN0TGpBM05td3RNaTQwT1RRdE55NHpPSHB0TkM0NU5qZ2dPUzQ0TWpWaE15NHdPRE1nTXk0d09ETWdNQ0F3SURBdExqa3pPQzB4TGpZMk9Hd3hMalF6T0MweUxqa3dOQ0F4TGpRMU1pQXlMamsyTjJNdExqUXpMalF6TFM0M05ETXVPVGd0TGpnMk9DQXhMall3TlVneE5TNHdNWHB0TFRNdU5EZ3hMVEV1TURrNFl5NHdNelF0TGpBd055NHdOakl0TGpBeE5DNHdPVGN0TGpBeWFDNHdNbU11TURJNUxTNHdNRGd1TURVMkxTNHdNRGd1TURnMExTNHdNVFZvTGpBeU9HTXVNREk0SURBZ0xqQTBPUzB1TURBM0xqQTNOaTB1TURBM2FDNHlOekZqTGpBeU9DQXdJQzR3TkRrdU1EQTNMakEzTGpBd055NHdNVFFnTUNBdU1ESWdNQ0F1TURNMUxqQXdOeTR3TWpjdU1EQTNMakEwT0M0d01EY3VNRGMyTGpBeE5DNHdNRGNnTUNBdU1ERTBJREFnTGpBeU9DNHdNRGRzTGpBNU55NHdNbWd1TURBM1l5NHdNamd1TURBNExqQTFOaTR3TVRVdU1EZ3pMakF5T1M0d01EY2dNQ0F1TURFMExqQXdOeTR3TWpndU1EQTNMakF5TVM0d01EY3VNRFE1TGpBeE5DNHdOeTR3TWpjdU1EQTNJREFnTGpBeE5DNHdNRGN1TURJdU1EQTNMakF5T0M0d01UUXVNRFUyTGpBeU1TNHdPRFF1TURNMWFDNHdNRGRoTGpNM05DNHpOelFnTUNBd0lERWdMakE1TGpBME9XZ3VNREEzWXk0d01qZ3VNREUwTGpBMU5pNHdNelF1TURnMExqQTBPQzR3TURjZ01DQXVNREEzTGpBd055NHdNVE11TURBM0xqQXlPQzR3TVRRdU1EVXVNRE0xTGpBM055NHdORGxzTGpBd055NHdNRGRqTGpBNE15NHdOakl1TVRZdU1UTXlMakl6Tmk0eU1ERnNMakF3Tnk0d01EZGhNUzQzTkRjZ01TNDNORGNnTUNBd0lERWdMalE0SURFdU1qQTVJREV1TnpVeUlERXVOelV5SURBZ01DQXhMVE11TlRBeUlEQWdNUzQzTkRJZ01TNDNORElnTUNBd0lERWdNUzR6TWkweExqWTVOWHB0TFRZdU9ETTRMUzR3TkRsakxqazJOaUF3SURFdU56VXhMamM0TmlBeExqYzFNU0F4TGpjMU1YTXRMamM0TlNBeExqYzFNUzB4TGpjMUlERXVOelV4TFRFdU56VXlMUzQzT0RVdE1TNDNOVEl0TVM0M05TNDNPRFl0TVM0M05USWdNUzQzTlRFdE1TNDNOVEo2YlRFMkxqRTJNeUEyTGpBeU5XRXpMakEzSURNdU1EY2dNQ0F3SURFdE1TNDFNRGdnTWk0eE16TmpMUzQzTlRndU5ETTRMVEV1TmpnNUxqVTNOeTB5TGpZMk9TNDNNVFpoTVRjdU1qa2dNVGN1TWprZ01DQXdJREF0TVM0Mk5DNHlPVEZqTFRFdU5EUTFMak0xTlMweUxqZ3pOQ0F4TGpBMUxUUXVNVGd5SURFdU56RTNMVEV1TnpJMExqZzFOQzB6TGpNMUlERXVOall0TkM0NE5UY2dNUzQyTm1FekxqWTBOU0F6TGpZME5TQXdJREFnTVMweUxqRTFOQzB1TmpnNFl5MHhMalV5T1MweExqQTFOaTB4TGpRMU15MHpMakF6TmkweExqSTNNaTAwTGpFeUxqRTJOeTB4TGpBeE5TNDJNekl0TVM0NU5qWWdNUzR3TnpjdE1pNDROemN1TURJNExTNHdOVFV1TURRNUxTNHhNRFF1TURjM0xTNHhOaTR4TlRJdU1EVTJMak14TWk0d09UZ3VORGM1TGpFeU5pMHVNalkwSURFdU5EY3pMalE0TmlBeUxqazVOQ0F4TGprME5pQXpMamMwTld3dU1qWTBMakV6T1M0eU9EUXRMakV3TkdNeExqSXhOaTB1TkRNeElESXVNelF5TFRFdU1UTXpJRE11TXpNMkxUSXVNRGN4WVRrdU16TTBJRGt1TXpNMElEQWdNQ0F3SURFdU5EUTFMVEV1TnpFMll5NHhOaTR3TWpjdU16SXVNRE0wTGpRNExqQXpOR0V6TGpFeE55QXpMakV4TnlBd0lEQWdNQ0F6TGpBd09DMHlMak15TjJneExqRTJOMkV6TGpFd09TQXpMakV3T1NBd0lEQWdNQ0F6TGpBeElESXVNekkzWXk0MU56WWdNQ0F4TGpFeExTNHhOaUF4TGpVM0xTNDBNeTR4T0M0MU1pNHlNellnTVM0d05qTXVNVE01SURFdU5qQTFlaUl2UGp3dmMzWm5QZz09Ii8+PHRleHQgeD0iNTQ1IiB5PSIxNDAiIHRyYW5zZm9ybT0ic2NhbGUoLjEpIiBmaWxsPSIjZmZmIiB0ZXh0TGVuZ3RoPSI1MzAiPkplc3QgRG9jczwvdGV4dD48L2c+PC9zdmc+"},8453:(e,n,t)=>{t.d(n,{R:()=>s,x:()=>o});var a=t(6540);const d={},i=a.createContext(d);function s(e){const n=a.useContext(i);return a.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(d):e.components||d:s(e.components),a.createElement(i.Provider,{value:n},e.children)}}}]);