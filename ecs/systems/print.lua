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


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('text', 'transform')

function System:onAdd()

end


function System:onRemove()

end


function System:onModify()

end


function System:onAddToWorld()

end


function System:onRemoveFromWorld()

end


function System:preWrap()

end


function System:postWrap()

end


function System:process(entity, dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get('test_canvas')
    end

    lg.setCanvas(canvas)
    lg.setFont(entity.text.font)
    lg.print(
        entity.text.text,
        entity.transform.x,
        entity.transform.y,
        entity.transform.r,
        entity.transform.sx,
        entity.transform.sy)
    lg.setCanvas()
end


return System
