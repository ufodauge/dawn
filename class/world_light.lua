local LightWorld = require('lib.lightworld.lib')
local util       = require('lib.util')

local World = {}

local world = nil

---@param args table?
---@return unknown
function World:get(args)
    world = world or LightWorld(args)

    return world
end


---@param dt number
function World:update(dt)
    world:update(dt)
end


return World
