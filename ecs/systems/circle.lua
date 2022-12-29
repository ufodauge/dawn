-- shorthands
--------------------------------------------------------------
local lg = love.graphics


-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local util   = require('lib.util')
local Canvas = require('class.canvas')


-- local
--------------------------------------------------------------
local canvas = nil
local CANVAS_NAME_MAIN = require('const.canvas_name').MAIN


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

-- System.filter = ECS.requireAll(
--     'transform',
--     'color',
--     'circle',
--     ECS.rejectAny('blob',
--         ECS.rejectAll('light', 'goal')))
System.filter = ECS.filter('transform&color&circle&!(blob|!(light&goal)|!(light&door))')

function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


function System:process(entity, dt)
    lg.setCanvas(canvas)

    lg.setColor(
        entity.color.r,
        entity.color.g,
        entity.color.b,
        entity.color.a)
    lg.circle(
        'fill',
        entity.transform.x,
        entity.transform.y,
        entity.circle.r)

    lg.setCanvas()
end


function System:onRemove(entity)

end


return System
