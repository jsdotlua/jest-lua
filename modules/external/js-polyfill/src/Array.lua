local Array = {}

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
-- adapted from http://phi.lho.free.fr/programming/TestLuaArray.lua.html
-- imitates Javascript's Array.prototype.splice but with 1-indexing
function Array.splice(t, index, howMany, ...)
	if typeof(t) ~= 'table' then
		error(string.format('Array.splice called on %s', typeof(t)))
	end
	local arg = {...}
	local removed = {}
	local tableSize = #t -- Table size
	-- Lua 5.0 handling of vararg...
	local argNb = #arg -- Number of elements to insert
	-- Check parameter validity
	if index < 1 then index = 1 end
	if howMany == nil then
		howMany = tableSize - (index - 1)
	elseif howMany < 0 then
		howMany = 0
	end
	if index > tableSize then
		index = tableSize + 1 -- At end
		howMany = 0 -- Nothing to delete
	end
	if index + howMany - 1 > tableSize then
		howMany = tableSize - index + 1 -- Adjust to number of elements at index
	end

	local argIdx = 1 -- Index in arg
	-- Replace min(howMany, argNb) entries
	for pos = index, index + math.min(howMany, argNb) - 1 do
		-- Copy removed entry
		table.insert(removed, t[pos])
		-- Overwrite entry
		t[pos] = arg[argIdx]
		argIdx = argIdx + 1
	end
	argIdx = argIdx - 1
	-- If howMany > argNb, remove extra entries
	for i = 1, howMany - argNb do
		table.insert(removed, table.remove(t, index + argIdx))
	end
	-- If howMany < argNb, insert remaining new entries
	for i = argNb - howMany, 1, -1 do
		table.insert(t, index + howMany, arg[argIdx + i])
	end
	return removed
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice
-- imitates Javascript's Array.prototype.slice but with 1-indexing and no negative indices
function Array.slice(t, start_idx, end_idx)
	if typeof(t) ~= 'table' then
		error(string.format('Array.slice called on %s', typeof(t)))
	end
	local slice = {}
	if start_idx == nil or start_idx > #t + 1 or start_idx < 0 then
		start_idx = 0
	end
	if end_idx == nil or end_idx > #t + 1 or end_idx < 0 then
		end_idx = #t + 1
	end

	local idx = start_idx
	local i = 1
	while idx < end_idx do
		slice[i] = t[idx]
		idx = idx + 1
		i = i + 1
	end
	return slice
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce#Polyfill
-- slightly modified to allow for initialValue
function Array.reduce(t, callback, initialValue)
	if typeof(t) ~= 'table' then
		error(string.format('Array.reduce called on %s', typeof(t)))
	end
	if typeof(callback) ~= 'function' then
		error('callback is not a function')
	end

	local len = #t

	local k = 0
	local value

	if initialValue ~= nil then
		value = initialValue
	else
		-- lua has undefined behavior on non-sequences
		-- while k < len and t[k + 1] == nil do
		-- 	k = k + 1
		-- end

		-- if k >= len and initialValue == nil then
		-- 	error('Reduce of empty array with no initial value')
		-- end
		value = t[k + 1]
		k = k + 1
	end

	while k < len do
		if t[k + 1] ~= nil then
			value = callback(value, t[k + 1], k, t)
		end
		k = k + 1
	end

	return value
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some
function Array.some(t, fun, thisArg)
	if typeof(t) ~= 'table' then
		error(string.format('Array.some called on %s', typeof(t)))
	end
	if typeof(fun) ~= 'function' then
		error('callback is not a function')
	end

	for i, value in ipairs(t) do
		if thisArg ~= nil then
			if value ~= nil and fun(thisArg, value, i, t) then
				return true
			end
		else
			if value ~= nil and fun(value, i, t) then
				return true
			end
		end
	end
	return false
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map
function Array.map(t, callback, thisArg)
	if typeof(t) ~= 'table' then
		error(string.format('Array.map called on %s', typeof(t)))
	end
	if typeof(callback) ~= 'function' then
		error('callback is not a function')
	end

	local A = {}

	for k, kValue in ipairs(t) do
		if kValue ~= nil then
			local mappedValue

			if thisArg ~= nil then
				mappedValue = callback(thisArg, kValue, k, t)
			else
				mappedValue = callback(kValue, k, t)
			end

			A[k] = mappedValue
		end
	end

	return A
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every
function Array.every(t, callbackfn, thisArg)
	if typeof(t) ~= 'table' then
		error(string.format('Array.every called on %s', typeof(t)))
	end
	if typeof(callbackfn) ~= 'function' then
		error('callback is not a function')
	end

	local len = #t
	local k = 1

	while k <= len do
		local kValue = t[k]
		local testResult

		if kValue ~= nil then
			if thisArg ~= nil then
				testResult = callbackfn(thisArg, kValue, k, t)
			else
				testResult = callbackfn(kValue, k, t)
			end

			if not testResult then
				return false
			end
		end
		k += 1
	end
	return true
end

return Array