--------------------------------------------------------------
-- shorthands
--------------------------------------------------------------
local lf      = love.filesystem
local lg      = love.graphics
local fonts   = love.assets.font
local hex2tbl = love.lume.color
local floor   = math.floor


--------------------------------------------------------------
-- requires
--------------------------------------------------------------
local Controller = require('class.controller'):getInstance()
local Text       = require('class.ui.text')
local Canvas     = require('class.canvas')
local Loader     = require('class.loader')
local Signal     = require('lib.signal')
local Roomy      = require('lib.roomy'):getInstance()
local coil       = require('lib.coil')
local Bitser     = require('lib.bitser')
local util       = require('lib.util')


-- const
--------------------------------------------------------------
local FILENAME_SAVEDATA = require('data.save_filename')
local EVENT_NAME        = require('const.event_name')
local TIME_FORMAT       = require('const.others').TIME_FORMAT
local RECORDS_MAX       = require('const.others').RECORDS_MAX
local RANK_PREFIXS      = { '1st', '2nd', '3rd', '4th', '5th' }



---@param level integer
---@return {[1]: number, [2]: number, [3]: number, [4]: number, [5]: number}[]
local function load_times(level)
    local deserialized = nil
    if lf.getInfo(FILENAME_SAVEDATA) then
        deserialized = Bitser.loadLoveFile(FILENAME_SAVEDATA)
    end

    local function create_level_data()
        return {
            util.clampTime(math.huge),
            util.clampTime(math.huge),
            util.clampTime(math.huge),
            util.clampTime(math.huge),
            util.clampTime(math.huge)
        }
    end


    -- if the data is wholly broken
    --------------------------------------------------------------
    if type(deserialized) ~= 'table' then
        -- reset all data
        deserialized = {
            [level] = create_level_data()
        }
    end

    if type(deserialized[level]) ~= 'table'
        or #deserialized[level] ~= RECORDS_MAX then
        deserialized[level] = create_level_data()
    end

    for i = 1, RECORDS_MAX do
        deserialized[level][i] = type(deserialized[level][i]) == 'number'
            and util.clampTime(deserialized[level][i])
            or util.clampTime(math.huge)
    end

    return deserialized
end


-- local
--------------------------------------------------------------
---@type GameScene
local game_scene = nil


---@class ResultScene : Scene
local ResultScene = {}

local font_large  = fonts.timeburnerbold(128)
local font_normal = fonts.timeburnerbold(30)


local texts = nil


local convert_time_to_mmssms = function(time)
    return floor(time / 60),
        floor(time % 60),
        floor((time % 1) * 100)
end


function ResultScene:enter(GameScene, time)
    texts = {
        Text.new(
            TIME_FORMAT,
            350, 530,
            font_large,
            { 0, 0, 0, 0 }),
        Text.new(
            RANK_PREFIXS[1] .. ': ' .. TIME_FORMAT,
            350, 180,
            font_normal,
            { 0, 0, 0, 0 }),
        Text.new(
            RANK_PREFIXS[2] .. ': ' .. TIME_FORMAT,
            350, 240,
            font_normal,
            { 0, 0, 0, 0 }),
        Text.new(
            RANK_PREFIXS[3] .. ': ' .. TIME_FORMAT,
            350, 300,
            font_normal,
            { 0, 0, 0, 0 }),
        Text.new(
            RANK_PREFIXS[4] .. ': ' .. TIME_FORMAT,
            350, 360,
            font_normal,
            { 0, 0, 0, 0 }),
        Text.new(
            RANK_PREFIXS[5] .. ': ' .. TIME_FORMAT,
            350, 420,
            font_normal,
            { 0, 0, 0, 0 }),
        Text.new(
            '%s : stage select',
            850, 680,
            font_normal,
            { 0, 0, 0, 0 }),
    }

    game_scene = GameScene

    -- load & save time
    --------------------------------------------------------------
    local records = load_times(game_scene.current_level)
    local level_records = records[game_scene.current_level]

    level_records[RECORDS_MAX + 1] = time
    level_records = love.lume.sort(level_records)
    level_records[RECORDS_MAX + 1] = nil

    Bitser.dumpLoveFile(FILENAME_SAVEDATA, records)

    texts[1]:setEmbedGetter(function()
        return convert_time_to_mmssms(time)
    end)

    texts[7]:setEmbedGetter(function()
        return Controller
            :getControlConfig(
                Controller:getLatestControllerType(),
                'action')
    end)

    for i, record in ipairs(level_records) do
        texts[i + 1]:setEmbedGetter(function()
            return convert_time_to_mmssms(record)
        end)
    end

    coil.add(function()
        coil.wait(1)
        for i, text in ipairs(texts) do
            text:setColor({ hex2tbl('#121212FF') }, 0.6 + i * 0.2)
        end

        texts[1]:move(400, 0, 0.6):rotate(-math.pi / 16)
        texts[2]:move(250, 0, 0.8)
        texts[3]:move(270, 0, 1.0)
        texts[4]:move(290, 0, 1.2)
        texts[5]:move(310, 0, 1.4)
        texts[6]:move(330, 0, 1.6)
    end)
end


function ResultScene:update(dt)
    game_scene:update(dt / 4)
end


function ResultScene:draw()
    game_scene:draw()
    lg.setBackgroundColor(1, 1, 1, 1)
    for _, text in ipairs(texts) do
        text:draw()
    end
end


function ResultScene:leave(next, ...)

end


return ResultScene
