local Lume = require('lib.lume')

---@class MapEditor.Cursor
local Cursor = {}
local SingletonInstance = nil

local mouse = nil

local cellSize = 30

local fillColor = { Lume.color('#FBB3B3') }
local lineColor = { Lume.color('#FB3333') }

local cx, cy = 0, 0


---@param _mouse MapEditor.Mouse
---@return MapEditor.Cursor
function Cursor:new(_mouse)
    local instance = {}

    mouse = _mouse

    return setmetatable(instance, { __index = Cursor })
end


---@param _cellSize integer
function Cursor:setCellSize(_cellSize)
    cellSize = _cellSize
end


---@return integer
function Cursor:getCellSize()
    return cellSize
end


---@return integer
---@return integer
function Cursor:getHoverCellIndex()
    return cx / cellSize, cy / cellSize
end


---@param dt number
function Cursor:update(dt)
    local wx, wy = mouse:getWorldPosition()

    cx = wx - (wx % cellSize)
    cy = wy - (wy % cellSize)
end


function Cursor:draw()
    love.graphics.setColor(fillColor)
    love.graphics.rectangle('fill', cx, cy, cellSize, cellSize)

    love.graphics.setColor(lineColor)
    love.graphics.rectangle('line', cx, cy, cellSize, cellSize)
end


local Public = {}

---@param _mouse MapEditor.Mouse
---@return MapEditor.Cursor
function Public:getInstance(_mouse)
    if SingletonInstance == nil then
        SingletonInstance = Cursor:new(_mouse)
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
