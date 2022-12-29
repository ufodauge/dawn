-- shorthands
--------------------------------------------------------------
local lg = love.graphics


-- require
--------------------------------------------------------------
local Lighter = require('class.world_light')
local ECS     = require('lib.tiny-ecs')
local flux    = require('lib.flux')


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('light')

function System:onAdd(e)
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


    -- section: animation
    --------------------------------------------------------------
    local a = e.color.a
    local delay = love.math.random()
    flux.to(
        e.color, 2,
        { a = a })
        :ease('linear')
        :delay(delay)

    local light_a = e.light.a or 1
    local light_r = e.light.r or 1

    e.light.a, e.light.r = 0, 0
    flux.to(
        e.light, 2,
        { a = light_a, r = light_r })
        :delay(delay)

    e.light.mul = 1
    e.animation.loop = true
    e.animation.duration = 10
end


function System:preProcess(dt)
end


function System:process(e, dt)
    e.light.body:setPosition(e.transform.x, e.transform.y)
    e.light.body:setColor(
        e.color.r * e.light.a,
        e.color.g * e.light.a,
        e.color.b * e.light.a)

    e.light.body:setGlowSize(math.sin(e.animation.result * 2 * math.pi))
    e.light.body:setRange(e.light.r + e.light.r * math.sin(e.animation.result * 2 * math.pi) * 0.1)
end


function System:onRemove(e)
    Lighter:get():remove(e.light.body)
end


return System
