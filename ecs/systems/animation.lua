-- require
--------------------------------------------------------------
local ECS = require('lib.tiny-ecs')
local Easing = require('lib.flux').easing --[[@as flux.Easing]]


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('animation')


---@param entity {animation: ECS.AnimationComponent}
---@param dt number
function System:process(entity, dt)
    if entity.animation.loop then
        entity.animation.timer = (entity.animation.timer + dt) % entity.animation.duration
    else
        entity.animation.timer = entity.animation.timer + dt > entity.animation.duration
            and entity.animation.duration
            or entity.animation.timer + dt
    end

    entity.animation.percent = entity.animation.timer / entity.animation.duration
    entity.animation.result = Easing[entity.animation.easing](entity.animation.percent)
end


return System
