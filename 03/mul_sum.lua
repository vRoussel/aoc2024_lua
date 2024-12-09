#!/usr/bin/env lua5.1

local sum = 0
local sum_if_enabled = 0
local enabled = true
while true do
	local line = io.read("*l")
	if line == nil then
		break
	end

	-- part 1
	for n1, n2 in line:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
		sum = sum + (tonumber(n1) * tonumber(n2))
	end

	-- part 2
	for op, params in line:gmatch("([%l']+)%(([%d,]*)%)") do
		if op:match("do$") and params == "" then
			enabled = true
		elseif op:match("don't$") and params == "" then
			enabled = false
		elseif op:match("mul$") and enabled then
			local n1, n2 = params:match("(%d+),(%d+)")
			if n1 and n2 then
				sum_if_enabled = sum_if_enabled + n1 * n2
			end
		end
		-- sum = sum + (tonumber(n1) * tonumber(n2))
	end
end
print(string.format("mul_sum = %d", sum))
print(string.format("mul_sum (if enabled) = %d", sum_if_enabled))
