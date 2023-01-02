local lume = love.lume
local lg   = love.graphics

---@class MapEditor.Grids
local Grids = {}
local SingletonInstance = nil

local camera = nil
local border = nil

local cellSize = 30

local gridColor  = { lume.color('#DDDDDD') }
local polarColor = { lume.color('#FEFEFE') }


---@param _camera any
---@param _border MapEditor.Border
---@return MapEditor.Grids
function Grids:new(_camera, _border)
    local instance = {}

    camera = _camera
    border = _border

    return setmetatable(instance, { __index = Grids })
end


---@param _cellSize integer
function Grids:setCellSize(_cellSize)
    cellSize = _cellSize
end


---@return integer
function Grids:getCellSize()
    return cellSize
end


function Grids:update(dt)

end


function Grids:draw()
    lg.setLineWidth(1 / camera.scale)

    local x = border.left
    while true do
        x = x + cellSize - (x % cellSize)
        if x > border.right then
            break
        end

        if x % (cellSize * 15) == 0 then
            lg.setColor(polarColor)
        else
            lg.setColor(gridColor)
        end

        lg.line(x, border.top, x, border.bottom)
    end

    local y = border.top
    while true do
        y = y + cellSize - (y % cellSize)
        if y > border.bottom then
            break
        end

        if y % (cellSize * 15) == 0 then
            lg.setColor(polarColor)
        else
            lg.setColor(gridColor)
        end

        lg.line(border.left, y, border.right, y)
    end
end


local Public = {}

---@param _camera any
---@param _border MapEditor.Border
---@return MapEditor.Grids|unknown
function Public:getInstance(_camera, _border, _polar)
    if SingletonInstance == nil then
        SingletonInstance = Grids:new(_camera, _border)
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
