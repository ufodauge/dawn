-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local World   = require('class.world_physics')
local Lighter = require('class.world_light')
local Canvas  = require('class.canvas')
local ECS     = require('lib.tiny-ecs')
local util    = require('lib.util')
local flux    = require('lib.flux')


-- local
--------------------------------------------------------------
local canvas                     = nil
local RESISTITUTION              = 0.8
local CANVAS_NAME_COLLISION_VIEW = require('const.canvas_name').COLLISION_VIEW


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll(
    'physics',
    'circle',
    ECS.requireAny('shadow_circle', 'light'))

function System:onAdd(e)
    local body = lp.newBody(
        World:get(),
        e.transform.x,
        e.transform.y,
        'static')

    local shape = lp.newCircleShape(e.circle.r)

    local fixture = lp.newFixture(body, shape)

    fixture:setRestitution(RESISTITUTION)
    fixture:setFriction(1)

    e.physics.body    = body
    e.physics.fixture = fixture

    if e.shadow_circle then
        -- shadow
        --------------------------------------------------------------
        e.shadow_circle.r = e.shadow_circle.r or e.circle.r
        e.shadow_circle.body = Lighter:get():newCircle(
            e.transform.x, e.transform.y,
            e.shadow_circle.r)

        -- section: animation
        --------------------------------------------------------------
        local a = e.color.a
        local delay = love.math.random()
        flux.to(
            e.color, 2,
            { a = a })
            :ease('linear')
            :delay(delay)

        local shadow_a = e.shadow_circle.a
        flux.to(
            e.shadow_circle, 2,
            { a = shadow_a })
            :ease('linear')
            :delay(delay)
    end
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_COLLISION_VIEW)
    end
end


function System:process(e, dt)
    if e.shadow_circle then
        e.shadow_circle.body:setPosition(e.transform.x, e.transform.y)
        e.shadow_circle.body:setAlpha(e.color.a)
    end

    lg.setCanvas(canvas)

    lg.setCanvas()
end


function System:onRemove(e)
    e.physics.fixture:destroy()
    e.physics.body:destroy()

    e.physics.fixture:release()
    e.physics.body:release()

    if e.shadow_circle then
        Lighter:get():remove(e.shadow_circle.body)
    end
end


return System
