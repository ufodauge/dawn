-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local World  = require('class.world_physics')
local Canvas = require('class.canvas')
local ECS    = require('lib.tiny-ecs')
local util   = require('lib.util')


-- local
--------------------------------------------------------------
local canvas                     = nil
local RESISTITUTION              = 0.8
local CANVAS_NAME_COLLISION_VIEW = require('const.canvas_name').COLLISION_VIEW


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('physics')

function System:onAdd(entity)
    local body = lp.newBody(
        World:get(),
        entity.transform.x + entity.rectangle.w / 2,
        entity.transform.y + entity.rectangle.h / 2,
        'static')

    local shape = lp.newRectangleShape(
        entity.rectangle.w,
        entity.rectangle.h)

    local fixture = lp.newFixture(body, shape)

    fixture:setRestitution(RESISTITUTION)
    fixture:setFriction(1)

    entity.physics.body    = body
    entity.physics.fixture = fixture
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_COLLISION_VIEW)
    end
end


function System:process(entity, dt)
    lg.setCanvas(canvas)

    lg.setCanvas()
end


function System:onRemove(entity)
    entity.physics.fixture:destroy()
    entity.physics.body:destroy()

    entity.physics.fixture:release()
    entity.physics.body:release()
end


return System
