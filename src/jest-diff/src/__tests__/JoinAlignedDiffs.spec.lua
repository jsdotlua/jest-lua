-- upstream: https://github.com/facebook/jest/blob/v27.2.5/packages/jest-diff/src/__tests__/joinAlignedDiffs.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local DIFF_DELETE = require(CurrentModule.CleanupSemantic).DIFF_DELETE
	local DIFF_EQUAL = require(CurrentModule.CleanupSemantic).DIFF_EQUAL
	local DIFF_INSERT = require(CurrentModule.CleanupSemantic).DIFF_INSERT
	local Diff = require(CurrentModule.CleanupSemantic).Diff

	local joinAlignedDiffsExpand = require(CurrentModule.JoinAlignedDiffs).joinAlignedDiffsExpand
	local joinAlignedDiffsNoExpand = require(CurrentModule.JoinAlignedDiffs).joinAlignedDiffsNoExpand

	local noColor = require(CurrentModule.NormalizeDiffOptions).noColor
	local normalizeDiffOptions = require(CurrentModule.NormalizeDiffOptions).normalizeDiffOptions

	local changeColor = function(s) return '<i>' .. s .. '</i>' end
	local optionsNoColor = {
		aColor = noColor,
		bColor = noColor,
		changeColor = changeColor,
		commonColor = noColor,
		emptyFirstOrLastLinePlaceholder = '↵', -- // U+21B5
		patchColor = noColor,
	}

	beforeAll(function()
		jestExpect.addSnapshotSerializer({
			serialize = function(val: string) return val end,
			test = function(val: any) return typeof(val) == "string" end
		})
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	local diffsCommonStartEnd = {
		Diff.new(DIFF_EQUAL, ''),
		Diff.new(DIFF_EQUAL, 'common 2 preceding A'),
		Diff.new(DIFF_EQUAL, 'common 1 preceding A'),
		Diff.new(DIFF_DELETE, 'delete line'),
		Diff.new(DIFF_DELETE, table.concat({'change ', changeColor('expect'), 'ed A'}, '')),
		Diff.new(DIFF_INSERT, table.concat({'change ', changeColor('receiv'), 'ed A'}, '')),
		Diff.new(DIFF_EQUAL, 'common 1 following A'),
		Diff.new(DIFF_EQUAL, 'common 2 following A'),
		Diff.new(DIFF_EQUAL, 'common 3 following A'),
		Diff.new(DIFF_EQUAL, 'common 4 following A'),
		Diff.new(DIFF_EQUAL, 'common 4 preceding B'),
		Diff.new(DIFF_EQUAL, 'common 3 preceding B'),
		Diff.new(DIFF_EQUAL, 'common 2 preceding B'),
		Diff.new(DIFF_EQUAL, 'common 1 preceding B'),
		Diff.new(DIFF_DELETE, table.concat({'change ', changeColor('expect'), 'ed B'}, '')),
		Diff.new(DIFF_INSERT, table.concat({'change ', changeColor('receiv'), 'ed B'}, '')),
		Diff.new(DIFF_INSERT, 'insert line'),
		Diff.new(DIFF_EQUAL, 'common 1 following B'),
		Diff.new(DIFF_EQUAL, 'common 2 following B'),
		Diff.new(DIFF_EQUAL, 'common 3 between B and C'),
		Diff.new(DIFF_EQUAL, 'common 2 preceding C'),
		Diff.new(DIFF_EQUAL, 'common 1 preceding C'),
		Diff.new(DIFF_DELETE, table.concat({'change ', changeColor('expect'), 'ed C'}, '')),
		Diff.new(DIFF_INSERT, table.concat({'change ', changeColor('receiv'), 'ed C'}, '')),
		Diff.new(DIFF_EQUAL, 'common 1 following C'),
		Diff.new(DIFF_EQUAL, 'common 2 following C'),
		Diff.new(DIFF_EQUAL, 'common 3 following C'),
		Diff.new(DIFF_EQUAL, ''),
		Diff.new(DIFF_EQUAL, 'common 5 following C'),
	}

	local diffsChangeStartEnd = {
		Diff.new(DIFF_DELETE, 'delete'),
		Diff.new(DIFF_EQUAL, 'common following delete'),
		Diff.new(DIFF_EQUAL, 'common preceding insert'),
		Diff.new(DIFF_INSERT, 'insert'),
	}

	describe('joinAlignedDiffsExpand', function()
		it('first line is empty common', function()
			local options = normalizeDiffOptions(optionsNoColor)

			jestExpect(
				joinAlignedDiffsExpand(diffsCommonStartEnd, options)
			).toMatchSnapshot()
		end)
	end)

	describe('joinAlignedDiffsNoExpand', function()
		-- deviation: added a table copy method to set options
		local function tableCopy(t)
			local copy = {}
			for key, value in pairs(t) do
				copy[key] = value
			end
			return copy
		end

		it('patch 0 with context 1 and change at start and end', function()
			local options = tableCopy(optionsNoColor)
			for key, value in pairs(optionsNoColor) do
				options[key] = value
			end
			options['contextLines'] = 1
			options['expand'] = false
			options = normalizeDiffOptions(options)

			jestExpect(
				joinAlignedDiffsNoExpand(diffsChangeStartEnd, options)
			).toMatchSnapshot()
		end)

		it('patch 0 with context 5 and first line is empty common', function()
			local options = tableCopy(optionsNoColor)
			options['expand'] = false
			options = normalizeDiffOptions(options)

			jestExpect(
				joinAlignedDiffsNoExpand(diffsCommonStartEnd, options)
			).toMatchSnapshot()
		end)

		it('patch 1 with context 4 and last line is empty common', function()
			local options = tableCopy(optionsNoColor)
			options['contextLines'] = 4
			options['expand'] = false
			options = normalizeDiffOptions(options)

			jestExpect(
				joinAlignedDiffsNoExpand(diffsCommonStartEnd, options)
			).toMatchSnapshot()
		end)

		it('patch 2 with context 3', function()
			local options = tableCopy(optionsNoColor)
			options['contextLines'] = 3
			options['expand'] = false
			options = normalizeDiffOptions(options)

			jestExpect(
				joinAlignedDiffsNoExpand(diffsCommonStartEnd, options)
			).toMatchSnapshot()
		end)

		it('patch 3 with context 2 and omit excess common at start', function()
			local options = tableCopy(optionsNoColor)
			options['contextLines'] = 2
			options['expand'] = false
			options = normalizeDiffOptions(options)

			jestExpect(
				joinAlignedDiffsNoExpand(diffsCommonStartEnd, options)
			).toMatchSnapshot()
		end)
	end)
end