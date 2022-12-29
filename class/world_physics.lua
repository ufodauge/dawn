local lp = love.physics
local util = require('lib.util')

local physics = {}

local world = nil

---@return love.World
function physics:get()
    if util.nullCheck(world) then
        world = nil
        world = lp.newWorld()
    end

    return world
end


---@param dt number
function physics:update(dt)
    world:update(dt)
end


return physics
