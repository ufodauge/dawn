local Bubble   = require('nocs.entities.bubble')

local lm = love.math
local lg = love.graphics

local BubbleFactory = {}

function BubbleFactory:update(dt)
    if lm.random() < 0.02 then
        local x, y = lm.random() * lg.getWidth(), lg.getHeight() + 50
        local r = lm.random(10, 100)
        local bubble = Bubble {
            transform = { x = x, y = y },
            bubble    = {
                direction = 'up',
                amplitude = lm.random(10, 500)
            },
            color     = { lm.random(), lm.random(), lm.random(), 1 },
            light     = { r = r }
        }
        self.world_ecs:addEntity(bubble)
    end
end


function BubbleFactory.new(world_ecs)
    local self = {}

    self.world_ecs = world_ecs

    return setmetatable(self, { __index = BubbleFactory })
end


return BubbleFactory
