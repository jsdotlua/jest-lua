local Number = {}
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
Number.MAX_SAFE_INTEGER = 9007199254740991
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER
Number.MIN_SAFE_INTEGER = -9007199254740991

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isInteger
function Number.isInteger(value)
	return type(value) == 'number' and value ~= 1/0 and value == math.floor(value)
end

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isSafeInteger
function Number.isSafeInteger(value)
	return Number.isInteger(value) and math.abs(value) <= Number.MAX_SAFE_INTEGER
end

return Number