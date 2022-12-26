-- requires
--------------------------------------------------------------
local ECS          = require('lib.tiny-ecs')
local Canvas       = require('class.canvas')
local Loader       = require('class.loader')
local PhysicsWorld = require('class.world_physics')
local Camera       = require('class.camera'):getInstance()


-- data
--------------------------------------------------------------
local level_data = require('data.level.1')


-- const
--------------------------------------------------------------
local CANVAS_NAME_MAIN           = require('const.canvas_name').MAIN
local CANVAS_NAME_COLLISION_VIEW = require('const.canvas_name').COLLISION_VIEW
local WORLD_GRAVITY_X            = require('const.physics').WORLD_GRAVITY_X
local WORLD_GRAVITY_Y            = require('const.physics').WORLD_GRAVITY_Y


---@class GameScene : Scene
local GameScene = {}

-- local
--------------------------------------------------------------
---@type ECS.World
local world_ecs     = nil
local world_physics = nil


function GameScene:enter(prev, ...)
    Canvas:register(CANVAS_NAME_MAIN, 1, 1.0)
    Canvas:register(CANVAS_NAME_COLLISION_VIEW, 100, 1.0)

    world_physics = PhysicsWorld:get()
    world_physics:setGravity(WORLD_GRAVITY_X, WORLD_GRAVITY_Y)

    world_ecs = ECS.world()

    local systems  = Loader:systems(level_data.systems)
    local entities = Loader:entities(level_data.entities)

    for _, system in ipairs(systems) do
        world_ecs:addSystem(system)
    end
    for _, entity in ipairs(entities) do
        world_ecs:addEntity(entity)
    end

    love.debug:addFlag('collision view', false)
end


function GameScene:update(dt)
    Canvas:clear()

    world_physics:update(dt)
    world_ecs:update(dt)
end


function GameScene:draw()
    Camera:draw(function(l, t, w, h)
        Canvas:draw(l, t, w, h)
    end)
end


function GameScene:leave(_, ...)
    world_ecs:clearEntities()
    world_ecs:clearSystems()

    world_ecs:update(0)

    Canvas:release(CANVAS_NAME_MAIN)
    Canvas:release(CANVAS_NAME_COLLISION_VIEW)
end


return GameScene
