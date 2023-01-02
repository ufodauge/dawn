local lume = love.lume
local lg = love.graphics

---@class MapEditor.Tiles
local Tiles = {}
local SingletonInstance = nil

---@alias MapEditor.TileType {type: string, color: number[], data_type?: "point"|"rectangle", singleton?: boolean}

---@type MapEditor.TileType[]
local types = {

}

---@alias MapEditor.VectorTileMap {index: integer, x: integer, y: integer, w?: integer, h?: integer}

---@type MapEditor.VectorTileMap[]
local map = {

}

local width    = 10
local height   = 10
local cellSize = 30

local voidTileColor = { lume.color('#CCCCCC') }
local borderColor = { lume.color('#EE7777') }


---@return MapEditor.Tiles
function Tiles:new()
    local instance = {}

    map = {}

    instance.types = types
    instance.map = map

    return setmetatable(instance, { __index = Tiles })
end


---@param dt number
function Tiles:update(dt)

end


---@param tileTypeTable table<string, string>[]
function Tiles:setTileTypes(tileTypeTable)
    for index, tileType in ipairs(tileTypeTable) do
        types[index] = {}
        for key, value in pairs(tileType) do
            if key == 'color' then
                types[index][key] = { lume.color(value) }
            else
                types[index][key] = value
            end
        end
    end
end


---@return table<string, number[]|string>[]
function Tiles:getTileTypes()
    return types
end


---@param index integer
---@return table<string, number[]|string>
function Tiles:getTileType(index)
    return types[index]
end


---@param tileMap integer[]|MapEditor.VectorTileMap[]
function Tiles:setTileMap(tileMap)
    for index, value in ipairs(tileMap) do
        map[index] = value
    end
end


---@return integer[]
function Tiles:getTileMap()
    return map
end


---@param cx integer
---@param cy integer
---@param i integer
---@param f? integer
function Tiles:set(cx, cy, i, f)
    if types[i].data_type == 'rectangle' then
        if f == 1 then
            -- on pressed
            --------------------------------------------------------------
            map[#map + 1] = {
                index = i,
                x = cx,
                y = cy,
                w = 1,
                h = 1
            }
        elseif f > 1 then
            -- on pressing
            --------------------------------------------------------------
            map[#map].w = (cx + 1) - map[#map].x
            map[#map].h = (cy + 1) - map[#map].y
        end
    elseif f == 1 then
        -- assume data type is point
        --------------------------------------------------------------

        -- check if singleton tile
        --------------------------------------------------------------
        if types[i].singleton then
            for idx, tile in ipairs(map) do
                if tile.index == i then
                    table.remove(map, idx)
                    break
                end
            end
        end

        map[#map + 1] = {
            index = i,
            x = cx,
            y = cy
        }
    end

    -- local index = cx + cy * width + 1

    -- if singletons[i] and f == 1 then
    --     map[index] = i
    --     if singletons[i] ~= 0 then
    --         map[singletons[i]] = 0
    --     end
    --     singletons[i] = index
    -- elseif not singletons[i] then
    --     map[index] = i
    -- end
end


---@param cx integer
---@param cy integer
function Tiles:deleteTile(cx, cy)
    for idx, tile in ipairs(map) do
        if cx == tile.x and cy == tile.y then
            table.remove(map, idx)
            break
        end
    end
end


---@param cx integer
---@param cy integer
---@return MapEditor.VectorTileMap
function Tiles:get(cx, cy)
    for _, tile in ipairs(map) do
        if tile.x == cx and tile.y == cy then
            return tile
        end
    end
    return {}
end


---@param _cellSize integer
function Tiles:setCellSize(_cellSize)
    cellSize = _cellSize
end


---@param _width integer
---@param _height integer
function Tiles:setBoardSize(_width, _height)
    width, height = _width, _height
end


---@return integer
---@return integer
function Tiles:getBoardSize()
    return width, height
end


---@return integer
function Tiles:getCellSize()
    return cellSize
end


---@param cx integer
---@param cy integer
---@return boolean
function Tiles:isInValidArea(cx, cy)
    return (cx >= 0 and cx < width)
        and (cy >= 0 and cy < height)
end


function Tiles:draw()
    -- draw base
    --------------------------------------------------------------
    lg.setColor(voidTileColor)
    lg.rectangle('fill', 0, 0, cellSize * width, cellSize * height)


    for _, tile in ipairs(map) do
        lg.setColor(types[tile.index].color)

        if types[tile.index].data_type == 'rectangle' then
            lg.rectangle(
                'fill',
                tile.x * cellSize,
                tile.y * cellSize,
                tile.w * cellSize,
                tile.h * cellSize)
            lg.setColor(0.8, 0, 0, 0.7)
            lg.rectangle(
                'fill',
                tile.x * cellSize,
                tile.y * cellSize,
                cellSize,
                cellSize)
        elseif types[tile.index].data_type == 'point' then
            lg.rectangle(
                'fill',
                tile.x * cellSize,
                tile.y * cellSize,
                cellSize,
                cellSize)
        end
    end

    -- -- Blocks
    -- for y = 0, height - 1 do
    --     for x = 0, width - 1 do
    --         local i = map[y * width + x + 1]

    --         if i > 0 then
    --             love.graphics.setColor(types[i].color)
    --         else
    --             love.graphics.setColor(voidTileColor)
    --         end

    --         love.graphics.rectangle('fill', x * cellSize, y * cellSize, cellSize, cellSize)
    --     end
    -- end

    -- Border
    love.graphics.setColor(borderColor)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 0, 0, width * cellSize, height * cellSize)
    love.graphics.setLineWidth(1)
end


local Public = {}

---@return MapEditor.Tiles
function Public:getInstance()
    if SingletonInstance == nil then
        SingletonInstance = Tiles:new()
    end

    return SingletonInstance
end


function Public:delete()
    SingletonInstance = nil
end


return Public
