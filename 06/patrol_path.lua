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

local function find_loops(map, guard_pos, guard_dir, additional_obstacles)
	local loop_count = 0
	while true do
		if map:has_been_seen(guard_pos, guard_dir) then
			loop_count = loop_count + 1
			return loop_count
		end
		map:mark_as_seen(guard_pos, guard_dir)
		local leaving_map = (guard_dir == Dir.LEFT and guard_pos.x == 1)
			or (guard_dir == Dir.RIGHT and guard_pos.x == map.width)
			or (guard_dir == Dir.UP and guard_pos.y == 1)
			or (guard_dir == Dir.DOWN and guard_pos.y == map.height)

		if leaving_map then
			return loop_count
		end

		local next_pos = guard_pos + guard_dir
		local next_tile = map:get(next_pos)
		if next_tile == OBSTACLE then
			guard_dir = Dir.right_of(guard_dir)
		else
			-- Run an alternative version of the map where next_tile is actually a obstacle
			--  to check if we can create a loop
			-- If next_pos has been seen already, it means we already tried putting an obstacle there
			if additional_obstacles > 0 and not map:has_been_seen(next_pos) then
				local map_seen_backup = utils.deep_copy(map._seen)
				local next_tile_backup = next_tile
				map:set(next_pos, OBSTACLE)

				local new_guard_dir = Dir.right_of(guard_dir)
				loop_count = loop_count + find_loops(map, guard_pos, new_guard_dir, additional_obstacles - 1)

				map._seen = map_seen_backup
				map:set(next_pos, next_tile_backup)
			end
			guard_pos = next_pos
		end
	end
end

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

local loop_count = find_loops(map, guard_pos, guard_dir, 1)

print(string.format("Guard has seen %d tiles", map:seen_count()))
print(string.format("%d loops can be created by adding an obstacle", loop_count))
