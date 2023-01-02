-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local Camera = require('class.camera'):getInstance()
local Canvas = require('class.canvas')


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('background')


function System:onAdd(entity)
    Camera:setWorld(
        entity.transform.x,
        entity.transform.y,
        entity.rectangle.w,
        entity.rectangle.h)

    Canvas:setCanvasSize(
        entity.rectangle.w,
        entity.rectangle.h)
end


function System:onRemove(entity)
    local w, h = love.window.getMode()
    Camera:setWorld(0, 0, w, h)
end


return System
