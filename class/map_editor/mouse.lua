local lume = love.lume

---@class MapEditor.Mouse
local Mouse = {}
local SingletonInstance = nil

local getMousePosition = love.mouse.getPosition

local camera   = nil
local actions  = {}
local wx, wy   = 0, 0
local cx, cy   = 0, 0
local owx, owy = 0, 0
local ocx, ocy = 0, 0

local frame = {
    0, 0, 0
}

local textColor = { lume.color('#101010') }


---@param _camera any
---@return MapEditor.Mouse
function Mouse:new(_camera)
    local instance = {}

    camera = _camera

    return setmetatable(instance, { __index = Mouse })
end


---@return number wx
---@return number wy
function Mouse:getWorldPosition()
    return wx, wy
end


---@return number previous wx
---@return number previous wy
function Mouse:getPrevWorldPosition()
    return owx, owy
end


---@return number previous cx
---@return number previous cy
function Mouse:getPrevPosition()
    return ocx, ocy
end


---@param dt number
function Mouse:update(dt)
    owx, owy = wx, wy
    wx, wy = camera:worldCoords(getMousePosition())

    ocx, ocy = cx, cy
    cx, cy = getMousePosition()

    for i = 1, 3 do
        -- ... -2, -1,| 0,       | 1,      | 2, 3, ...
        --  releasing | released | pressed | pressing
        --------------------------------------------------------------
        if love.mouse.isDown(i) then
            frame[i] = math.min(frame[i] > 0 and frame[i] + 1 or 1, 60)
        else
            frame[i] = math.max(frame[i] <= 0 and frame[i] - 1 or 0, -60)
        end
    end

    for _, tbl in ipairs(actions) do
        if love.mouse.isDown(tbl.button) then
            tbl.action(dt, frame[tbl.button])
        end
    end
end


function Mouse:draw()
    love.graphics.setColor(textColor)
    love.graphics.print(('mouse: %d, %d'):format(wx, wy), 10, 10)
end


---@return string
function Mouse:getText()
    return ('mouse: %d, %d'):format(wx, wy)
end


---@param _button number
---@param _action function
function Mouse:addMouseAction(_button, _action)
    actions[#actions + 1] = {
        button = _button,
        action = _action
    }
end


local Public = {}

---@param _camera any
---@return MapEditor.Mouse
function Public:getInstance(_camera)
    if SingletonInstance == nil then
        SingletonInstance = Mouse:new(_camera)
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
