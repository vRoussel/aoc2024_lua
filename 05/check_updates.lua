#!/usr/bin/env luajit

local function check_pages_order(page1, page2, rules)
	local rules1 = rules[page1] or {}
	local rules2 = rules[page2] or {}

	-- rules says page1 comes before page2
	if rules1[page2] then
		return true
	-- rules says page2 comes before page1
	elseif rules2[page1] then
		return false
	-- rules say nothing, so current order is fine
	else
		return false
	end
end

local function is_update_valid(update, rules)
	for i = 1, (#update - 1) do
		for j = i + 1, #update do
			local page_left = update[i]
			local page_right = update[j]
			-- if a rule says that page_right must be before page_left
			if not check_pages_order(page_left, page_right, rules) then
				return false
			end
		end
	end
	return true
end

-- parse rules
local rules = {}
while true do
	local line = io.read("*l")
	local a, b = line:match("(%d+)|(%d+)")
	if not a or not b then
		break
	end
	rules[a] = rules[a] or {}
	rules[a][b] = true
end

local magic_number1 = 0
while true do
	local line = io.read("*l")
	if line == nil then
		break
	end
	local update = {}
	for page in line:gmatch("[^,]+") do
		table.insert(update, page)
	end

	local middle_index = (#update + 1) / 2
	if is_update_valid(update, rules) then
		magic_number1 = magic_number1 + update[middle_index]
	end
end

print(string.format("magic_number1: %d", magic_number1))
