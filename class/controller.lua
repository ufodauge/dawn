--------------------------------------------------------------
-- shorthands
--------------------------------------------------------------
local lf = love.filesystem


--------------------------------------------------------------
-- requires
--------------------------------------------------------------
local Baton = require 'lib.baton'


---@class Controller
---@field config table
local Controller = {}

function Controller:update(dt)
    self.baton:update()
end


function Controller:draw()

end


function Controller:setConfig(filepath)
    local config = lf.load(filepath)()
    self.baton = Baton.new(config)
end


---@return table
function Controller:getConfig()
    return self.config
end


---@param key_type? "keyboard"|"joystick"
---@return table
function Controller:getControlConfig(key_type)
    local control_conf = love.lume.deepclone(self.config.controls)

    local pattern = nil
    if key_type == 'keyboard' then
        pattern = 'key:(%w+)'
    elseif key_type == 'joystick' then
        pattern = 'button:(%w+)'
    else
        error('unreachable')
    end

    for key, tbl in pairs(control_conf) do
        for _, str in ipairs(tbl) do
            local nstr, cnt = str:gsub(pattern, '%1')
            if cnt > 0 then
                control_conf[key] = nstr
            end
        end
    end

    return control_conf
end


---get latest input controller type
---@return "keyboard"|"joystick"
function Controller:getLatestControllerType()
    return self.latest_controller_type
end


--#region baton wrapper

---gets whether a control or axis pair was pressed this frame
---@param name string
---@return boolean
function Controller:pressed(name)
    return self.baton:pressed(name)
end


---gets whether a control or axis pair was released this frame
---@param name string
---@return boolean
function Controller:released(name)
    return self.baton:released(name)
end


---gets whether a control or axis pair is "held down"
---@param name string
---@return boolean
function Controller:down(name)
    return self.baton:down(name)
end


---gets the currently active device (either "kbm", "joy", or "none").
---this is useful for displaying instructional text.
---you may have a menu that says "press ENTER to confirm"
---or "press A to confirm" depending on whether the player is
---using their keyboard or gamepad.
---this function allows you to detect which they used most recently.
---@return string
function Controller:getActiveDevice()
    return self.baton:getActiveDevice()
end


---gets the value of a control or axis pair without deadzone applied
---@param name string
---@return number, number|nil
function Controller:getRaw(name)
    return self.baton:getRaw(name)
end


---gets the value of a control or axis pair with deadzone applied
---@param name string
---@return number, number|nil
function Controller:get(name)
    return self.baton:get(name)
end


--#endregion baton wrapper

---@return Controller
function Controller.new()
    local obj = {}

    obj.config = lf.load('data/key_config.lua')()
    obj.baton = Baton.new(obj.config)


    obj.latest_controller_type = 'keyboard'
    local _kerpressed = love.kerpressed or function() end
    function love.kerpressed(key, scancode, isrepeat)
        _kerpressed(key, scancode, isrepeat)
        obj.latest_controller_type = 'keyboard'
    end


    local _gamepadpressed = love.gamepadpressed or function() end
    function love.gamepadpressed(key, scancode, isrepeat)
        _gamepadpressed(key, scancode, isrepeat)
        obj.latest_controller_type = 'gamepad'
    end


    local _joystickpressed = love.joystickpressed or function() end
    function love.joystickpressed(key, scancode, isrepeat)
        _joystickpressed(key, scancode, isrepeat)
        obj.latest_controller_type = 'joystick'
    end


    return setmetatable(obj, { __index = Controller })
end


--------------------------------------------------------------
-- Export
--------------------------------------------------------------
local Export = {}
local instance = nil


---@return Controller
function Export:getInstance()
    if instance == nil then
        instance = Controller.new()
    end

    return instance
end


return Export
