local Gamera = require('lib.gamera.gamera')

---@type Gamera
local Camera = nil

local Export = {}

---@return Gamera
function Export:getInstance()
    if not Camera then
        local w, h = love.window.getMode()
        Camera = Gamera.new(0, 0, w, h)
    end

    return Camera
end


return Export
