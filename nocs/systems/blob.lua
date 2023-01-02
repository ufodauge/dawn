-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS     = require('lib.tiny-ecs')
local util    = require('lib.util')
local Blob    = require('class.blob.init')
local Canvas  = require('class.canvas')
local World   = require('class.world_physics')
local Lighter = require('class.world_light')
local flux    = require('lib.flux')


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

---@param e {blob: Blob, circle: ECS.CircleComponent,transform: ECS.TransformComponent, shadow_circle: any, color: ECS.ColorComponent, radius: any}
function System:onAdd(e)
    e.blob = Blob.new(
        World:get(),
        e.transform.x,
        e.transform.y,
        e.circle.r - NODE_RADIUS,
        NODE_RADIUS)


    -- shadow
    --------------------------------------------------------------
    e.shadow_circle.r = e.circle.r
    e.shadow_circle.mul = 1.2

    e.shadow_circle.body = Lighter:get():newCircle(
        e.transform.x, e.transform.y,
        e.shadow_circle.r * e.shadow_circle.mul)

    local shadow_a = e.shadow_circle.a or 1
    local a = e.color.a

    e.shadow_circle.a = 0
    e.color.a         = 0

    flux.to(
        e.shadow_circle, 1,
        { a = shadow_a })

    flux.to(
        e.color, 1,
        { a = a })
end


function System:preProcess(dt)
    if util.nullCheck(canvas_main) then
        canvas_main = Canvas:get(CANVAS_NAME_MAIN)
    end
    if util.nullCheck(canvas_col_view) then
        canvas_col_view = Canvas:get(CANVAS_NAME_COLLISION_VIEW)
    end
end


---@param e {blob: Blob, color: ECS.ColorComponent, debug_mode: boolean, shadow_circle: any, transform: ECS.TransformComponent}
---@param dt number
function System:process(e, dt)
    e.blob:update()

    e.shadow_circle.body:setPosition(e.blob.kernel_body:getPosition())
    e.shadow_circle.body:setAlpha(e.shadow_circle.a)

    lg.setCanvas(canvas_main)
    lg.setColor(
        e.color.r,
        e.color.g,
        e.color.b,
        e.color.a)
    e.blob:draw('fill')

    if e.debug_mode then
        lg.setCanvas(canvas_col_view)
        e.blob:drawDebug()
    end

    lg.setCanvas()
end


---@param e {blob: Blob, shadow_circle: any}
function System:onRemove(e)
    e.blob:destroy()

    Lighter:get():remove(e.shadow_circle.body)
end


return System
