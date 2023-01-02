-- require
--------------------------------------------------------------
local ECS = require('lib.tiny-ecs')
local Easing = require('lib.flux').easing --[[@as flux.Easing]]


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('animation')


---@param e {animation: ECS.AnimationComponent}
---@param dt number
function System:process(e, dt)
    if e.animation.loop then
        if e.animation.back then
            if e.animation.ongoing then
                if e.animation.timer + dt > e.animation.duration then
                    e.animation.timer = 2 * e.animation.duration - (e.animation.timer + dt)
                else
                    e.animation.timer = e.animation.timer + dt
                end
            else
                if e.animation.timer - dt < 0 then
                    e.animation.timer = math.abs(e.animation.timer - dt)
                else
                    e.animation.timer = e.animation.timer - dt
                end
            end
        else
            e.animation.timer = (e.animation.timer + dt) % e.animation.duration
        end
    else
        e.animation.timer = e.animation.timer + dt > e.animation.duration
            and e.animation.duration
            or e.animation.timer + dt
    end

    e.animation.percent = e.animation.timer / e.animation.duration
    e.animation.result = Easing[e.animation.easing](e.animation.percent)
end


return System
