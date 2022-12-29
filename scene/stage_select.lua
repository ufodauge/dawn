--[[
TODO メインスレッドを止めない方法を模索しましょう
]]
-- requires
--------------------------------------------------------------
local ECS          = require('lib.tiny-ecs')
local Signal       = require('lib.signal')
local Canvas       = require('class.canvas')
local Loader       = require('class.loader')
local PhysicsWorld = require('class.world_physics')
local LightWorld   = require('class.world_light')
local BlackScreen  = require('class.black_screen')
-- local Camera       = require('class.camera'):getInstance()
-- local Roomy        = require('lib.roomy'):getInstance()


-- data
--------------------------------------------------------------
local level_data = nil


-- const
--------------------------------------------------------------
local CANVAS_NAME_MAIN           = require('const.canvas_name').MAIN
local CANVAS_NAME_COLLISION_VIEW = require('const.canvas_name').COLLISION_VIEW
local CANVAS_NAME_HUD            = require('const.canvas_name').HUD
local WORLD_GRAVITY_X            = require('const.physics').WORLD_GRAVITY_X
local WORLD_GRAVITY_Y            = require('const.physics').WORLD_GRAVITY_Y
local EVENT_NAME                 = require('const.event_name')


---@class StageSelectScene : Scene
local StageSelectScene = {}


-- local
--------------------------------------------------------------
---@type ECS.World
local world_ecs     = nil
---@type love.World
local world_physics = nil
local world_light   = nil
local black_screen  = nil


function StageSelectScene:enter(prev)
    Canvas:register(CANVAS_NAME_MAIN, 1, 1.0)
    Canvas:register(CANVAS_NAME_COLLISION_VIEW, 50, 1.0)
    Canvas:register(CANVAS_NAME_HUD, 100, 0)

    world_physics = PhysicsWorld:get()
    world_physics:setGravity(WORLD_GRAVITY_X, WORLD_GRAVITY_Y)

    world_ecs = ECS.world()

    -- light world
    --------------------------------------------------------------
    world_light = LightWorld:get({
        ambient = { 0.8, 0.8, 0.8 },
        shadowBlur = 10
    })
    world_light.post_shader:addEffect('scanlines')

    level_data = require(('data.level.world'))

    local systems  = Loader:systems(level_data.systems)
    local entities = Loader:entities(level_data.entities)

    for _, system in ipairs(systems) do
        world_ecs:addSystem(system)
    end
    for _, entity in ipairs(entities) do
        world_ecs:addEntity(entity)
    end

    love.debug:addFlag('collision view', false)

    black_screen = BlackScreen.new(true)
    black_screen:toggle()

    self._enter_stage = function(level)
        black_screen:toggle()
    end
    Signal.subscribe(EVENT_NAME.ENTER_TO_LEVEL, self._enter_stage)
end


function StageSelectScene:update(dt)
    Canvas:clear()

    world_physics:update(dt)
    world_ecs:update(dt)
    world_light:update(dt)
end


function StageSelectScene:draw()
    world_light:draw(function()
        Canvas:draw(0, 0, 0, 0, {
            exclude = {
                CANVAS_NAME_HUD,
                CANVAS_NAME_COLLISION_VIEW
            }
        })
    end)
    Canvas:draw(0, 0, 0, 0, {
        exclude = { CANVAS_NAME_MAIN }
    })
    -- Camera:draw(function(l, t, w, h)
    --     world_light:draw(function()
    --         Canvas:draw(l, t, w, h, {
    --             exclude = {
    --                 CANVAS_NAME_HUD,
    --                 CANVAS_NAME_COLLISION_VIEW
    --             }
    --         })
    --     end)
    --     Canvas:draw(l, t, w, h, {
    --         exclude = { CANVAS_NAME_MAIN }
    --     })
    -- end)

    black_screen:draw()
end


function StageSelectScene:leave(_, ...)
    world_ecs:clearEntities()
    world_ecs:clearSystems()

    world_ecs:update(0)

    Canvas:releaseAll()

    love.debug.debug_menu:removeCommand('goal')

    Signal.subscribe(EVENT_NAME.ENTER_TO_LEVEL, self._enter_stage)

    world_light.post_shader:removeEffect('scanlines')
end


return StageSelectScene
