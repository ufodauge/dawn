-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lm = love.math


-- requires
--------------------------------------------------------------
local flux = require('lib.flux')


---@class Text
---@field private _rawtext   string
---@field private _x         number
---@field private _y         number
---@field private _rot       number
---@field private _font      love.Font
---@field private _color     number[]
---@field private _text      love.Text
---@field private _getter    fun(): ...
local Text = {}


function Text:draw()
    lg.push()
    lg.setColor(self._color)
    lg.setFont(self._font)
    lg.translate(self._x, self._y)
    lg.rotate(self._rot)
    if self._getter then
        lg.print(
            self._rawtext:format(self._getter()))
    else
        lg.print(
            self._rawtext)
    end
    lg.pop()
end


---@param dx number
---@param dy number
---@param duration number
function Text:move(dx, dy, duration)
    if duration then
        local x, y = self._x, self._y
        flux.to(
            self,
            duration,
            {
                _x = dx and x + dx or x,
                _y = dy and y + dy or y
            })
    else
        self._x, self._y = self._x + dx, self._y + dy
    end

    return self
end


---@param color number[]
---@param duration number
function Text:setColor(color, duration)
    if duration then
        color = color or { 1, 1, 1, 1 }
        for i = 1, 4 do
            color[i] = color[i] or self._color[i]
        end
        flux.to(
            self._color,
            duration,
            color)
    else
        color = color or { 1, 1, 1, 1 }
        for i = 1, 4 do
            self._color[i] = color[i] or self._color[i]
        end
    end

    return self
end


---@param func fun(): ...
function Text:setEmbedGetter(func)
    self._getter = func
end


---@param rot number
function Text:rotate(rot, duration)
    if duration then
        local orig_rot = self._rot
        flux.to(
            self,
            duration,
            {
                _rot = orig_rot + rot
            })
    else
        self._rot = self._rot + rot
    end
end


---@param text?         string
---@param x?            number
---@param y?            number
---@param color?        number[]
---@param font?         love.Font
---@param embed_getter? fun(): ...
---@return Text
function Text.new(text, x, y, font, color, embed_getter)
    local self = {
        _rawtext = text or '',
        _font    = font or lg.getFont(),
        _color   = {},
        _getter  = embed_getter,
        _x       = x or 0,
        _y       = y or 0,
        _rot     = 0,
    }

    color = color or { 1, 1, 1, 1 }
    for i = 1, 4 do
        self._color[i] = color[i] or 1
    end

    return setmetatable(self, { __index = Text })
end


return Text
