return function()
	local Object = require(script.Parent.Parent.Object)

	describe(".is()", function()
		it('returns true when given (\'foo\', \'foo\')', function()
			expect(Object.is('foo', 'foo')).to.equal(true)
		end)

		it('returns false when given (\'foo\', \'bar\')', function()
			expect(Object.is('foo', 'bar')).to.equal(false)
		end)

		it('returns false when given ({}, {})', function()
			expect(Object.is({}, {})).to.equal(false)
		end)

		local foo = { a = 1 }
		local bar = { a = 1 }
		it('returns true when given (foo, foo)', function()
			expect(Object.is(foo, foo)).to.equal(true)
		end)

		it('returns false when given (foo, bar)', function()
			expect(Object.is(foo, bar)).to.equal(false)
		end)

		it('returns true when given (nil, nil)', function()
			expect(Object.is(nil, nil)).to.equal(true)
		end)

		it('returns false when given (0, -0)', function()
			expect(Object.is(0, -0)).to.equal(false)
		end)

		it('returns true when given (-0, -0)', function()
			expect(Object.is(-0, -0)).to.equal(true)
		end)

		it('returns true when given (0/0, 0/0)', function()
			expect(Object.is(0 / 0, 0 / 0)).to.equal(true)
		end)
	end)
end