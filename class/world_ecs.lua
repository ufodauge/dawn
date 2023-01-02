local ECS = require('lib.tiny-ecs')

local World = {}

local world = nil

---@param args table?
---@return unknown
function World:get(args)
    world = world or ECS.world(args)

    return world
end


---@param dt number
function World:update(dt)
    world:update(dt)
end


return World
