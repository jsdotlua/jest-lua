return function()
	local Array = require(script.Parent.Parent.Array)

	local function arrayEquals(a1, a2)
		return #a1 == #a2 and
			Array.every(
				a1,
				function(element, index)
					return element == a2[index]
				end
			)
	end

	describe('.splice()', function()
		it('Invalid argument', function()
			expect(function()
				Array.splice(nil, 0, 0, 'nil')
			end).to.throw()
		end)

		it('Remove 0 (zero) elements before index 3, and insert "drum"', function()
			local myFish = {'angel', 'clown', 'mandarin', 'sturgeon'}
			local removed = Array.splice(myFish, 3, 0, 'drum')
			expect(arrayEquals(
				removed,
				{}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"angel", "clown", "drum", "mandarin", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove 0 (zero) elements before index 3, and insert "drum" and "guitar"', function()
			local myFish = {'angel', 'clown', 'mandarin', 'sturgeon'}
			local removed = Array.splice(myFish, 3, 0, 'drum', 'guitar')
			expect(arrayEquals(
				removed,
				{}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"angel", "clown", "drum", "guitar", "mandarin", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove 1 element at index 4', function()
			local myFish = {'angel', 'clown', 'drum', 'mandarin', 'sturgeon'}
			local removed = Array.splice(myFish, 4, 1)
			expect(arrayEquals(
				removed,
				{"mandarin"}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"angel", "clown", "drum", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove 1 element at index 3, and insert "trumpet"', function()
			local myFish = {'angel', 'clown', 'drum', 'sturgeon'}
			local removed = Array.splice(myFish, 3, 1, 'trumpet')
			expect(arrayEquals(
				removed,
				{"drum"}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"angel", "clown", "trumpet", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove 2 elements from index 1, and insert "parrot", "anemone" and "blue"', function()
			local myFish = {'angel', 'clown', 'trumpet', 'sturgeon'}
			local removed = Array.splice(myFish, 1, 2, 'parrot', 'anemone', 'blue')
			expect(arrayEquals(
				removed,
				{"angel", "clown"}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"parrot", "anemone", "blue", "trumpet", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove 2 elements from index 3', function()
			local myFish = {'parrot', 'anemone', 'blue', 'trumpet', 'sturgeon'}
			local removed = Array.splice(myFish, 3, 2)
			expect(arrayEquals(
				removed,
				{"blue", "trumpet"}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"parrot", "anemone", "sturgeon"}
			)).to.equal(true)
		end)

		it('Remove all elements from index 3', function()
			local myFish = {'angel', 'clown', 'mandarin', 'sturgeon'}
			local removed = Array.splice(myFish, 3)
			expect(arrayEquals(
				removed,
				{"mandarin", "sturgeon"}
			)).to.equal(true)
			expect(arrayEquals(
				myFish,
				{"angel", "clown"}
			)).to.equal(true)
		end)
	end)

	describe('.slice()', function()
		it('Invalid argument', function()
			expect(function()
				Array.slice(nil, 1)
			end).to.throw()
		end)

		it('Return from index 3 to end', function()
			local animals = {'ant', 'bison', 'camel', 'duck', 'elephant'}
			local slice = Array.slice(animals, 3)
			expect(arrayEquals(
				slice,
				{"camel", "duck", "elephant"}
			)).to.equal(true)
		end)

		it('Return from index 3 to 5', function()
			local animals = {'ant', 'bison', 'camel', 'duck', 'elephant'}
			local slice = Array.slice(animals, 3, 5)
			expect(arrayEquals(
				slice,
				{"camel", "duck"}
			)).to.equal(true)
		end)

		it('Return from index 2 to index 6 (out of bounds)', function()
			local animals = {'ant', 'bison', 'camel', 'duck', 'elephant'}
			local slice = Array.slice(animals, 2, 6)
			expect(arrayEquals(
				slice,
				{"bison", "camel", "duck", "elephant"}
			)).to.equal(true)
		end)
	end)

	describe('.reduce()', function()
		it('Invalid argument', function()
			expect(function()
				Array.reduce(nil, function() end)
			end).to.throw()
			expect(function()
				Array.reduce({0, 1}, nil)
			end).to.throw()
		end)

		it('Sum all the values of an array', function()
			expect(
				Array.reduce(
					{0, 1, 2, 3},
					function(accumulator, currentValue)
						return accumulator + currentValue
					end
				)
			).to.equal(6)
		end)

		it('Sum of values in an object array', function()
			expect(
				Array.reduce(
					{ { x = 1 }, { x = 2 }, { x = 3 } },
					function(accumulator, currentValue)
						return accumulator + currentValue.x
					end,
					0
				)
			).to.equal(6)
		end)

		it('Counting instances of values in an object', function()
			local names = {'Alice', 'Bob', 'Tiff', 'Bruce', 'Alice'}
			local reduced = Array.reduce(
				names,
				function(allNames, name)
					if allNames[name] ~= nil then
						allNames[name] = allNames[name] + 1
					else
						allNames[name] = 1
					end
					return allNames
				end,
				{}
			)
			expect(reduced['Alice']).to.equal(2)
			expect(reduced['Bob']).to.equal(1)
			expect(reduced['Tiff']).to.equal(1)
			expect(reduced['Bruce']).to.equal(1)
		end)

		it('Grouping objects by a property', function()
			local people = {
				{ name = 'Alice', age = 21 },
				{ name = 'Max', age = 20 },
				{ name = 'Jane', age = 20 }
			}
			local reduced = Array.reduce(
				people,
				function(acc, obj)
					local key = obj['age']
					if acc[key] == nil then
						acc[key] = {}
					end
					table.insert(acc[key], obj)
					return acc
				end,
				{}
			)
			expect(#reduced[20]).to.equal(2)
			expect(#reduced[21]).to.equal(1)
		end)
	end)

	describe('.some()', function()
		it('Invalid argument', function()
			expect(function()
				Array.some(nil, function() end)
			end).to.throw()
			expect(function()
				Array.some({0, 1}, nil)
			end).to.throw()
		end)

		it('Testing value of array elements', function()
			local isBiggerthan10 = function(element, index, array)
				return element > 10
			end
			expect(Array.some({2, 5, 8, 1, 4}, isBiggerthan10)).to.equal(false)
			expect(Array.some({12, 5, 8, 1, 4}, isBiggerthan10)).to.equal(true)
		end)

		it('Checking whether a value exists in an array', function()
			local fruits = {'apple', 'banana', 'mango', 'guava'}
			local checkAvailability = function(arr, val)
				return Array.some(arr, function(arrVal)
					return val == arrVal
				end)
			end
			expect(checkAvailability(fruits, 'kela')).to.equal(false)
			expect(checkAvailability(fruits, 'banana')).to.equal(true)
		end)

		it('Converting any value to Boolean', function()
			local truthy_values = {true, 'true', 1}
			local getBoolean = function(value)
				return Array.some(truthy_values, function(t)
					return t == value
				end)
			end
			expect(getBoolean(false)).to.equal(false)
			expect(getBoolean('false')).to.equal(false)
			expect(getBoolean(1)).to.equal(true)
			expect(getBoolean('true')).to.equal(true)
		end)
	end)

	describe('.map()', function()
		it('Invalid argument', function()
			expect(function()
				Array.map(nil, function() end)
			end).to.throw()
			expect(function()
				Array.map({0, 1}, nil)
			end).to.throw()
		end)

		it('Mapping an array of numbers to an array of square roots', function()
			local numbers = {1, 4, 9}
			local roots = Array.map(numbers, function(num)
				return math.sqrt(num)
			end)
			expect(arrayEquals(
				numbers,
				{1, 4, 9}
			)).to.equal(true)
			expect(arrayEquals(
				roots,
				{1, 2, 3}
			)).to.equal(true)
		end)

		it('Using map to reformat objects in an array', function()
			local kvArray = {
				{key = 1, value = 10},
				{key = 2, value = 20},
				{key = 3, value = 30}
			}
			local reformattedArray = Array.map(kvArray, function(obj)
				local rObj = {}
				rObj[obj.key] = obj.value
				return rObj
			end)
			-- // reformattedArray is now [{1: 10}, {2: 20}, {3: 30}], 
			expect(reformattedArray[1][1]).to.equal(10)
			expect(reformattedArray[2][2]).to.equal(20)
			expect(reformattedArray[3][3]).to.equal(30)
		end)

		it('Mapping an array of numbers using a function containing an argument', function()
			local numbers = {1, 4, 9}
			local doubles = Array.map(numbers, function(num)
				return num * 2
			end)
			expect(arrayEquals(
				doubles,
				{2, 8, 18}
			)).to.equal(true)
		end)
	end)

	describe('.every()', function()
		it('Invalid argument', function()
			expect(function()
				Array.every(nil, function() end)
			end).to.throw()
			expect(function()
				Array.every({0, 1}, nil)
			end).to.throw()
		end)

		it('Testing size of all array elements', function()
			local isBigEnough = function(element, index, array) 
				return element >= 10
			end
			expect(Array.every(
				{12, 5, 8, 130, 44},
				isBigEnough
			)).to.equal(false)
			expect(Array.every(
				{12, 54, 18, 130, 44},
				isBigEnough
			)).to.equal(true)
		end)

		it('Modifying inital array', function()
			local arr = {1, 2, 3, 4}
			local expected = {1, 1, 2}
			expect(Array.every(
				arr,
				function(elem, index, a)
					a[index + 1] -= 1
					expect(a[index]).to.equal(expected[index])
					return elem < 2
				end
			)).to.equal(false)
			expect(arr[4]).to.equal(3)
		end)

		it('Appending to inital array', function()
			local arr = {1, 2, 3}
			local expected = {1, 2, 3}
			expect(Array.every(
				arr,
				function(elem, index, a)
					table.insert(a, 'new')
					expect(a[index]).to.equal(expected[index])
					return elem < 4
				end
			)).to.equal(true)
			expect(arr[4]).to.equal('new')
			expect(arr[5]).to.equal('new')
			expect(arr[6]).to.equal('new')
		end)

		it('Deleting from inital array', function()
			local arr = {1, 2, 3, 4}
			local expected = {1, 2}
			expect(Array.every(
				arr,
				function(elem, index, a)
					table.remove(a)
					expect(a[index]).to.equal(expected[index])
					return elem < 4
				end
			)).to.equal(true)
			expect(#arr).to.equal(2)
		end)
	end)
end