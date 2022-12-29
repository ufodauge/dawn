-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS               = require('lib.tiny-ecs')
local util              = require('lib.util')
local quadout           = require('lib.easing.quad').o
local Controller        = require('class.controller'):getInstance()
local Canvas            = require('class.canvas')
local Camera            = require('class.camera'):getInstance()
local flux              = require('lib.flux')
local coil              = require('lib.coil')
local Signal            = require('lib.signal')
local EVENT_NAME_GOALED = require('const.event_name').GOALED


-- local
--------------------------------------------------------------
local CATEGORY = require('const.box2d_category')

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

---@param e {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent, color: ECS.ColorComponent}
function System:onAdd(e)
    e.player.controllable = false
    e.color.a = 0
    coil.add(function()
        coil.wait(2)
        e.player.controllable = true
        flux.to(e.color, 1, {
            a = 1
        })
        self._goaled = function(time)
            e.player.controllable = false
        end
        Signal.subscribe(EVENT_NAME_GOALED, self._goaled)
    end)

    e.blob:setCategory(CATEGORY.PLAYER)

    e.player_ui.tracker = SecondOrderDynamics.new(
        SOC_F, SOC_Z, SOC_R,
        Vector(e.transform.x, e.transform.y))

    e.player_ui.x, e.player_ui.y = e.transform.x, e.transform.y
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


---@param e {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent, color: ECS.ColorComponent}
---@param dt number
function System:process(e, dt)
    -- player ui
    --------------------------------------------------------------
    local vec = e.player_ui.tracker:update(
        dt,
        Vector(e.blob.kernel_body:getPosition()))

    -- track player
    --------------------------------------------------------------
    Camera:setPosition(vec.x, vec.y)

    lg.setCanvas(canvas)
    lg.push()
    if e.player.controllable then
        lg.translate(vec.x, vec.y)
        local default_line_width = lg.getLineWidth()

        lg.setLineWidth(1)

        -- strength ui
        --------------------------------------------------------------
        lg.setColor(
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a)
        lg.circle('fill',
            POP_STRENGTH_UI_X_REL,
            POP_STRENGTH_UI_Y_REL,
            POP_STRENGTH_UI_RADIUS * e.player.pop_strength_rate)
        lg.setColor(1, 1, 1, 1)
        lg.circle('line',
            POP_STRENGTH_UI_X_REL,
            POP_STRENGTH_UI_Y_REL,
            POP_STRENGTH_UI_RADIUS)

        -- angle ui
        --------------------------------------------------------------
        lg.rotate(e.player.pop_angle)
        lg.setColor(
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a)
        lg.polygon('fill', POP_ANGLE_UI_POINTS)

        lg.setLineWidth(default_line_width)
    end
    lg.pop()

    lg.setCanvas()


    -- player
    --------------------------------------------------------------
    if not e.player.controllable then
        return
    end

    -- angle controlls
    --------------------------------------------------------------
    local axis_x, axis_y = Controller:get('move')
    if axis_x == 0 and axis_y == 0 then
        -- tilt angle
        --------------------------------------------------------------
        if Controller:down('tilt_left') then
            e.player.pop_angle = e.player.pop_angle - math.pi / 128
        end
        if Controller:down('tilt_right') then
            e.player.pop_angle = e.player.pop_angle + math.pi / 128
        end

    else

        -- direction angle
        --------------------------------------------------------------
        e.player.pop_angle = -math.atan2(axis_x, axis_y) + math.pi / 2

    end


    -- jump controlls
    --------------------------------------------------------------
    if Controller:released('action') then
        e.blob.kernel_body:applyLinearImpulse(
            e.player.pop_strength * math.cos(e.player.pop_angle) * e.player.pop_strength_rate,
            e.player.pop_strength * math.sin(e.player.pop_angle) * e.player.pop_strength_rate)
    end


    if Controller:down('action') then
        e.player.time = (e.player.time + dt) % 1
    else
        e.player.time = 0
    end
    e.player.pop_strength_rate = quadout(e.player.time)
end


---@param e {blob: Blob, transform: ECS.TransformComponent, player: ECS.PlayerComponent, player_ui: ECS.PlayerUIComponent}
function System:onRemove(e)
    Signal.unsubscribe(EVENT_NAME_GOALED, self._goaled)
end


return System
