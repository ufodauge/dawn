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


return util
