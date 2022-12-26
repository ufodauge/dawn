-- shorthands
--------------------------------------------------------------
-- local lf = love.filesystem


-- requires
--------------------------------------------------------------
-- local Bitser = require('lib.bitser')


-- constants
--------------------------------------------------------------
-- local RECORDS_COUNT                  = require('data.constants').RECORDS_COUNT
-- local SAVEDATA_FILENAME              = require('data.constants').SAVEDATA_FILENAME
-- local DEFAULT_LEVEL_LEADERBOARD_DATA = require('data.constants').DEFAULT_LEVEL_LEADERBOARD_DATA

local json = require('lib.json_reader')

local util = {}

---@param time number
---@return number # < 3599.99 (= 59:59.99)
function util.clampTime(time)
    return time < 3599.99 and time or 3599.99
end


---true when the object is nil or null
---@param object any
---@return boolean
function util.nullCheck(object)
    return not object or tostring(object) == object:type() .. ': NULL'
end


function util.parseJson(filepath)
    return json.decode(love.filesystem.read(filepath))
end


-- ---@param level integer
-- ---@return LeaderboardData
-- function util.load_times(level)
--     local deserialized = nil
--     if lf.getInfo(SAVEDATA_FILENAME) then
--         ---@type LeaderboardData
--         deserialized = Bitser.loadLoveFile(SAVEDATA_FILENAME)
--     end


--     -- if the data is wholly broken
--     --------------------------------------------------------------
--     if type(deserialized) ~= 'table' then
--         -- reset all data
--         deserialized = {
--             [level] = Lume.clone(DEFAULT_LEVEL_LEADERBOARD_DATA)
--         }
--     end

--     if type(deserialized[level]) ~= 'table'
--         or #deserialized[level] ~= RECORDS_COUNT then
--         deserialized[level] = Lume.clone(DEFAULT_LEVEL_LEADERBOARD_DATA)
--     end

--     for i = 1, RECORDS_COUNT do
--         deserialized[level][i] = type(deserialized[level][i]) == 'number'
--             and util.clamp_time(deserialized[level][i])
--             or util.clamp_time(math.huge)
--     end

--     return deserialized
-- end


return util
