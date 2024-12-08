#!/usr/bin/env lua

local function shallowcopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

local function alternative_reports(orig, idx_error)
	local alternatives = {}
	for j = idx_error, idx_error - 2, -1 do
		if j > 0 then
			local alt = shallowcopy(orig)
			table.remove(alt, j)
			table.insert(alternatives, alt)
		end
	end
	return alternatives
end

local function isReportSafe(r, opts)
	if opts.use_dampener == nil then
		opts.use_dampener = false
	end

	if #r < 2 then
		return true
	end

	local min_step, max_step
	if r[1] < r[2] then
		min_step = 1
		max_step = 3
	else
		min_step = -3
		max_step = -1
	end

	for i = 2, #r do
		local step = r[i] - r[i - 1]
		if step < min_step or step > max_step then
			if opts.use_dampener then
				for _, alt in ipairs(alternative_reports(r, i)) do
					if isReportSafe(alt, { use_dampener = false }) then
						return true
					end
				end
			end
			return false
		end
	end

	return true
end

local safe_count = 0
local safeish_count = 0

while true do
	local line = io.read("*l")
	if line == nil then
		break
	end

	local report = {}
	for n in string.gmatch(line, "%d+") do
		table.insert(report, tonumber(n))
	end

	if isReportSafe(report, { use_dampener = false }) then
		safe_count = safe_count + 1
	elseif isReportSafe(report, { use_dampener = true }) then
		safeish_count = safeish_count + 1
	end
end

print(string.format("safe_count = %d", safe_count))
print(string.format("safe_count (with dampener) = %d", safe_count + safeish_count))
