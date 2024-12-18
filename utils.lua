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

function M.tableToStr(t)
	local str = "{"
	local first = true
	for k, v in pairs(t) do
		if not first then
			str = str .. ", "
		end
		str = str .. tostring(k) .. ": " .. tostring(v)
		first = false
	end
	str = str .. "}"
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

function M.strToTable(s)
	local t = {}
	for i = 1, #s do
		t[i] = s:sub(i, i)
	end
	return t
end

function M.count_keys(t)
	local count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	return count
end

return M
