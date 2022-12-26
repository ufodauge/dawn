--------------------------------------------------------------
-- requires
--------------------------------------------------------------
local ECS    = require('lib.tiny-ecs')
local Canvas = require('class.canvas')
local Gamera = require('lib.gamera.gamera')
local Loader = require('class.loader')


---@class SampleScene : Scene
local SampleScene = {}


--------------------------------------------------------------
-- local
--------------------------------------------------------------
---@type ECS.World
local world_ecs = nil
local level_data = require('data.level.1')
local camera = Gamera.new(0, 0, 1920, 1080)


function SampleScene:enter(prev, ...)
    Canvas:register('test_canvas', 1, 0)


    world_ecs = ECS.world()

    local systems  = Loader:systems(level_data.systems)
    local entities = Loader:entities(level_data.entities)

    for _, system in ipairs(systems) do
        world_ecs:addSystem(system)
    end
    for _, entity in ipairs(entities) do
        world_ecs:addEntity(entity)
    end

    love.debug:log(function()
        return ('%d, %d'):format(camera:getPosition())
    end)
end


function SampleScene:update(dt)
    world_ecs:update(dt)

    local dx, dy = 0, 0
    if love.keyboard.isDown('left') then
        dx = dx - 1
    end
    if love.keyboard.isDown('right') then
        dx = dx + 1
    end
    if love.keyboard.isDown('up') then
        dy = dy - 1
    end
    if love.keyboard.isDown('down') then
        dy = dy + 1
    end

    local x, y = camera:getPosition()
    camera:setPosition(x + dx, y + dy)
end


function SampleScene:draw()
    camera:draw(function(l, t, w, h)
        Canvas:draw(l, t, w, h)
    end)
end


function SampleScene:leave(_, ...)
    world_ecs:clearEntities()
    world_ecs:clearSystems()

    world_ecs:update(0)

    Canvas:release('test_canvas')
end


return SampleScene
