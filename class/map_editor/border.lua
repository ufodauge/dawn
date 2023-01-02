---@class MapEditor.Border
---@field left   number
---@field right  number
---@field top    number
---@field bottom number
local Border = {}

local left   = 0
local right  = 0
local top    = 0
local bottom = 0

local camera = nil
local getMode = love.window.getMode

---@param _camera any
---@return MapEditor.Border
function Border:new(_camera)
    local instance = {}

    camera = _camera

    return setmetatable(instance, { __index = Border })
end


function Border:update()
    local width, height = getMode()

    left, top     = camera:worldCoords(0, 0)
    right, bottom = camera:worldCoords(width, height)

    self.left, self.top     = left, top
    self.right, self.bottom = right, bottom
end


---@param _left integer
---@param _top integer
---@param _right integer
---@param _bottom integer
function Border:setBorders(_left, _top, _right, _bottom)
    left, top, right, bottom = _left, _top, _right, _bottom
end


---@return integer
---@return integer
---@return integer
---@return integer
function Border:getBorders()
    return left, top, right, bottom
end


local Public = {}


---@param camera any
---@return MapEditor.Border
function Public:getInstance(camera)
    if SingletonInstance == nil then
        SingletonInstance = Border:new(camera)
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
