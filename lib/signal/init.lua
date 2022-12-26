local LuiDebug = require('lib.luidebug'):getInstance()

---@class Signal
local Signal = {}

local channel = {}

---@param ch string
---@param ... any
function Signal.send(ch, ...)
    local slice = {}
    for _, func in pairs(channel[ch] or {}) do
        table.insert(slice, func)
    end
    for _, func in pairs(slice) do
        xpcall(func, function(msg)
            LuiDebug:log(debug.traceback(msg))
            print(debug.traceback(msg))
        end, ...)
    end
end


---@param ch string
---@param func function
function Signal.subscribe(ch, func)
    channel[ch] = channel[ch] or {}
    channel[ch][func] = func
end


---@param ch string
---@param func function
function Signal.unsubscribe(ch, func)
    channel[ch][func] = nil
end


---@param ch string
function Signal.clear(ch)
    channel[ch] = nil
end


return Signal
