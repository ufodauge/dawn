--------------------------------------------------------------
-- const
--------------------------------------------------------------
local MAX_MESSAGE_LOG = 40
local GAIN_OPACUE_LINES = 15


--------------------------------------------------------------
-- Shorthands
--------------------------------------------------------------
local lg = love.graphics


--------------------------------------------------------------
-- MessageArea
--------------------------------------------------------------

---@class MessageArea
---@field message_log { content: string|function, time: string }
---@field x integer
---@field y integer
---@field w integer
---@field h integer
local MessageArea = {}


---enqueue message and dequeue old info
---@param message string|function
function MessageArea:printMessage(message)
    table.insert(self.message_log, 1,
        {
            content = message,
            time = os.date('%X', os.time())
        })
    if #self.message_log > MAX_MESSAGE_LOG then
        self.message_log = { unpack(self.message_log, 1, MAX_MESSAGE_LOG) }
    end
end


function MessageArea:clear()
    self.message_log = {}
end


function MessageArea:draw()
    local font        = lg.getFont()
    local font_height = font:getHeight()
    local r, g, b, a  = lg.getColor()

    local drawed_height = 0

    lg.push()
    lg.translate(self.x, self.y)
    for i = 1, #self.message_log do
        local mes = self.message_log[i].content
        local time = self.message_log[i].time

        if type(mes) == 'function' then
            local ok, res = xpcall(
                function()
                    return tostring(mes())
                end,
                function(_mes)
                    return _mes
                end)
            mes = res
        end

        local messages = {}
        for s in string.gmatch(('%s: %s'):format(time, mes) .. '\n', '[^\r\n]+') do
            s = s:gsub('\\', '/')
            table.insert(messages, s)
        end

        for j = #messages, 1, -1 do
            drawed_height = drawed_height + font_height

            -- Transparent over-height messages
            --------------------------------------------------------------
            a = self.h - drawed_height < 0
                and 0
                or a

            a = drawed_height > GAIN_OPACUE_LINES * font_height
                and a * 0.75
                or a

            lg.setColor(r, g, b, a)
            lg.print(messages[j], 0, self.h - drawed_height)
        end
    end
    lg.setColor(r, g, b, 1)
    lg.pop()
end


---comment
---@return MessageArea
function MessageArea.new()
    local obj = {}

    obj.message_log = {}

    obj.x = 600
    obj.y = 300
    obj.w = 200
    obj.h = 300

    return setmetatable(obj, { __index = MessageArea })
end


return MessageArea
