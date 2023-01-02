local lg = love.graphics


-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local util   = require('lib.util')
local Signal = require('lib.signal')
local Roomy  = require('lib.roomy'):getInstance()
local Canvas = require('class.canvas')

local ResultScene               = require('scene.result')
local CANVAS_NAME_HUD           = require('const.canvas_name').HUD
local EVENT_NAME_GOALED         = require('const.event_name').GOALED
local EVENT_NAME_SEND_GOAL_TIME = require('const.event_name').SEND_GOAL_TIME


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.filter('transform&timer&text')

local canvas = nil


---@param e {timer: ECS.TimerComponent, text: ECS.TextComponent, color: ECS.ColorComponent}
function System:onAdd(e)
    e.text.content = '%02d:%02d.%02d'
    e.text.font = love.assets.font.timeburnerbold(20)

    self._goaled = function()
        e.timer.running = false
        e.color.a = 0
        Roomy:push(ResultScene, e.timer.time)
    end
    Signal.subscribe(EVENT_NAME_GOALED, self._goaled)
end


function System:preProcess(dt)
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_HUD)
    end
end


---@param e {timer: ECS.TimerComponent, text: ECS.TextComponent, transform: ECS.TransformComponent, color: ECS.ColorComponent}
---@param dt number
function System:process(e, dt)
    if not e.timer.running then
        return
    end

    e.timer.time = util.clampTime(e.timer.time + dt)

    lg.setCanvas(canvas)

    lg.setFont(e.text.font)
    lg.setColor(
        e.color.r,
        e.color.g,
        e.color.b,
        e.color.a)
    lg.print(e.text.content:format(
        math.floor(e.timer.time / 60),
        math.floor(e.timer.time % 60),
        math.floor((e.timer.time % 1) * 100)),
        e.transform.x, e.transform.y)

    lg.setCanvas()
end


function System:onRemove(e)
    Signal.unsubscribe(EVENT_NAME_GOALED, self._goaled)
end


return System
