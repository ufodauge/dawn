-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS        = require('lib.tiny-ecs')
local util       = require('lib.util')
local quadout    = require('lib.easing.quad').o
local Controller = require('class.controller'):getInstance()
local Canvas     = require('class.canvas')
local Camera     = require('class.camera'):getInstance()


-- local
--------------------------------------------------------------
local CATEGORY = require('data.box2d_category')

local SecondOrderDynamics = require('lib.sos').SecondOrderDynamics
local Vector              = require('lib.sos').Vector

local POP_ANGLE_UI_POINTS    = { 60, 0, 45, -10, 45, 10 }
local POP_STRENGTH_UI_X_REL  = 70
local POP_STRENGTH_UI_Y_REL  = -70
local POP_STRENGTH_UI_RADIUS = 30

local SOC_F = 2.808
local SOC_Z = 1.538
local SOC_R = 1.423

local canvas = nil
local CANVAS_NAME_MAIN = require('const.canvas_name').MAIN


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('player', 'player_ui')

---@param entity {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent}
function System:onAdd(entity)
    entity.blob:setCategory(CATEGORY.PLAYER)

    entity.player_ui.tracker = SecondOrderDynamics.new(
        SOC_F, SOC_Z, SOC_R,
        Vector(entity.transform.x, entity.transform.y))

    entity.player_ui.x, entity.player_ui.y = entity.transform.x, entity.transform.y
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


---@param entity {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent, color: ECS.ColorComponent}
---@param dt number
function System:process(entity, dt)
    -- player ui
    --------------------------------------------------------------
    local vec = entity.player_ui.tracker:update(
        dt,
        Vector(entity.blob.kernel_body:getPosition()))

    -- track player
    --------------------------------------------------------------
    Camera:setPosition(vec.x, vec.y)

    lg.setCanvas(canvas)
    lg.push()
    do
        lg.translate(vec.x, vec.y)
        local default_line_width = lg.getLineWidth()

        lg.setLineWidth(1)

        -- strength ui
        --------------------------------------------------------------
        lg.setColor(
            entity.color.r,
            entity.color.g,
            entity.color.b,
            entity.color.a)
        lg.circle('fill',
            POP_STRENGTH_UI_X_REL,
            POP_STRENGTH_UI_Y_REL,
            POP_STRENGTH_UI_RADIUS * entity.player.pop_strength_rate)
        lg.setColor(1, 1, 1, 1)
        lg.circle('line',
            POP_STRENGTH_UI_X_REL,
            POP_STRENGTH_UI_Y_REL,
            POP_STRENGTH_UI_RADIUS)

        -- angle ui
        --------------------------------------------------------------
        lg.rotate(entity.player.pop_angle)
        lg.setColor(
            entity.color.r,
            entity.color.g,
            entity.color.b,
            entity.color.a)
        lg.polygon('fill', POP_ANGLE_UI_POINTS)

        lg.setLineWidth(default_line_width)
    end
    lg.pop()

    lg.setCanvas()


    -- player
    --------------------------------------------------------------
    if not entity.player.controllable then
        return
    end

    -- angle controlls
    --------------------------------------------------------------
    local axis_x, axis_y = Controller:get('move')
    if axis_x == 0 and axis_y == 0 then
        -- tilt angle
        --------------------------------------------------------------
        if Controller:down('tilt_left') then
            entity.player.pop_angle = entity.player.pop_angle - math.pi / 128
        end
        if Controller:down('tilt_right') then
            entity.player.pop_angle = entity.player.pop_angle + math.pi / 128
        end

    else

        -- direction angle
        --------------------------------------------------------------
        entity.player.pop_angle = -math.atan2(axis_x, axis_y) + math.pi / 2

    end


    -- jump controlls
    --------------------------------------------------------------
    if Controller:released('action') then
        entity.blob.kernel_body:applyLinearImpulse(
            entity.player.pop_strength * math.cos(entity.player.pop_angle) * entity.player.pop_strength_rate,
            entity.player.pop_strength * math.sin(entity.player.pop_angle) * entity.player.pop_strength_rate)
    end


    if Controller:down('action') then
        entity.player._time = (entity.player._time + dt) % 1
    else
        entity.player._time = 0
    end
    entity.player.pop_strength_rate = quadout(entity.player._time)
end


---@param entity {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent}
function System:onRemove(entity)

end


return System
