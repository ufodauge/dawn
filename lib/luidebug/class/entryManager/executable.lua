local PATH = (...):gsub('[^/.\\]+$', '')
local Entry = require(PATH .. 'entry')

---@class Executable : Entry
---@field name string
---@field func function
local Executable = setmetatable({}, { __index = Entry })


---comment
---@return any
function Executable:execute()
    return self.func() or true
end


---comment
---@param name string
---@param func function
---@return Executable
function Executable.new(name, func)
    local obj = Entry.new(name) --[[@as Executable]]

    obj.func = func

    local mt   = getmetatable(obj)
    mt.__index = Executable
    return setmetatable(obj, mt)
end


return Executable
