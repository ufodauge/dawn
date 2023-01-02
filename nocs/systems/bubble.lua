-- shorthands
--------------------------------------------------------------
local lg = love.graphics


-- require
--------------------------------------------------------------
local Lighter = require('class.world_light')
local ECS     = require('lib.tiny-ecs')


--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('bubble')

function System:onAdd(e)
    e.animation.duration = 5
    e.animation.back     = true
    e.animation.easing   = 'quartinout'

    -- light
    --------------------------------------------------------------
    e.light.a = e.light.a or e.color.a
    e.light.r = e.light.r or e.circle.r

    e.light.body = Lighter:get():newLight(
        e.transform.x, e.transform.y,
        e.color.r * e.light.a,
        e.color.g * e.light.a,
        e.color.b * e.light.a,
        e.light.r)
    e.transform._x = e.transform.x
    e.transform._y = e.transform.y
end


function System:process(e, dt)
    if e.bubble.direction == 'up' or e.bubble.direction == 'down' then
        e.transform.x = e.transform._x + e.animation.result * e.bubble.amplitude
        if e.bubble.direction == 'up' then
            e.transform.y = e.transform.y - 2
        else
            e.transform.y = e.transform.y + 2
        end
    else
        e.transform.y = e.transform._y + e.animation.result * e.bubble.amplitude
        if e.bubble.direction == 'left' then
            e.transform.x = e.transform.x - 2
        else
            e.transform.x = e.transform.x + 2
        end
    end

    e.light.body:setPosition(e.transform.x, e.transform.y)
end


function System:onRemove(e)
    Lighter:get():remove(e.light.body)
end


return System
