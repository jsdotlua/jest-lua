local Object = {}
Object.__index = Object

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
function Object.is(x, y)
	if x == y then
		return x ~= 0 or 1 / x == 1 / y
	else
		return x ~= x and y ~= y
	end
end

return Object