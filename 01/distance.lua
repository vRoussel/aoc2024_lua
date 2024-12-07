#!/usr/bin/env lua

local l1 = {}
local l2 = {}

-- read data
while true do
	local a, b = io.read("*n", "*n")
	if a == nil and b == nil then
		break
	end
	if a then
		table.insert(l1, a)
	end
	if b then
		table.insert(l2, b)
	end
end

table.sort(l1)
table.sort(l2)

-- compute distance
local dist = 0
for i = 1, math.max(#l1, #l2) do
	local a = l1[i] or 0
	local b = l2[i] or 0
	dist = dist + math.abs(a - b)
end

print(string.format("dist = %d", dist))
