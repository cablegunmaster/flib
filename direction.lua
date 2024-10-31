if ... ~= "__flib__.direction" then
  return require("__flib__.direction")
end

local flib_math = require("__flib__.math")

--- Functions for working with directions.
--- ```lua
--- local flib_direction = require("__flib__.direction")
--- ```
--- @class flib_direction
local flib_direction = {}

--- Calculate the opposite direction.
--- @param direction defines.direction
--- @return defines.direction
function flib_direction.opposite(direction)
  return (direction + 8) % 16 --[[@as defines.direction]]
end

--- Calculate the next four-way or eight-way direction.
--- @param direction defines.direction
--- @param eight_way? boolean
--- @return defines.direction
function flib_direction.next(direction, eight_way)
  return (direction + (eight_way and 2 or 4)) % 16 --[[@as defines.direction]]
end

--- Calculate the previous four-way or eight-way direction.
--- @param direction defines.direction
--- @param eight_way? boolean
--- @return defines.direction
function flib_direction.previous(direction, eight_way)
  return (direction + (eight_way and -2 or -4)) % 16 --[[@as defines.direction]]
end

--- Calculate an orientation from a direction.
--- @param direction defines.direction
--- @return RealOrientation
function flib_direction.to_orientation(direction)
  return direction / 16 --[[@as RealOrientation]]
end

--- Calculate a vector from a direction.
--- @param direction defines.direction
--- @param distance? number default: `1`
--- @return MapPosition
function flib_direction.to_vector(direction, distance)
  distance = distance or 1
  local x, y = 0, 0
  if direction == defines.direction.north then
    y = y - distance
  elseif direction == defines.direction.northeast then
    x, y = x + distance, y - distance
  elseif direction == defines.direction.east then
    x = x + distance
  elseif direction == defines.direction.southeast then
    x, y = x + distance, y + distance
  elseif direction == defines.direction.south then
    y = y + distance
  elseif direction == defines.direction.southwest then
    x, y = x - distance, y + distance
  elseif direction == defines.direction.west then
    x = x - distance
  elseif direction == defines.direction.northwest then
    x, y = x - distance, y - distance
  end
  return { x = x, y = y }
end

--- Calculate a two-dimensional vector from a cardinal direction.
--- @param direction defines.direction
--- @param longitudinal number Distance to move in the specified direction.
--- @param orthogonal number Distance to move perpendicular to the specified direction. A negative distance will move "left" and a positive distance will move "right" from the perspective of the direction.
--- @return MapPosition?
function flib_direction.to_vector_2d(direction, longitudinal, orthogonal)
  if direction == defines.direction.north then
    return { x = orthogonal, y = -longitudinal }
  elseif direction == defines.direction.south then
    return { x = -orthogonal, y = longitudinal }
  elseif direction == defines.direction.east then
    return { x = longitudinal, y = orthogonal }
  elseif direction == defines.direction.west then
    return { x = -longitudinal, y = -orthogonal }
  end
end

--- Calculate the direction of travel from the source to the target.
--- @param source MapPosition
--- @param target MapPosition
--- @param round? boolean If true, round to the nearest `defines.direction`.
--- @return defines.direction
function flib_direction.from_positions(source, target, round)
  local deg = math.deg(math.atan2(target.y - source.y, target.x - source.x))
  local direction = (deg + 90) / 22.5
  if direction < 0 then
    direction = direction + 16
  end
  if round then
    direction = flib_math.round(direction)
  end
  return direction --[[@as defines.direction]]
end

return flib_direction
