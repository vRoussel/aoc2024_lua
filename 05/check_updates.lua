#!/usr/bin/env luajit

-- parse rules
local rules_by_page = {}
while true do
	local line = io.read("*l")
	local a, b = line:match("(%d+)|(%d+)")
	if not a or not b then
		break
	end
    local rule = {a,b}
    rules_by_page[a] = rules_by_page[a] or {}
    rules_by_page[b] = rules_by_page[b] or {}
    table.insert(rules_by_page[b], rule)
    table.insert(rules_by_page[a], rule)
end

local function check_rule(rule, idx_by_page)
    local a_idx = idx_by_page[rule[1]]
    local b_idx = idx_by_page[rule[2]]
    if a_idx == nil or b_idx == nil then
        return true
    end
    return a_idx < b_idx
end

local magic_count = 0
while true do
	local line = io.read("*l")
	if line == nil then
		break
	end
    local update = {}
    local idx_by_page = {}
	for page in line:gmatch("[^,]+") do
        table.insert(update, page)
        idx_by_page[page] = #update
    end
    for _, page in pairs(update) do
        for _,rule in pairs(rules_by_page[page]) do
            if not check_rule(rule, idx_by_page) then
                goto next_update
            end
        end
    end

    -- all rules are respected
    local middle_index = (#update + 1) / 2
    magic_count = magic_count + update[middle_index]

    ::next_update::
end

print(string.format("magic_count1: %d", magic_count))
