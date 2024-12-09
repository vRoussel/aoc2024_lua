#!/usr/bin/env lua5.1

local function diagonal_words_from_center_point(grid, x, y, word_size)
	if word_size % 2 == 0 then
		print("Only even word_size are allowed, since we need a center letter")
		return nil
	end

	local height = #grid
	local width = #grid[1]
	local branch_size = (word_size - 1) / 2
	local words = {}

	local fits_right = (x + branch_size <= width)
	local fits_left = (x - branch_size >= 1)
	local fits_down = (y + branch_size <= height)
	local fits_up = (y - branch_size >= 1)

	local fits = fits_right and fits_left and fits_down and fits_up
	if fits then
		-- from down-left to up-right
		local w1 = ""
		for n = 0, word_size - 1 do
			local word_start_x = x - branch_size
			local word_start_y = y + branch_size
			w1 = w1 .. grid[word_start_y - n]:sub(word_start_x + n, word_start_x + n)
		end
		table.insert(words, w1)

		-- from up-left to down-right
		local w2 = ""
		for n = 0, word_size - 1 do
			local word_start_x = x - branch_size
			local word_start_y = y - branch_size
			w2 = w2 .. grid[word_start_y + n]:sub(word_start_x + n, word_start_x + n)
		end
		table.insert(words, w2)
	end

	local i = 0
	return function()
		i = i + 1
		return words[i]
	end
end

local grid = {}
local a_locations = {}
while true do
	local line = io.read("*l")
	if line == nil then
		break
	end
	table.insert(grid, line)

	local i = 1
	while true do
		local x = line:find("A", i, true)
		if x == nil then
			break
		end
		table.insert(a_locations, { x, #grid })
		i = x + 1
	end
end

local x_mas_count = 0
for _, coords in ipairs(a_locations) do
	local x, y = unpack(coords)
	local matches = 0
	for w in diagonal_words_from_center_point(grid, x, y, 3) do
		if w == "MAS" or w == "SAM" then
			matches = matches + 1
		end
	end
	if matches == 2 then
		x_mas_count = x_mas_count + 1
	end
end

print(string.format("X-MAS found: %d", x_mas_count))
