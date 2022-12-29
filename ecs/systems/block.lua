-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local World   = require('class.world_physics')
local Canvas  = require('class.canvas')
local Lighter = require('class.world_light')
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

System.filter = ECS.requireAll('physics', 'rectangle')

function System:onAdd(e)
    local body = lp.newBody(
        World:get(),
        e.transform.x + e.rectangle.w / 2,
        e.transform.y + e.rectangle.h / 2,
        'static')

    local shape = lp.newRectangleShape(
        e.rectangle.w,
        e.rectangle.h)

    local fixture = lp.newFixture(body, shape)

    fixture:setRestitution(RESISTITUTION)
    fixture:setFriction(1)

    e.physics.body    = body
    e.physics.fixture = fixture

    -- shadow
    --------------------------------------------------------------
    e.shadow_rectangle.w = e.shadow_rectangle.w or e.rectangle.w
    e.shadow_rectangle.h = e.shadow_rectangle.h or e.rectangle.h
    e.shadow_rectangle.a = e.shadow_rectangle.a or e.color.a

    e.shadow_rectangle.body = Lighter:get():newRectangle(
        e.transform.x + e.shadow_rectangle.w / 2,
        e.transform.y + e.shadow_rectangle.h / 2,
        e.shadow_rectangle.w,
        e.shadow_rectangle.h)
    e.shadow_rectangle.body:setAlpha(e.shadow_rectangle.a)

    -- section: animation
    --------------------------------------------------------------
    local w, h  = e.rectangle.w, e.rectangle.h
    local x, y  = e.transform.x, e.transform.y
    local a     = e.color.a
    local delay = love.math.random()

    e.rectangle.w, e.rectangle.h = 100, 100
    e.transform.x, e.transform.y = x + w / 2 - 50, y + h / 2 - 50
    -- e.color.a = 0

    flux.to(
        e.rectangle, 2,
        { w = w, h = h })
        :ease('elasticinout')
        :delay(delay)

    flux.to(
        e.transform, 2,
        { x = x, y = y })
        :ease('elasticinout')
        :delay(delay)

    -- flux.to(
    --     e.color, 2,
    --     { a = a })
    --     :ease('linear')
    --     :delay(delay)
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_COLLISION_VIEW)
    end
end


function System:process(e, dt)
    e.shadow_rectangle.body:setPosition(
        e.transform.x + e.shadow_rectangle.w / 2,
        e.transform.y + e.shadow_rectangle.h / 2)
    e.shadow_rectangle.body:setAlpha(e.shadow_rectangle.a)


    lg.setCanvas(canvas)

    lg.setCanvas()
end


function System:onRemove(e)
    e.physics.fixture:destroy()
    e.physics.body:destroy()

    e.physics.fixture:release()
    e.physics.body:release()

    Lighter:get():remove(e.shadow_rectangle.body)
end


return System
