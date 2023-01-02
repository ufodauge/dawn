-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local Easing = require('lib.flux').easing --[[@as flux.Easing]]


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('movable')

function System:onAdd(e)
    e.movable.from_x = e.transform.x
    e.movable.from_y = e.transform.y

    e.movable.to_x = e.transform.x + e.movable.to_x
    e.movable.to_y = e.transform.y + e.movable.to_y
end

function System:process(e, dt)
    e.movable.timer = e.movable.ongoing
        and e.movable.timer + dt
        or e.movable.timer - dt

    if e.movable.timer > e.movable.duration then
        e.movable.ongoing = false
        e.movable.timer = e.movable.duration - (e.movable.timer - e.movable.duration)
    end
    if e.movable.timer < 0 then
        e.movable.ongoing = true
        e.movable.timer = math.abs(e.movable.timer)
    end

    e.movable.result = Easing[e.movable.easing](e.movable.timer / e.movable.duration)
    e.transform.x = e.movable.result * (e.movable.to_x - e.movable.from_x) + e.movable.from_x
    e.transform.y = e.movable.result * (e.movable.to_y - e.movable.from_y) + e.movable.from_y
end


function System:onRemove(e)
end


return System
