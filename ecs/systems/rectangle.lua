-- shorthands
--------------------------------------------------------------
local lg = love.graphics


-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local Canvas = require('class.canvas')
local util   = require('lib.util')


-- local
--------------------------------------------------------------
local canvas = nil
local CANVAS_NAME_MAIN = require('const.canvas_name').MAIN


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local PhysicsSystem = ECS.processingSystem()

PhysicsSystem.filter = ECS.requireAll('transform', 'color', 'rectangle')


function PhysicsSystem:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


function PhysicsSystem:process(entity, dt)
    lg.setCanvas(canvas)

    lg.setColor(
        entity.color.r,
        entity.color.g,
        entity.color.b,
        entity.color.a)
    lg.rectangle(
        'fill',
        entity.transform.x,
        entity.transform.y,
        entity.rectangle.w,
        entity.rectangle.h,
        entity.rectangle.rx,
        entity.rectangle.ry)

    lg.setCanvas()
end


function PhysicsSystem:onRemove(entity)

end


return PhysicsSystem
