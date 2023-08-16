local exports = {}

local function sum(nums: { number })
	local sum = 0
	for _, num in nums do
		sum += num
	end
	return sum
end
exports.sum = sum

local function average(nums: { number })
	if #nums > 0 then
		return sum(nums) / #nums
	end
	return 0
end
exports.average = average

return exports
