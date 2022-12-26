-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local Canvas = require('class.canvas')
local util   = require('lib.util')
local World  = require('class.world_physics')
local Blob   = require('lib.blob')


-- local
--------------------------------------------------------------
local canvas_main                = nil
local canvas_col_view            = nil
local CANVAS_NAME_MAIN           = require('const.canvas_name').MAIN
local CANVAS_NAME_COLLISION_VIEW = require('const.canvas_name').COLLISION_VIEW
local NODE_RADIUS                = 2


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('transform', 'blob', 'color')

---@param entity {blob: Blob, circle: ECS.CircleComponent,transform: ECS.TransformComponent}
function System:onAdd(entity)
    entity.blob = Blob.new(
        World:get(),
        entity.transform.x,
        entity.transform.y,
        entity.circle.r - NODE_RADIUS,
        NODE_RADIUS)
end


function System:preProcess(dt)
    if util.nullCheck(canvas_main) then
        canvas_main = Canvas:get(CANVAS_NAME_MAIN)
    end
    if util.nullCheck(canvas_col_view) then
        canvas_col_view = Canvas:get(CANVAS_NAME_COLLISION_VIEW)
    end
end


---@param entity {blob: Blob, color: ECS.ColorComponent, debug_mode: boolean}
---@param dt number
function System:process(entity, dt)
    entity.blob:update()

    lg.setCanvas(canvas_main)
    lg.setColor(
        entity.color.r,
        entity.color.g,
        entity.color.b,
        entity.color.a)
    entity.blob:draw('fill')

    if entity.debug_mode then
        lg.setCanvas(canvas_col_view)
        entity.blob:drawDebug()
    end

    lg.setCanvas()
end


---@param entity {blob: Blob}
function System:onRemove(entity)
    entity.blob:destroy()
end


return System
