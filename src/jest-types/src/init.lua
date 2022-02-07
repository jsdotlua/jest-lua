-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-types/src/index.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]
local CircusModule = require(script.Circus)
export type BlockMode = CircusModule.BlockMode
export type TestMode = CircusModule.TestMode
export type AsyncFn = CircusModule.AsyncFn
export type SharedHookType = CircusModule.SharedHookType
export type HookType = CircusModule.HookType
export type Exception = CircusModule.Exception
export type FormattedError = CircusModule.FormattedError
export type Hook = CircusModule.Hook
export type EventHandler = CircusModule.EventHandler
export type Event = CircusModule.Event
export type SyncEvent = CircusModule.SyncEvent
export type AsyncEvent = CircusModule.AsyncEvent
export type MatcherResults = CircusModule.MatcherResults
export type TestStatus = CircusModule.TestStatus
export type TestResult = CircusModule.TestResult
export type RunResult = CircusModule.RunResult
export type TestResults = CircusModule.TestResults
export type GlobalErrorHandlers = CircusModule.GlobalErrorHandlers
export type State = CircusModule.State
export type DescribeBlock = CircusModule.DescribeBlock
export type TestError = CircusModule.TestError
export type TestEntry = CircusModule.TestEntry

local ConfigModule = require(script.Config)
export type Path = ConfigModule.Path
export type Glob = ConfigModule.Glob
export type HasteConfig = ConfigModule.HasteConfig
export type CoverageReporterName = ConfigModule.CoverageReporterName
export type CoverageReporterWithOptions<K> = ConfigModule.CoverageReporterWithOptions<K>
export type CoverageReporters = ConfigModule.CoverageReporters
export type ReporterConfig = ConfigModule.ReporterConfig
export type TransformerConfig = ConfigModule.TransformerConfig
export type ConfigGlobals = ConfigModule.ConfigGlobals
export type PrettyFormatOptions = ConfigModule.PrettyFormatOptions
export type DefaultOptions = ConfigModule.DefaultOptions
export type DisplayName = ConfigModule.DisplayName
export type InitialOptionsWithRootDir = ConfigModule.InitialOptionsWithRootDir
export type InitialProjectOptions = ConfigModule.InitialProjectOptions
export type InitialOptions = ConfigModule.InitialOptions
export type SnapshotUpdateState = ConfigModule.SnapshotUpdateState
export type CoverageThresholdValue = ConfigModule.CoverageThresholdValue
export type GlobalConfig = ConfigModule.GlobalConfig
export type ProjectConfig = ConfigModule.ProjectConfig
export type Argv = ConfigModule.Argv

local GlobalModule = require(script.Global)
export type ValidTestReturnValues = GlobalModule.ValidTestReturnValues
export type TestReturnValue = GlobalModule.TestReturnValue
export type TestContext = GlobalModule.TestContext
export type DoneFn = GlobalModule.DoneFn
export type DoneTakingTestFn = GlobalModule.DoneTakingTestFn
export type PromiseReturningTestFn = GlobalModule.PromiseReturningTestFn
export type GeneratorReturningTestFn = GlobalModule.GeneratorReturningTestFn
export type TestName = GlobalModule.TestName
export type TestFn = GlobalModule.TestFn
export type ConcurrentTestFn = GlobalModule.ConcurrentTestFn
export type BlockFn = GlobalModule.BlockFn
export type BlockName = GlobalModule.BlockName
export type HookFn = GlobalModule.HookFn
export type Col = GlobalModule.Col
export type Row = GlobalModule.Row
export type Table = GlobalModule.Table
export type ArrayTable = GlobalModule.ArrayTable
export type TemplateTable = GlobalModule.TemplateTable
export type TemplateData = GlobalModule.TemplateData
export type EachTable = GlobalModule.EachTable
export type TestCallback = GlobalModule.TestCallback
export type EachTestFn<EachCallback> = GlobalModule.EachTestFn<EachCallback>
export type HookBase = GlobalModule.HookBase
export type ItBase = GlobalModule.ItBase
export type It = GlobalModule.It
export type ItConcurrentBase = GlobalModule.ItConcurrentBase
export type ItConcurrentExtended = GlobalModule.ItConcurrentExtended
export type ItConcurrent = GlobalModule.ItConcurrent
export type DescribeBase = GlobalModule.DescribeBase
export type Describe = GlobalModule.Describe
export type TestFrameworkGlobals = GlobalModule.TestFrameworkGlobals
export type GlobalAdditions = GlobalModule.GlobalAdditions
export type Global = GlobalModule.Global

local TestResultModule = require(script.TestResult)
export type Milliseconds = TestResultModule.Milliseconds
export type AssertionResult = TestResultModule.AssertionResult
export type SerializableError = TestResultModule.SerializableError

local TransformModule = require(script.Transform)
export type TransformResult = TransformModule.TransformResult

return {}
