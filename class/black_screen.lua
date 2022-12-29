-- shorthands
--------------------------------------------------------------
local lg = love.graphics


-- requires
--------------------------------------------------------------
local flux = require('lib.flux')


---@class BlackScreen
---@field private _covered boolean
---@field private _color  number[]
local BlackScreen = {}


function BlackScreen:draw()
    lg.push()
    lg.setColor(self._color)
    lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
    lg.pop()
end


function BlackScreen:toggle()
    flux.to(
        self._color, 1,
        {
            [4] = self._covered and 0 or 1
        })
    self._covered = not self._covered
end


---@return BlackScreen
function BlackScreen.new(bool)
    local self = {
        _covered = bool or false,
        _color = { 0, 0, 0, 0 }
    }

    if bool then
        self._color[4] = 1
    end

    return setmetatable(self, { __index = BlackScreen })
end


return BlackScreen
