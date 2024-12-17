local M = {}
function M.arrayToStr(t)
	local str = "["
	for i, n in ipairs(t) do
		if i ~= 1 then
			str = str .. ","
		end
		str = str .. tostring(n)
	end
	str = str .. "]"
	return str
end

function M.flatten(tbl)
	local ret = {}
	for _, n in ipairs(tbl) do
		if type(n) == "table" then
			table.insert(ret, M.flatten(n))
		else
			table.insert(ret, n)
		end
	end
end

function M.keys(t)
	local ret = {}
	for k, _ in pairs(t) do
		table.insert(ret, k)
	end
	return ret
end

return M
