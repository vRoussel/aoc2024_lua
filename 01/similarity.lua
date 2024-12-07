#!/usr/bin/env lua

local counter_mt = {}
counter_mt.__index = function()
	return 0
end

local hm1 = setmetatable({}, counter_mt)
local hm2 = setmetatable({}, counter_mt)

while true do
	local a, b = io.read("*n", "*n")
	if a == nil and b == nil then
		break
	end
	if a then
		hm1[a] = hm1[a] + 1
	end
	if b then
		hm2[b] = hm2[b] + 1
	end
end

local similarity = 0
for n, hm1_count in pairs(hm1) do
	local hm2_count = hm2[n]
	similarity = similarity + n * hm1_count * hm2_count
end

print(string.format("similarity: %d", similarity))
