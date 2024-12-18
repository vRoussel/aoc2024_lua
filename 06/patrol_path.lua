#!/usr/bin/env luajit

package.path = "../?.lua;" .. package.path

local utils = require("../utils")

local Coord = {}
Coord.mt = {
	__add = function(a, b)
		return Coord:new(a.x + b.x, a.y + b.y)
	end,
	__index = Coord,
}
function Coord:new(x, y)
	local o = setmetatable({}, self.mt)
	o.x = x
	o.y = y
	return o
end

local Dir = {
	UP = { x = 0, y = -1, name = "up" },
	RIGHT = { x = 1, y = 0, name = "right" },
	DOWN = { x = 0, y = 1, name = "down" },
	LEFT = { x = -1, y = 0, name = "left" },
}
function Dir.right_of(dir)
	local new_dir = {
		[Dir.UP] = Dir.RIGHT,
		[Dir.RIGHT] = Dir.DOWN,
		[Dir.DOWN] = Dir.LEFT,
		[Dir.LEFT] = Dir.UP,
	}
	return new_dir[dir]
end

local Map = {}
Map.mt = {
	__index = Map,
}
function Map:new()
	local o = setmetatable({}, self.mt)
	o._map = {}
	o._seen = {}
	o.height = 0
	o.width = 0
	return o
end
function Map:set(coord, value)
	self._map[coord.y][coord.x] = value
end
function Map:get(coord)
	return self._map[coord.y][coord.x]
end
function Map:add_row(row)
	assert(type(row) == "table")
	if self.width == 0 then
		assert(#row > 0)
		self.width = #row
	else
		assert(#row == self.width)
	end
	table.insert(self._map, row)
	self.height = self.height + 1
end
function Map:mark_as_seen(coord, dir)
	local coord_marker = coord.x .. "." .. coord.y
	self._seen[coord_marker] = self._seen[coord_marker] or {}
	if dir then
		self._seen[coord_marker][dir.name] = true
	end
end
function Map:has_been_seen(coord, dir)
	local marker = coord.x .. "." .. coord.y
	if self._seen[marker] == nil then
		return false
	elseif dir then
		return self._seen[marker][dir.name]
	else
		return true
	end
end
function Map:seen_count()
	return utils.count_keys(self._seen)
end

local OBSTACLE = "#"

local guard_dir = Dir.UP
local guard_pos
local map = Map:new()
for line in io.input():lines() do
	local x = line:find("%^")
	map:add_row(utils.strToTable(line))
	if x then
		guard_pos = Coord:new(x, map.height)
	end
end

while true do
	map:mark_as_seen(guard_pos)
	local leaving_map = (guard_pos.x == 1 and guard_dir == Dir.LEFT)
		or (guard_pos.x == map.width and guard_dir == Dir.RIGHT)
		or (guard_pos.y == 1 and guard_dir == Dir.UP)
		or (guard_pos.y == map.height and guard_dir == Dir.DOWN)

	if leaving_map then
		break
	end

	local next_pos = guard_pos + guard_dir
	local next_tile = map:get(next_pos)
	if next_tile == OBSTACLE then
		guard_dir = Dir.right_of(guard_dir)
	else
		guard_pos = next_pos
	end
end

print(string.format("Guard has seen %d tiles", map:seen_count()))
