--!nocheck
return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent

	local jestExpect = require(Modules.Expect)

	local Jest = require(Modules.Jest)
	local jest = Jest.jest
	local timers = Jest._fakeTimers

	afterEach(function()
		timers:useRealTimers()
	end)

	describe('FakeTimers', function()
		describe('construction', function()
			it('installs delay mock', function()
				jestExpect(delay).never.toBeNil()
			end)

			it('installs tick mock', function()
				jestExpect(tick).never.toBeNil()
			end)
		end)

		describe('runAllTimers', function()
			it('runs all timers in order', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)
				local mock5 = jest:fn(function() table.insert(runOrder, 'mock5') end)
				local mock6 = jest:fn(function() table.insert(runOrder, 'mock6') end)

				delay(100, mock1)
				delay(0, mock2)
				delay(0, mock3)
				delay(200, mock4)
				delay(3, mock5)
				delay(4, mock6)
				timers:runAllTimers()
				jestExpect(os.clock()).toEqual(200)
				jestExpect(runOrder).toEqual({
					'mock2',
					'mock3',
					'mock5',
					'mock6',
					'mock1',
					'mock4',
				})
			end)

			it('warns when trying to advance timers while real timers are used', function()
				jestExpect(function() timers:runAllTimers() end).toThrow(
					"A function to advance timers was called but the timers API is not " ..
					"mocked with fake timers. Call `jest.useFakeTimers()` in this test."
				)
			end)

			it('does nothing when no timers have been scheduled', function()
				timers:useFakeTimers()

				jestExpect(os.clock()).toEqual(0)
				timers:runAllTimers()
			end)

			it('only runs a delay callback once (ever)', function()
				timers:useFakeTimers()

				local fn = jest:fn()
				delay(0, fn)
				jestExpect(fn).toHaveBeenCalledTimes(0)

				timers:runAllTimers()
				jestExpect(fn).toHaveBeenCalledTimes(1)

				timers:runAllTimers()
				jestExpect(fn).toHaveBeenCalledTimes(1)
			end)

			it('runs callbacks with arguments after the interval', function()
				timers:useFakeTimers()

				local fn = jest:fn()
				delay(0, function() fn('mockArg1', 'mockArg2') end)

				timers:runAllTimers()
				jestExpect(fn).toHaveBeenCalledTimes(1)
				jestExpect(fn).toHaveBeenCalledWith('mockArg1', 'mockArg2')
			end)
		end)

		describe('advanceTimersByTime', function()
			it('runs timers in order', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)

				delay(100, mock1)
				delay(0, mock2)
				delay(0, mock3)
				delay(200, mock4)

				-- Move forward to t=50
				timers:advanceTimersByTime(50)
				jestExpect(os.clock()).toEqual(50)
				jestExpect(runOrder).toEqual({'mock2', 'mock3'})

				-- Move forward to t=60
				timers:advanceTimersByTime(10)
				jestExpect(os.clock()).toEqual(60)
				jestExpect(runOrder).toEqual({'mock2', 'mock3'})

				-- Move forward to t=100
				timers:advanceTimersByTime(40)
				jestExpect(os.clock()).toEqual(100)
				jestExpect(runOrder).toEqual({'mock2', 'mock3', 'mock1'})

				-- Move forward to t=200
				timers:advanceTimersByTime(100)
				jestExpect(os.clock()).toEqual(200)
				jestExpect(runOrder).toEqual({'mock2', 'mock3', 'mock1', 'mock4'})
			end)

			it('does nothing when no timers have been scheduled', function()
				timers:useFakeTimers()
				timers:advanceTimersByTime(100)
			end)
		end)

		describe('advanceTimersToNextTimer', function()
			it('runs timers in order', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)

				delay(100, mock1)
				delay(0, mock2)
				delay(0, mock3)
				delay(200, mock4)

				timers:advanceTimersToNextTimer()
				-- Move forward to t=0
				jestExpect(os.clock()).toEqual(0)
				jestExpect(runOrder).toEqual({'mock2', 'mock3'})

				timers:advanceTimersToNextTimer()
				-- Move forward to t=100
				jestExpect(os.clock()).toEqual(100)
				jestExpect(runOrder).toEqual({'mock2', 'mock3', 'mock1'})

				timers:advanceTimersToNextTimer()
				-- Move forward to t=200
				jestExpect(os.clock()).toEqual(200)
				jestExpect(runOrder).toEqual({'mock2', 'mock3', 'mock1', 'mock4'})
			end)

			it('run correct amount of steps', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)

				delay(100, mock1)
				delay(0, mock2)
				delay(0, mock3)
				delay(200, mock4)
				delay(400, mock4)
				delay(600, mock4)

				-- Move forward to t=100
				timers:advanceTimersToNextTimer(2)
				jestExpect(os.clock()).toEqual(100)
				jestExpect(runOrder).toEqual({'mock2', 'mock3', 'mock1'})

				-- Move forward to t=600
				timers:advanceTimersToNextTimer(3)
				jestExpect(os.clock()).toEqual(600)
				jestExpect(runOrder).toEqual({
					'mock2',
					'mock3',
					'mock1',
					'mock4',
					'mock4',
					'mock4',
				})
			end)

			it('setTimeout inside setTimeout', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)

				delay(0, mock1)
				delay(25, function()
					mock2()
					delay(50, mock3)
				end)
				delay(100, mock4)

				-- Move forward to t=75
				timers:advanceTimersToNextTimer(3)
				jestExpect(os.clock()).toEqual(75)
				jestExpect(runOrder).toEqual({'mock1', 'mock2', 'mock3'})
			end)

			it('does nothing when no timers have been scheduled', function()
				timers:useFakeTimers()
				timers:advanceTimersToNextTimer()
			end)
		end)

		describe('reset', function()
			it('resets all pending timers', function()
				timers:useFakeTimers()

				local mock1 = jest:fn()
				delay(0, mock1)

				timers:reset()
				timers:runAllTimers()
				jestExpect(mock1).toHaveBeenCalledTimes(0)
			end)

			it('resets current advanceTimersByTime time cursor', function()
				timers:useFakeTimers()

				local mock1 = jest:fn()
				delay(100, mock1)
				timers:advanceTimersByTime(50)
				jestExpect(os.clock()).toEqual(50)

				timers:reset()
				jestExpect(os.clock()).toEqual(0)
				delay(100, mock1)

				timers:advanceTimersByTime(50)
				jestExpect(os.clock()).toEqual(50)
				jestExpect(mock1).toHaveBeenCalledTimes(0)
			end)
		end)

		describe('runOnlyPendingTimers', function()
			it('runs all timers in order', function()
				timers:useFakeTimers()

				local runOrder = {}
				local mock1 = jest:fn(function() table.insert(runOrder, 'mock1') end)
				local mock2 = jest:fn(function() table.insert(runOrder, 'mock2') end)
				local mock3 = jest:fn(function() table.insert(runOrder, 'mock3') end)
				local mock4 = jest:fn(function() table.insert(runOrder, 'mock4') end)
				local mock5 = jest:fn(function() table.insert(runOrder, 'mock5') end)
				local mock6 = jest:fn(function() table.insert(runOrder, 'mock6') end)

				delay(100, mock1)
				delay(0, mock2)
				delay(0, mock3)
				delay(200, mock4)
				delay(3, mock5)
				delay(4, mock6)
				timers:runOnlyPendingTimers()
				jestExpect(os.clock()).toEqual(200)
				jestExpect(runOrder).toEqual({
					'mock2',
					'mock3',
					'mock5',
					'mock6',
					'mock1',
					'mock4',
				})
			end)
		end)

		describe('useRealTimers, useFakeTimers', function()
			it('resets native timer APIs', function()
				local nativeDelay = delay.getMockImplementation()
				local nativeTick = tick.getMockImplementation()

				timers:useFakeTimers()
				local fakeDelay = delay.getMockImplementation()
				local fakeTick = tick.getMockImplementation()
				jestExpect(fakeDelay).never.toBe(nativeDelay)
				jestExpect(fakeTick).never.toBe(nativeTick)

				timers:useRealTimers()
				local realDelay = delay.getMockImplementation()
				local realTick = tick.getMockImplementation()
				jestExpect(realDelay).toBe(nativeDelay)
				jestExpect(realTick).toBe(nativeTick)
			end)
		end)

		describe('getTimerCount', function()
			it('returns the correct count', function()
				timers:useFakeTimers()

				delay(0, function() end)
				delay(0, function() end)
				delay(10, function() end)

				jestExpect(timers:getTimerCount()).toEqual(3)

				timers:advanceTimersByTime(5)

				jestExpect(timers:getTimerCount()).toEqual(1)

				timers:advanceTimersByTime(5)

				jestExpect(timers:getTimerCount()).toEqual(0)
			end)
		end)
	end)

	describe('DateTime', function()
		describe('construction', function()
			it('installs DateTime mock', function()
				jestExpect(DateTime).never.toBeNil()
				jestExpect(DateTime.now()).never.toBeNil()
			end)

			it('DateTime constructors pass through', function()
				timers:useFakeTimers()

				jestExpect(DateTime.now()).never.toBeNil()
				jestExpect(DateTime.fromUnixTimestamp()).never.toBeNil()
				jestExpect(DateTime.fromUnixTimestampMillis()).never.toBeNil()
				jestExpect(DateTime.fromUniversalTime()).never.toBeNil()
				jestExpect(DateTime.fromLocalTime()).never.toBeNil()
				jestExpect(DateTime.fromIsoDate('2020-01-02T10:30:45Z')).never.toBeNil()
			end)
		end)

		it('affected by timers', function()
			timers:useFakeTimers()

			local time_ = DateTime.now().UnixTimestamp
			timers:advanceTimersByTime(100)
			jestExpect(DateTime.now().UnixTimestamp).toEqual(time_ + 100)
		end)

		describe('setSystemTime', function()
			it('UnixTimestamp', function()
				timers:useFakeTimers()

				timers:setSystemTime(0)
				jestExpect(DateTime.now()).toEqual(DateTime.fromUnixTimestamp(0))
			end)

			it('DateTime object', function()
				timers:useFakeTimers()

				timers:setSystemTime(DateTime.fromUniversalTime(1971))
				jestExpect(DateTime.now()).toEqual(DateTime.fromUniversalTime(1971))
			end)
		end)

		describe('getRealSystemTime', function()
			it('returns real system time', function()
				timers:useFakeTimers()

				timers:setSystemTime(0)
				jestExpect(DateTime.now()).never.toEqual(timers:getRealSystemTime())
			end)
		end)

		describe('useRealTimers, useFakeTimers', function()
			it('resets native timer APIs', function()
				local nativeDateTime = DateTime.now.getMockImplementation()

				timers:useFakeTimers()
				local fakeDateTime = DateTime.now.getMockImplementation()
				jestExpect(fakeDateTime).never.toBe(nativeDateTime)

				timers:useRealTimers()
				local realDateTime = DateTime.now.getMockImplementation()
				jestExpect(realDateTime).toBe(nativeDateTime)
			end)
		end)

		describe('reset', function()
			it('resets system time', function()
				timers:useFakeTimers()

				timers:setSystemTime(0)
				local fakeTime = DateTime.now()
				jestExpect(DateTime.now()).toEqual(fakeTime)

				timers:reset()
				jestExpect(DateTime.now()).never.toEqual(fakeTime)
			end)
		end)
	end)

	describe('os', function()
		describe('construction', function()
			it('installs os mock', function()
				jestExpect(os).never.toBeNil()
				jestExpect(os.time).never.toBeNil()
				jestExpect(os.clock).never.toBeNil()
			end)

			it('os methods pass through', function()
				timers:useFakeTimers()

				jestExpect(os.difftime(2, 1)).toBe(1)
				jestExpect(os.date).never.toBeNil()
			end)
		end)

		describe('os.time', function()
			it('returns correct value', function()
				timers:useFakeTimers()

				timers:setSystemTime(1586982482)
				jestExpect(os.time()).toBe(1586982482)
			end)

			it('returns correct value when passing in table', function()
				timers:useFakeTimers()

				timers:setSystemTime(100)
				jestExpect(os.time({
					year=1970, month=1, day=1,
					hour=0, min=0, sec=0
				})).toBe(100)
			end)

			it('affected by timers', function()
				timers:useFakeTimers()

				local time_ = os.time()
				timers:advanceTimersByTime(100)
				jestExpect(os.time()).toBe(time_ + 100)
			end)
		end)

		describe('os.clock', function()
			it('affected by timers', function()
				timers:useFakeTimers()

				jestExpect(os.clock()).toBe(0)
				timers:advanceTimersByTime(100)
				jestExpect(os.clock()).toBe(100)
			end)
		end)

		describe('useRealTimers, useFakeTimers', function()
			it('resets native timer APIs', function()
				local nativeOsTime = os.time.getMockImplementation()
				local nativeOsClock = os.clock.getMockImplementation()

				timers:useFakeTimers()
				local fakeOsTime = os.time.getMockImplementation()
				local fakeOsClock = os.clock.getMockImplementation()
				jestExpect(fakeOsTime).never.toBe(nativeOsTime)
				jestExpect(fakeOsClock).never.toBe(nativeOsClock)

				timers:useRealTimers()
				local realOsTime = os.time.getMockImplementation()
				local realOsClock = os.clock.getMockImplementation()
				jestExpect(realOsTime).toBe(nativeOsTime)
				jestExpect(realOsClock).toBe(nativeOsClock)
			end)
		end)

		describe('reset', function()
			it('resets system time', function()
				timers:useFakeTimers()

				timers:setSystemTime(0)
				local fakeTime = os.time()
				jestExpect(os.time()).toEqual(fakeTime)

				timers:reset()
				jestExpect(os.time()).never.toEqual(fakeTime)
			end)
		end)
	end)

	describe('tick', function()
		it('returns UNIX time', function()
			timers:useFakeTimers()

			timers:setSystemTime(100)
			jestExpect(tick()).toBe(100)
		end)

		it('affected by timers', function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			timers:advanceTimersByTime(100)

			jestExpect(tick()).toBe(100)
		end)
	end)

	it('spies', function()
		timers:useFakeTimers()

		local mock1 = jest:fn()
		local mock2 = jest:fn()
		local mock3 = jest:fn()

		jestExpect(delay).never.toHaveBeenCalled()

		delay(0, mock1)
		delay(25, function()
			mock2()
			delay(50, mock3)
			tick()
			DateTime.now()
		end)

		jestExpect(delay).toHaveBeenCalledTimes(2)
		jestExpect(tick).never.toHaveBeenCalled()
		jestExpect(DateTime.now).never.toHaveBeenCalled()

		timers:runAllTimers()
		jestExpect(delay).toHaveBeenCalledTimes(3)
		jestExpect(tick).toHaveBeenCalledTimes(1)
		jestExpect(delay).toHaveBeenLastCalledWith(50, mock3)
		jestExpect(DateTime.now).toHaveBeenCalledTimes(1)
	end)

	describe('recursive timer', function()
		it('runAllTimers', function()
			timers:useFakeTimers()

			local loop = 5

			local loopFn = function() end
			loopFn = function()
				if loop > 0 then
					loop = loop - 1
					delay(10, loopFn)
				end
			end

			delay(0, loopFn)
			jestExpect(delay).toHaveBeenCalledTimes(1)

			timers:runAllTimers()
			jestExpect(delay).toHaveBeenCalledTimes(6)
		end)

		it('runOnlyPendingTimers', function()
			timers:useFakeTimers()

			local loopFn = function() end
			loopFn = function()
				delay(10, loopFn)
			end

			local mockFn = jest:fn()

			delay(0, loopFn)
			delay(0, mockFn)
			delay(100, mockFn)
			jestExpect(delay).toHaveBeenCalledTimes(3)
			jestExpect(timers:getTimerCount()).toBe(3)
			jestExpect(mockFn).toHaveBeenCalledTimes(0)
			jestExpect(os.clock()).toBe(0)

			timers:runOnlyPendingTimers()
			jestExpect(delay).toHaveBeenCalledTimes(4)
			jestExpect(timers:getTimerCount()).toBe(1)
			jestExpect(mockFn).toHaveBeenCalledTimes(2)
			jestExpect(os.clock()).toBe(100)

			timers:runOnlyPendingTimers()
			jestExpect(delay).toHaveBeenCalledTimes(5)
			jestExpect(timers:getTimerCount()).toBe(1)
			jestExpect(mockFn).toHaveBeenCalledTimes(2)
			jestExpect(os.clock()).toBe(100)
		end)

		it('advanceTimersByTime', function()
			timers:useFakeTimers()

			local runOrder = {}
			local loopFn = function() end
			loopFn = function()
				table.insert(runOrder, os.clock())
				delay(10, loopFn)
			end

			delay(0, loopFn)
			delay(51, function() table.insert(runOrder, os.clock()) end)
			jestExpect(delay).toHaveBeenCalledTimes(2)

			timers:advanceTimersByTime(1)
			jestExpect(runOrder).toEqual({0})
			jestExpect(timers:getTimerCount()).toBe(2)

			timers:advanceTimersByTime(10)
			jestExpect(runOrder).toEqual({0, 10})

			timers:advanceTimersByTime(20)
			jestExpect(runOrder).toEqual({0, 10, 20, 30})
			jestExpect(os.clock()).toBe(31)

			timers:advanceTimersByTime(24)
			jestExpect(runOrder).toEqual({0, 10, 20, 30, 40, 50, 51})
			jestExpect(os.clock()).toBe(55)
		end)

		it('advanceTimersToNextTimer', function()
			timers:useFakeTimers()

			local runOrder = {}
			local loopFn = function() end
			loopFn = function()
				table.insert(runOrder, os.clock())
				delay(10, loopFn)
			end

			delay(0, loopFn)
			delay(0, function() table.insert(runOrder, os.clock()) end)

			timers:advanceTimersToNextTimer()
			jestExpect(runOrder).toEqual({0, 0})

			timers:advanceTimersToNextTimer(2)
			jestExpect(runOrder).toEqual({0, 0, 10, 20})
		end)
	end)

	describe('internal timer never goes backwards', function()
		it('runAllTimers', function()
			timers:useFakeTimers()

			local runOrder = {}
			delay(0, function()
				table.insert(runOrder, 0)
				delay(10, function() table.insert(runOrder, 10) end)
			end)
			delay(100, function() table.insert(runOrder, 100) end)

			timers:runOnlyPendingTimers()
			jestExpect(runOrder).toEqual({0, 100})
			jestExpect(os.clock()).toBe(100)

			timers:runAllTimers()
			jestExpect(runOrder).toEqual({0, 100, 10})
			jestExpect(os.clock()).toBe(100)
		end)

		it('run timers in order', function()
			timers:useFakeTimers()

			local runOrder = {}
			delay(0, function()
				table.insert(runOrder, 0)
				delay(10, function() table.insert(runOrder, 10) end)
			end)
			delay(100, function() table.insert(runOrder, 100) end)

			timers:runAllTimers()
			jestExpect(runOrder).toEqual({0, 10, 100})
			jestExpect(os.clock()).toBe(100)
		end)

		it('runOnlyPendingTimers', function()
			timers:useFakeTimers()

			local runOrder = {}
			delay(0, function()
				table.insert(runOrder, 0)
				delay(10, function() table.insert(runOrder, 10) end)
			end)
			delay(100, function() table.insert(runOrder, 100) end)

			timers:runOnlyPendingTimers()
			jestExpect(runOrder).toEqual({0, 100})
			jestExpect(os.clock()).toBe(100)

			timers:runOnlyPendingTimers()
			jestExpect(runOrder).toEqual({0, 100, 10})
			jestExpect(os.clock()).toBe(100)
		end)
	end)
end