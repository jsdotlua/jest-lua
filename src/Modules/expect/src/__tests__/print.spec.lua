--!nocheck
-- deviation: this file does not exist in upstream

return function()
	local Workspace = script.Parent.Parent

	local Print = require(Workspace.print)
	local jestExpect = require(Workspace)

	describe("printing constructor", function()
		local Dog = {}
		Dog.__index = Dog

		setmetatable(Dog, {
			__tostring = function(self)
				return "Dog"
			end
		})

		it("prints constructor name", function()
			jestExpect(Print.printExpectedConstructorName("Expected", Dog)).toEqual("Expected: Dog\n")
		end)

		it("prints constructor name (not)", function()
			jestExpect(Print.printExpectedConstructorNameNot("Expected", Dog)).toEqual("Expected: never Dog\n")
		end)

		it("reports that tostring returns non-string", function()
			setmetatable(Dog, {
				__tostring = function(self)
					return 1
				end
			})

			jestExpect(Print.printReceivedConstructorName("Received", Dog)).toEqual("Received name is not a string\n")
		end)

		it("reports that tostring returns empty", function()
			setmetatable(Dog, {
				__tostring = function(self)
					return ""
				end
			})

			jestExpect(Print.printReceivedConstructorName("Received", Dog)).toEqual("Received name is an empty string\n")
		end)

		-- FIXME in REVIEW: Should I change these tests to not rely on ordering of table even though the hash values of the keys should be consistent?
		it("prints some entries of non-tostring class", function()
			setmetatable(Dog, {
				__tostring = nil
			})
			Dog.fur = "brown"
			Dog.goodboy = true

			local result = Print.printReceivedConstructorName("Received", Dog)

			jestExpect(result).toContain("Received: { \"fur\": \"brown\",\"goodboy\": true }")
		end)

		it("prints ... for excessive key value", function()
			Dog.leash = "blue"
			Dog.weight = 80
			Dog.height = 48

			local result = Print.printReceivedConstructorName("Received", Dog)

			jestExpect(result).toContain("Received: { \"leash\": \"blue\",\"goodboy\": true,\"weight\": 80 ... }")
		end)

		it("defaults to printing table address for massive key value pair", function()
			Dog.fur = nil
			Dog.goodboy = nil
			Dog.leash = nil
			Dog.weight = nil
			Dog.height = nil
			Dog.furotherwiseknownasapersonallyidentifyingattributeofamammal = "brown"

			local result = Print.printExpectedConstructorName("Expected", Dog)

			jestExpect(result).toContain("Expected: table: 0x")
		end)

		it("prints function names only", function()
			Dog.furotherwiseknownasapersonallyidentifyingattributeofamammal = nil
			Dog.walk = function() end
			Dog.talk = function() end
			Dog.wagTail = function() end

			local result = Print.printExpectedConstructorName("Received", Dog)

			jestExpect(result).toContain("Received: { \"talk\",\"wagTail\",\"walk\" }")

		end)
	end)
end