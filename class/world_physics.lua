local lp = love.physics
local util = require('lib.util')

local physics = {}

local world = nil

---@return love.World
function physics:get()
    world = util.nullCheck(world)
        and lp.newWorld()
        or world

    return world
end


---@param dt number
function physics:update(dt)
    world:update(dt)
end


return physics
