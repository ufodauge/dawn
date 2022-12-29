love.lurker = require('lib.lurker')

love.debug = require('lib.luidebug'):getInstance()
--------------------------------------------------------------
-- Debug
--------------------------------------------------------------
if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    require('lldebugger').start()
end
love.debug:activate()


--------------------------------------------------------------
-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local ls = love.sound
local la = love.audio


--------------------------------------------------------------
-- Global
--------------------------------------------------------------
love.lume   = require('lib.lume')
love.assets = require('lib.cargo').init {
    dir = 'assets',
    loaders = {
        wav = function(wav)
            return la.newSource(ls.newSoundData(wav))
        end
    },
    processors = {
        ['images/'] = function(image, filename)
            image:setFilter('nearest', 'nearest')
        end,
        ['sound/'] = function(wav, filename)
            wav:setVolume(0.1)
        end,
    }
}


--------------------------------------------------------------
-- requires
--------------------------------------------------------------
local Controller = require('class.controller'):getInstance()
local Roomy      = require('lib.roomy'):getInstance()
local Flux       = require('lib.flux')
local Coil       = require('lib.coil')


--------------------------------------------------------------
-- Scenes
--------------------------------------------------------------
local GameScene = require('scene.game')


--------------------------------------------------------------
-- local variables
--------------------------------------------------------------
local latest_error_message = nil


function love.load()
    Roomy:hook {
        exclude = { 'update', 'draw' },
    }

    love.debug:setRoomy(Roomy)
    love.debug:setScenePath('scene')

    love.graphics.setDefaultFilter('nearest', 'nearest')

    Roomy:enter(GameScene, 1)
end


function love.update(dt)
    xpcall(function()
        -- Try
        --------------------------------------------------------------
        love.debug:update(dt)

        Controller:update()

        Roomy:emit('update', dt)

        Flux.update(dt)
        Coil.update(dt)
    end, function(msg)
        -- Catch
        --------------------------------------------------------------

        if msg == latest_error_message then
            return
        end
        latest_error_message = msg

        msg = debug.traceback(msg)
        love.debug:log(msg)
        print(debug.traceback(msg))
    end)
end


function love.draw()
    love.debug.camera:set()
    Roomy:emit('draw')
    love.debug.camera:unset()

    love.debug:draw()
end


function love.focus(f)
    if f then
        love.lurker.scan()
    end
end
