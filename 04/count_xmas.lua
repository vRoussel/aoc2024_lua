#!/usr/bin/env lua5.1

local function words_from_point(grid, x, y, word_size)
	local height = #grid
	local width = #grid[1]
	local words = {}

	local fits_right = (x + word_size - 1 <= width)
	local fits_left = (x - word_size + 1 >= 1)
	local fits_down = (y + word_size - 1 <= height)
	local fits_up = (y - word_size + 1 >= 1)

	if fits_right then
		local w = grid[y]:sub(x, x + word_size - 1)
		table.insert(words, w)
	end

	if fits_left then
		local w = grid[y]:sub(x - word_size + 1, x):reverse()
		table.insert(words, w)
	end

	if fits_down then
		local w = ""
		for j = y, y + word_size - 1 do
			w = w .. grid[j]:sub(x, x)
		end
		table.insert(words, w)
	end

	if fits_up then
		local w = ""
		for j = y, y - word_size + 1, -1 do
			w = w .. grid[j]:sub(x, x)
		end
		table.insert(words, w)
	end

	-- diagonal down right
	if fits_right and fits_down then
		local w = ""
		for n = 0, word_size - 1 do
			w = w .. grid[y + n]:sub(x + n, x + n)
		end
		table.insert(words, w)
	end

	-- diagonal up right
	if fits_right and fits_up then
		local w = ""
		for n = 0, word_size - 1 do
			w = w .. grid[y - n]:sub(x + n, x + n)
		end
		table.insert(words, w)
	end

	-- diagonal down left
	if fits_left and fits_down then
		local w = ""
		for n = 0, word_size - 1 do
			w = w .. grid[y + n]:sub(x - n, x - n)
		end
		table.insert(words, w)
	end

	-- diagonal up left
	if fits_left and fits_up then
		local w = ""
		for n = 0, word_size - 1 do
			w = w .. grid[y - n]:sub(x - n, x - n)
		end
		table.insert(words, w)
	end

	local i = 0
	return function()
		i = i + 1
		return words[i]
	end
end

local grid = {}
local x_locations = {}
while true do
	local line = io.read("*l")
	if line == nil then
		break
	end
	table.insert(grid, line)

	local i = 1
	while true do
		local x = line:find("X", i, true)
		if x == nil then
			break
		end
		table.insert(x_locations, { x, #grid })
		i = x + 1
	end
end

local height = #grid
local width = #grid[1]

local xmas_count = 0
for _, coords in ipairs(x_locations) do
	local x, y = unpack(coords)
	for w in words_from_point(grid, x, y, 4) do
		if w == "XMAS" then
			xmas_count = xmas_count + 1
		end
	end
end

print(string.format("XMAS found: %d", xmas_count))
