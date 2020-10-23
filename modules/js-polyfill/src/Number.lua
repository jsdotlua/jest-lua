local Number = {}
Number.MAX_SAFE_INTEGER = 9007199254740991
Number.MIN_SAFE_INTEGER = -9007199254740991

function Number.isInteger(value)
	return type(value) == 'number' and value ~= 1/0 and value == math.floor(value)
end

function Number.isSafeInteger(value)
	return Number.isInteger(value) and math.abs(value) <= Number.MAX_SAFE_INTEGER
end

return Number