local lume = love.lume

---@class MapEditor.Polar
local Polar = {}

local x, y = 0, 0

local polarColor = { lume.color('#FEFEFE') }

local camera = nil

---@param _camera any
---@return MapEditor.Polar
function Polar:new(_camera)
    local instance = {}

    instance.x, instance.y = _camera:cameraCoords(0, 0)

    camera = _camera

    return setmetatable(instance, { __index = Polar })
end


function Polar:update()
    x, y = camera:cameraCoords(0, 0)

    self.x, self.y = x, y
end


function Polar:draw()
    love.graphics.setColor(polarColor)
    love.graphics.circle('fill', x, y, 6)
    love.graphics.setColor(1, 1, 1, 1)
end


---@return integer
---@return integer
function Polar:getPosition()
    return x, y
end


local Public = {}

local SingletonInstance = nil

---@param _camera any
---@return MapEditor.Polar
function Public:getInstance(_camera)
    if SingletonInstance == nil then
        SingletonInstance = Polar:new(_camera)
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
