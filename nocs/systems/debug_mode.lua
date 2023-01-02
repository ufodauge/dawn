-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local util   = require('lib.util')


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('debug_mode')


function System:process(entity, dt)
    entity.debug_mode = love.debug:getFlag('collision view')
end


return System
