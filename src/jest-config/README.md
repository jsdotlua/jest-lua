# jest-config

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-config

Version: v27.4.7

---

### :pencil2: Notes

* since Lua projects don't store external modules in `node_modules` directory `testPathIgnorePatterns` will not include this directory by default
* running tests concurrently is not supported at the moment

#### Todo

- [ ] support for `globalSetup` and `globalTeardown` options
- [ ] support for `coverageReporters` option

#### API deviation

* `projects` option needs to receive a list of `Instance` objects
*  `rootDir` options needs to receive an `Instance`

#### Unsupported global [config options](https://jestjs.io/docs/configuration)

* `changedFilesWithAncestor`
* `collectCoverage`
* `collectCoverageFrom`
* `collectCoverageOnlyFrom`
* `coverageDirectory`
* `coveragePathIgnorePatterns`
* `coverageProvider`
* `coverageReporters`
* `coverageThreshold`
* `detectLeaks`
* `detectOpenHandles`
* `findRelatedTests`
* `forceExit`
* `globalTeardown`
* `lastCommit`
* `logHeapUsage`
* `noSCM`
* `notifyMode`
* `onlyChanged`
* `onlyFailures`
* `replname`
* `reporters`
* `snapshotFormat`
* `errorOnDeprecated`
* `testResultsProcessor`
* `testSequencer`
* `useStderr`
* `watch`
* `watchAll`
* `watchman`
* `watchPlugins`

#### Unsupported global [config options](https://jestjs.io/docs/configuration)

* `cache`
* `cacheDirectory`
* `coveragePathIgnorePatterns`
* `cwd`
* `dependencyExtractor`
* `detectLeaks`
* `detectOpenHandles`
* `errorOnDeprecated`
* `extensionsToTreatAsEsm`
* `extraGlobals`
* `forceCoverageMatch`
* `globalSetup`
* `globalTeardown`
* `globals`
* `haste`
* `moduleDirectories`
* `moduleFileExtensions`
* `moduleLoader`
* `moduleNameMapper`
* `modulePathIgnorePatterns`
* `modulePaths`
* `prettierPath`
* `resolver`
* `setupFiles`
* `setupFilesAfterEnv`
* `skipNodeResolution`
* `snapshotResolver`
* `snapshotFormat`
* `testRunner`
* `testURL`
* `transform`
* `transformIgnorePatterns`
* `watchPathIgnorePatterns`
* `unmockedModulePathPatterns`

#### Unsupported CLI [options](https://jestjs.io/docs/cli)

* `cache`
* `cacheDirectory`
* `changedFilesWithAncestor`
* `collectCoverage`
* `collectCoverageFrom`
* `collectCoverageOnlyFrom`
* `coverageDirectory`
* `coveragePathIgnorePatterns`
* `coverageReporters`
* `coverageThreshold`
* `findRelatedTests`
* `forceExit`
* `globalSetup`
* `globalTeardown`
* `haste`
* `lastCommit`
* `logHeapUsage`
* `moduleFileExtensions`
* `moduleNameMapper`
* `modulePathIgnorePatterns`
* `modulePaths`
* `notifyMode`
* `onlyChanged`
* `onlyFailures`
* `prettierPath`
* `resolver`
* `setupFiles`
* `setupFilesAfterEnv`
* `testResultsProcessor`
* `testRunner`
* `testSequencer`
* `testURL`
* `transform`
* `transformIgnorePatterns`
* `unmockedModulePathPatterns`
* `useStderr`
* `watch`
* `watchAll`
* `watchman`
* `watchPathIgnorePatterns`

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/package.json)
| Package | Version | Status | Notes |
| ------- | ------- | ------ | ----- |
