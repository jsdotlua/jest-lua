local Object = {}
Object.__index = Object

function Object.is(x, y)
	if x == y then
		return x ~= 0 or 1 / x == 1 / y
	else
		return x ~= x and y ~= y
	end
end

return Object