---@class FreeCamera
---@field x number
---@field y number
local Camera = {}

Camera.x = 0
Camera.y = 0

function Camera:set()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end


function Camera:unset()
    love.graphics.pop()
end


function Camera:reset()
    self.x, self.y = 0, 0
end


function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy 
end


function Camera:update()
    if love.keyboard.isDown('left') then
        self:move(-3, 0)
    end
    if love.keyboard.isDown('up') then
        self:move(0, -3)
    end
    if love.keyboard.isDown('right') then
        self:move(3, 0)
    end
    if love.keyboard.isDown('down') then
        self:move(0, 3)
    end
end


return Camera
