-- requires & shorthands
--------------------------------------------------------------
local lume       = love.lume
local lg         = love.graphics
local lw         = love.window
local Camera     = require('lib.hump.camera')
local LoveFrames = require('lib.loveframes')

local Comfort = require('class.comfort')
local Mouse   = require('class.map_editor.mouse')
local Border  = require('class.map_editor.border')
local Polar   = require('class.map_editor.polar')
local Tiles   = require('class.map_editor.tiles')
local Grids   = require('class.map_editor.grids')
local Cursor  = require('class.map_editor.cursor')


-- instances
--------------------------------------------------------------
local mouse  = nil
local border = nil
local polar  = nil
local tiles  = nil
local grids  = nil
local cursor = nil

local hud    = {}
local camera = nil

-- constants
--------------------------------------------------------------
local json_content     = require('const.map_format')
local TOOLBAR_HEIGHT   = 20
local STAGE_WIDTH      = 40
local STAGE_HEIGHT     = 20
local COLOR_BACKGROUND = { lume.color('#666666') }


-- states
--------------------------------------------------------------
local states = {
    hud_spread_index    = 0,
    selected_tile_index = 1,
    drawing_tile_index  = 1,
    opening_file_name   = '',
    camera_scale        = 1
}


local function convertToLevelData(content)
    local result = ''

    local cell_size  = content.cell_size
    local tile_types = content.tile_types
    local tile_map   = content.tile_map
    for i, tile in ipairs(tile_map) do
        for j, tile_type in ipairs(tile_types) do
            if tile.index == j then
                if tile_type.type == 'block' then
                    result = result .. ([[{
            _name     = 'block',
            transform = { x = %d, y = %d },
            rectangle = { w = %d, h = %d },
            color     = { hex2tbl(color_palette.pink['300']) },
        },]]         ):format(
                        tile.x * cell_size,
                        tile.y * cell_size,
                        tile.w * cell_size,
                        tile.h * cell_size)
                elseif tile_type.type == 'player_spawner' then
                    result = result .. ([[{
            _name     = 'blob',
            transform = { x = %d, y = %d },
            circle    = { r = 26  },
            color     = { hex2tbl(color_palette.pink['400']) },
        },]]         ):format(
                        tile.x * cell_size,
                        tile.y * cell_size)
                elseif tile_type.type == 'goal' then
                    result = result .. ([[{
            _name     = 'goal',
            transform = { x = %d, y = %d },
            circle    = { r = 10  },
            light     = { r = 50  },
            color     = { hex2tbl(color_palette.indigo['300']) },
        },]]         ):format(
                        tile.x * cell_size,
                        tile.y * cell_size)
                end
            end
        end
    end

    local text = lume.format([[local hex2tbl = require('lib.lume').color
local util = require('lib.util')
local color_palette = util.parseJson('data/material_color.json')

return {
    systems = {
        'debug_mode',
        'rectangle',
        'block',
        'ball',
        'circle',
        'blob',
        'player',
        'background',
        'goal',
        'light',
        'animation',
        'timer',
        'bubble',
    },
    entities = {
        {
            _name      = 'background',
            color      = { hex2tbl(color_palette.pink['50']) },
            rectangle  = { w = 1280, h = 720 },
            background = 'background'
        },
        {1}
        {
            _name     = 'light',
            transform = { x = -75, y = -100 },
            circle    = { r = 1200 },
            color     = { hex2tbl('#FFFFFF') }
        },
        {
            _name     = 'timer',
            transform = { x = 1100, y = 30 },
            color     = { hex2tbl('#121212') }
        }
    }
}]]  , { result })
    return text
end


---@class LevelEditor : Scene
local LevelEditor = {}


function LevelEditor:enter(prev, ...)
    lg.setBackgroundColor(unpack(COLOR_BACKGROUND))

    local config = Comfort.load('config.json')
    if config == nil then
        Comfort.init('config.json', [[{
            "latest_file": "default.json"
        }]])
        Comfort.load('config.json')

        config = Comfort.getLatestResult()
    end

    local file_name = config.latest_file

    -- create new flie and load
    local result = Comfort.load(file_name)
    if result == nil then
        Comfort.init(file_name, json_content)
        Comfort.load(file_name)

        result = Comfort.getLatestResult()
    end

    states.opening_file_name = file_name

    tiles = Tiles:getInstance()

    tiles:setCellSize(result.cell_size)
    tiles:setBoardSize(result.width, result.height)
    tiles:setTileTypes(result.tile_types)
    tiles:setTileMap(result.tile_map)


    camera = Camera(STAGE_WIDTH / 2, STAGE_HEIGHT / 2)

    mouse = Mouse:getInstance(camera)

    border = Border:getInstance(camera)
    polar  = Polar:getInstance(camera)

    grids = Grids:getInstance(camera, border, polar)
    grids:setCellSize(result.cell_size)

    cursor = Cursor:getInstance(mouse)
    cursor:setCellSize(result.cell_size)

    mouse:addMouseAction(2, function(dt)
        if LoveFrames.hoverobject then
            return
        end

        local cx, cy   = love.mouse.getPosition()
        local ocx, ocy = mouse:getPrevPosition()

        local mul = 1 / camera.scale

        local dx, dy = (ocx - cx) * mul, (ocy - cy) * mul

        camera:move(dx, dy)
    end)

    mouse:addMouseAction(1, function(dt, f)
        if LoveFrames.hoverobject then
            return
        end

        local cx, cy = cursor:getHoverCellIndex()
        if not tiles:isInValidArea(cx, cy) then
            return
        end

        if f == 1 then
            if tiles:get(cx, cy).index == states.drawing_tile_index then
                states.drawing_tile_index = 0
            else
                states.drawing_tile_index = states.selected_tile_index
            end
        end

        if states.drawing_tile_index > 0 then
            tiles:set(cx, cy, states.drawing_tile_index, f)
        else
            tiles:deleteTile(cx, cy)
        end
    end)

    local width, _ = lw.getMode()

    -- LoveFrames
    hud.toolbar = LoveFrames.Create('panel')
    hud.toolbar:SetSize(width, TOOLBAR_HEIGHT)
    hud.toolbar:SetPos(0, 0)

    hud.mouse_position_info = LoveFrames.Create('text', hud.toolbar)
    hud.mouse_position_info:SetPos(hud.toolbar:GetWidth() - 140, 3)
    hud.mouse_position_info:SetText({
        { color = { 0, 0, 0, 1 } },
        mouse:getText()
    })

    local panel_height = 25

    local panel = LoveFrames.Create('panel')
    panel.Draw = function() end

    hud.tile_select_or_opener = LoveFrames.Create('button', panel)
    hud.tile_select_or_opener:SetWidth(80)
    hud.tile_select_or_opener:SetPos(15, panel_height)
    hud.tile_select_or_opener:SetText('TILES')
    hud.tile_select_or_opener.OnClick = function()
        if hud.tile_selector_frame == nil then
            hud.tile_selector_frame = LoveFrames.Create('frame')
            hud.tile_selector_frame:SetName('Tiles')
            hud.tile_selector_frame:SetHeight(180)
            hud.tile_selector_frame:SetPos(100, 30)
            hud.tile_selector_frame.OnClose = function()
                hud.tile_selector_frame = nil
            end
        end

        local grid = LoveFrames.Create('grid', hud.tile_selector_frame)
        grid:SetPos(5, 30)
        grid:SetRows(1)
        grid:SetColumns(5)
        grid:SetCellWidth(54)
        grid:SetCellHeight(45)
        grid:SetCellPadding(2)

        grid:SetItemAutoSize(true)

        grid:ColSpanAt(1, 1, 5)
        grid:RowSpanAt(1, 1, 3)

        local list = LoveFrames.Create('list')
        grid:AddItem(list, 1, 1)

        local types = tiles:getTileTypes()
        for index, tileType in ipairs(types) do
            local button = LoveFrames.Create('button')
            button:SetText(tileType.type)
            button.OnClick = function(object, x, y)
                states.selected_tile_index = index
            end

            list:AddItem(button)
        end
    end

    panel_height = panel_height + 25

    hud.file_save = LoveFrames.Create('button', panel)
    hud.file_save:SetWidth(80)
    hud.file_save:SetPos(15, panel_height)
    hud.file_save:SetText('SAVE')
    ---@diagnostic disable-next-line: duplicate-set-field
    hud.file_save.OnClick = function()
        if hud.save_dialog_frame == nil then
            hud.save_dialog_frame = LoveFrames.Create('frame')
            hud.save_dialog_frame:SetName('Save')
            hud.save_dialog_frame:SetSize(350, 100)
            hud.save_dialog_frame:SetPos(100, 60)
            hud.save_dialog_frame.OnClose = function()
                hud.save_dialog_frame = nil
            end
        end

        local text = LoveFrames.Create('text', hud.save_dialog_frame)
        text:SetPos(5, 35)
        text:SetText('File Name')

        local textinput = LoveFrames.Create('textinput', hud.save_dialog_frame)
        textinput:SetPos(100, 30)
        textinput:SetWidth(200)

        local text2 = LoveFrames.Create('text', hud.save_dialog_frame)
        text2:SetPos(310, 35)
        text2:SetText('.')

        local donebutton = LoveFrames.Create('button', hud.save_dialog_frame)
        donebutton:SetPos(hud.save_dialog_frame:GetWidth() - 110, 65)
        donebutton:SetWidth(100)
        donebutton:SetText('Save')
        donebutton.OnClick = function()
            local content = Comfort.load(states.opening_file_name)
            content.tile_map = tiles:getTileMap()
            content.width, content.height = tiles:getBoardSize()

            local result = Comfort.forceSave(
                textinput:GetValue() .. '.json', content)

            local resultLua = Comfort.forceSaveAsLua(
                textinput:GetValue() .. '.lua',
                convertToLevelData(content))

            local report = nil
            if not result or not resultLua then
                report = 'Error'
            else
                report = 'Success'
            end

            local restultframe = LoveFrames.Create('frame')
            restultframe:SetSize(300, 100)
            restultframe:Center()
            restultframe:SetName(report)

            local text = LoveFrames.Create('text', restultframe)
            text:SetPos(5, 30)
            text:SetText(report)
            text:SetMaxWidth(290)

            local config = Comfort.load('config.json')
            if config == nil then
                Comfort.init('config.json', [[{
                    "latest_file": "]] .. textinput:GetValue() .. [[.json"
                }]])
                config = Comfort.load('config.json')
            else
                config.latest_file = textinput:GetValue() .. '.json'
                Comfort.forceSave('config.json', config)
            end
        end
    end

    panel_height = panel_height + 25

    hud.file_open = LoveFrames.Create('button', panel)
    hud.file_open:SetWidth(80)
    hud.file_open:SetPos(15, panel_height)
    hud.file_open:SetText('OPEN')
    ---@diagnostic disable-next-line: duplicate-set-field
    hud.file_open.OnClick = function()
        if hud.open_dialog_frame == nil then
            hud.open_dialog_frame = LoveFrames.Create('frame')
            hud.open_dialog_frame:SetName('Open')
            hud.open_dialog_frame:SetSize(350, 100)
            hud.open_dialog_frame:SetPos(100, 60)
            hud.open_dialog_frame.OnClose = function()
                hud.open_dialog_frame = nil
            end
        end

        local text = LoveFrames.Create('text', hud.open_dialog_frame)
        text:SetPos(5, 35)
        text:SetText('File Name')

        local textinput = LoveFrames.Create('textinput', hud.open_dialog_frame)
        textinput:SetPos(100, 30)
        textinput:SetWidth(200)

        local text2 = LoveFrames.Create('text', hud.open_dialog_frame)
        text2:SetPos(310, 35)
        text2:SetText('.json')

        local donebutton = LoveFrames.Create('button', hud.open_dialog_frame)
        donebutton:SetPos(hud.open_dialog_frame:GetWidth() - 110, 65)
        donebutton:SetWidth(100)
        donebutton:SetText('open')
        donebutton.OnClick = function()
            local result = Comfort.load(textinput:GetValue() .. '.json')

            if result == nil then
                local restultframe = LoveFrames.Create('frame')
                restultframe:SetSize(300, 100)
                restultframe:Center()
                restultframe:SetName('Error')

                local text = LoveFrames.Create('text', restultframe)
                text:SetPos(5, 30)
                text:SetText('No File')
                text:SetMaxWidth(290)

                return
            end

            states.opening_file_name = textinput:GetValue() .. '.json'

            tiles:setCellSize(result.cell_size)
            tiles:setBoardSize(result.width, result.height)
            tiles:setTileTypes(result.tile_types)
            tiles:setTileMap(result.tile_map)

            local config = Comfort.load('config.json')
            if config == nil then
                Comfort.init('config.json', [[{
                    "latest_file": "]] .. textinput:GetValue() .. [[.json"
                }]])
                config = Comfort.load('config.json')
            else
                config.latest_file = textinput:GetValue() .. '.json'
                Comfort.forceSave('config.json', config)
            end
        end
    end

    panel_height = panel_height + 25

    hud.change_size = LoveFrames.Create('button', panel)
    hud.change_size:SetWidth(80)
    hud.change_size:SetPos(15, panel_height)
    hud.change_size:SetText('SIZE')
    hud.change_size.OnClick = function()
        if hud.change_size_dialog == nil then
            hud.change_size_dialog = LoveFrames.Create('frame')
            hud.change_size_dialog:SetName('Open')
            hud.change_size_dialog:SetSize(350, 125)
            hud.change_size_dialog:SetPos(100, 60)
            hud.change_size_dialog.OnClose = function()
                hud.change_size_dialog = nil
            end
        end

        local text1 = LoveFrames.Create('text', hud.change_size_dialog)
        text1:SetPos(5, 35)
        text1:SetText('Width')

        local textinput1 = LoveFrames.Create('textinput', hud.change_size_dialog)
        textinput1:SetPos(100, 30)
        textinput1:SetWidth(200)

        local text2 = LoveFrames.Create('text', hud.change_size_dialog)
        text2:SetPos(5, 65)
        text2:SetText('Height')

        local textinput2 = LoveFrames.Create('textinput', hud.change_size_dialog)
        textinput2:SetPos(100, 60)
        textinput2:SetWidth(200)

        local donebutton = LoveFrames.Create('button', hud.change_size_dialog)
        donebutton:SetPos(hud.change_size_dialog:GetWidth() - 110, 95)
        donebutton:SetWidth(100)
        donebutton:SetText('change')
        donebutton.OnClick = function()
            local w = tonumber(textinput1:GetValue())
            local h = tonumber(textinput2:GetValue())
            local ow, oh = tiles:getBoardSize()

            local tile_map = tiles:getTileMap()
            local newTileMap = {}

            for y = 0, h - 1 do
                for x = 0, w - 1 do
                    local i = (x < ow and y < oh) and tile_map[x + y * ow + 1] or 0
                    newTileMap[x + y * w + 1] = i
                end
            end

            tiles:setTileMap(newTileMap)
            tiles:setBoardSize(w, h)
        end
    end

    LoveFrames.SetActiveSkin('Default magenta')
end


function LevelEditor:update(dt)
    cursor:update()
    mouse:update(dt)
    border:update()
    polar:update()

    -- GUIs
    hud.mouse_position_info:SetText({
        { color = { 0, 0, 0, 1 } },
        mouse:getText()
    })

    LoveFrames.update(dt)
end


function LevelEditor:draw()
    camera:draw(function()
        tiles:draw()
        grids:draw()
        cursor:draw()
    end)

    polar:draw()

    -- HUD
    LoveFrames.draw()
end


function LevelEditor:leave(next, ...)
    Mouse:delete()
    Border:delete()
    Polar:delete()
    Tiles:delete()
    Grids:delete()
    Cursor:delete()
end


function LevelEditor:mousepressed(x, y, button)
    LoveFrames.mousepressed(x, y, button)
end


function LevelEditor:mousereleased(x, y, button)
    LoveFrames.mousereleased(x, y, button)
end


function LevelEditor:wheelmoved(x, y)
    LoveFrames.wheelmoved(x, y)

    states.camera_scale = states.camera_scale + y / 26

    if states.camera_scale > 6 then
        states.camera_scale = 6
    elseif states.camera_scale < 0.4 then
        states.camera_scale = 0.4
    end

    camera:zoomTo(states.camera_scale)
end


function LevelEditor:keypressed(key, isrepeat)
    LoveFrames.keypressed(key, isrepeat)
end


function LevelEditor:keyreleased(key)
    LoveFrames.keyreleased(key)
end


function LevelEditor:textinput(text)
    LoveFrames.textinput(text)
end


return LevelEditor
