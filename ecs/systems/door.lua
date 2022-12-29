-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS        = require('lib.tiny-ecs')
local util       = require('lib.util')
local Signal     = require('lib.signal')
local Roomy      = require('lib.roomy'):getInstance()
local coil       = require('lib.coil')
local Canvas     = require('class.canvas')
local World      = require('class.world_physics')
local Controller = require('class.controller'):getInstance()
local GameScene  = require('scene.game')
local Text       = require('class.ui.text')


-- local
--------------------------------------------------------------
local CATEGORY         = require('const.box2d_category')
local EVENT_NAME       = require('const.event_name')
local CANVAS_NAME_MAIN = require('const.canvas_name').MAIN

---@type love.World
local world  = nil
local canvas = nil

local entered_door = false
local is_player_closer_the_door = false
local font = love.assets.font.timeburnerbold(28)
local text = Text.new('%s : enter the level', 600, 300, font, { 0, 0, 0, 1 }, function()
    return Controller:getControlConfig(Controller:getLatestControllerType(), 'cancel')
end)

--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('door')


---@param e {physics: ECS.PhysicsComponent, animation: ECS.AnimationComponent}
function System:onAdd(e)
    e.physics.fixture:setCategory(CATEGORY.DOOR)
    e.physics.fixture:setSensor(true)

    -- modify animation timer to randomize
    --------------------------------------------------------------
    e.animation.duration = 2
    e.animation.timer = love.math.random() * 2

    entered_door = false
end


function System:preProcess(dt)
    if util.nullCheck(world) then
        world = World:get()
    end
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


---@param e {door: ECS.DoorComponent, animation: ECS.AnimationComponent, color: ECS.ColorComponent, transform: ECS.TransformComponent, circle: ECS.CircleComponent}
---@param dt number
function System:process(e, dt)
    is_player_closer_the_door = false
    if entered_door or world:getContacts() == 0 then
        return
    end

    ---@type love.Contact[]
    local contacts = world:getContacts()

    for _, contact in ipairs(contacts) do
        local fix_a, fix_b = contact:getFixtures()
        local cat_a = fix_a:getCategory()
        local cat_b = fix_b:getCategory()

        if cat_a == CATEGORY.PLAYER and cat_b == CATEGORY.DOOR or
            cat_b == CATEGORY.PLAYER and cat_a == CATEGORY.DOOR then

            if Controller:pressed('cancel') then
                entered_door = true
                coil.add(function()
                    Signal.emit(EVENT_NAME.ENTER_TO_LEVEL, e.door.level)
                    coil.wait(2)
                    Roomy:enter(GameScene, e.door.level)
                end)
            end

            is_player_closer_the_door = true

            break
        end
    end

    lg.setCanvas(canvas)
    lg.push()

    lg.translate(
        e.transform.x + math.cos(e.animation.result * 2 * math.pi - math.pi / 2) * e.door.orbital_radius,
        e.transform.y + math.sin(e.animation.result * 2 * math.pi - math.pi / 2) * e.door.orbital_radius)
    lg.setColor(e.color.r, e.color.g, e.color.b, e.color.a)
    lg.circle('fill', 0, 0, e.door.satellite_radius)

    lg.pop()

    if is_player_closer_the_door then
        text:draw()
    end
    lg.setCanvas()
end


function System:onRemove(e)

end


return System
