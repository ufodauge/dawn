-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lp = love.physics


-- require
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local util   = require('lib.util')
local Signal = require('lib.signal')
local Canvas = require('class.canvas')
local World  = require('class.world_physics')



-- local
--------------------------------------------------------------
local CATEGORY         = require('const.box2d_category')
local EVENT_NAME       = require('const.event_name')
local CANVAS_NAME_MAIN = require('const.canvas_name').MAIN
---@type love.World
local world            = nil
local canvas           = nil


--------------------------------------------------------------
-- System
--------------------------------------------------------------
local System = ECS.processingSystem()

System.filter = ECS.requireAll('goal')


---@param e {physics: ECS.PhysicsComponent, animation: ECS.AnimationComponent}
function System:onAdd(e)
    e.physics.fixture:setCategory(CATEGORY.GOAL)
    e.physics.fixture:setSensor(true)

    -- modify animation timer to randomize
    --------------------------------------------------------------
    e.animation.duration = 2
    e.animation.timer = love.math.random() * 2
end


function System:preProcess(dt)
    if util.nullCheck(world) then
        world = World:get()
    end
    if util.nullCheck(canvas) then
        canvas = Canvas:get(CANVAS_NAME_MAIN)
    end
end


---@param e {goal: ECS.GoalComponent, animation: ECS.AnimationComponent, color: ECS.ColorComponent, transform: ECS.TransformComponent, circle: ECS.CircleComponent}
---@param dt number
function System:process(e, dt)
    if e.goal.goaled or
        world:getContactCount() == 0 then
        return
    end

    ---@type love.Contact[]
    local contacts = world:getContacts()

    for _, contact in ipairs(contacts) do
        local fix_a, fix_b = contact:getFixtures()
        local cat_a = fix_a:getCategory()
        local cat_b = fix_b:getCategory()

        if cat_a == CATEGORY.PLAYER and cat_b == CATEGORY.GOAL or
            cat_b == CATEGORY.PLAYER and cat_a == CATEGORY.GOAL then

            Signal.emit(EVENT_NAME.GOALED)

            e.goal.goaled = true
            break
        end
    end

    lg.setCanvas(canvas)
    lg.push()

    lg.translate(
        e.transform.x + math.cos(e.animation.result * 2 * math.pi - math.pi / 2) * e.goal.orbital_radius,
        e.transform.y + math.sin(e.animation.result * 2 * math.pi - math.pi / 2) * e.goal.orbital_radius)
    lg.setColor(e.color.r, e.color.g, e.color.b, e.color.a)
    lg.circle('fill', 0, 0, e.goal.satellite_radius)

    lg.pop()
    lg.setCanvas()
end


function System:onRemove(e)

end


return System
