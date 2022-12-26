local PATH = (...):gsub('[^/.\\]+$', '')
local Entry = require(PATH .. 'entry')

---@class Directory : Entry
---@field entries (Directory|Executable)[]
local Directory = setmetatable({}, { __index = Entry })



---@param index integer
---@return Directory|Executable
function Directory:getEntryByIndex(index)
    return self.entries[index]
end


---@param name string
---@return Directory|Executable|nil
function Directory:getEntry(name)
    for _, entry in ipairs(self.entries) do
        if entry.name == name then
            return entry
        end
    end

    return nil
end


---@param name string
---@return integer
function Directory:getEntryIndex(name)
    for i, entry in ipairs(self.entries) do
        if entry.name == name then
            return i
        end
    end

    return 1
end


---@return integer
function Directory:getItemCount()
    return #self.entries
end


---@param entry Executable|Directory
function Directory:add(entry)
    entry.parent = self
    table.insert(self.entries, entry)
end


function Directory:remove()
    for i = #self.entries, 1, -1 do
        self.entries[i]:remove()
        table.remove(self.entries, i)
    end
end


---alias of Directory:remove()
function Directory:clearContents()
    self:remove()
end


---@param name string
---@return boolean
function Directory:removeEntry(name)
    for i = #self.entries, 1, -1 do
        if self.entries[i].name == name then
            self.entries[i]:remove()
            table.remove(self.entries, i)
            return true
        end
    end

    return false
end


---factory for loop process
---@return (Directory|Executable)[]
function Directory:getEntries()
    return self.entries
end


---@param name string
---@return Directory
function Directory.new(name)
    local obj = Entry.new(name) --[[@as Directory]]

    obj.entries = {}

    local mt = getmetatable(obj)
    mt.__index = Directory
    return setmetatable(obj, mt)
end


return Directory
