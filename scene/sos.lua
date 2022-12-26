---@class SecondOrderDynamicsTestScene : Scene
local SecondOrderDynamicsTestScene = {}

local SecondOrderDynamics = require('lib.sos').SecondOrderDynamics
local Vector              = require('lib.sos').Vector

local graphics = love.graphics
local mouse = love.mouse

--[[------------------------------------------
    mouse
--]] ------------------------------------------

--#region mouse
local MM = {
    frame = 0
}
function MM:update()
    if mouse.isDown(1) then
        self.frame = self.frame + 1
    else
        self.frame = 0
    end
end


--#endregion mouse

--[[------------------------------------------
    base
--]] ------------------------------------------

--#region base
local Base = {}

function Base.new(x, y, w, h)
    local self = {}

    self.x = x
    self.y = y
    self.w = w
    self.h = h

    return setmetatable(self, {
        __index = Base
    })
end


function Base:draw()
    graphics.push()
    graphics.translate(self.x, self.y)

    graphics.setBackgroundColor(0, 0, 0, 1)
    graphics.setColor(1, 1, 1, 1)

    -- base polar
    graphics.line(0, self.h, self.w, self.h)
    graphics.line(0, self.h, 0, 0)

    -- vector
    graphics.line(self.w - 10, self.h - 10, self.w, self.h, self.w - 10, self.h + 10)
    graphics.line(0 - 10, 0 + 10, 0, 0, 0 + 10, 0 + 10)

    graphics.print('time', self.w - 16, self.h + 16)
    graphics.print('value', 16, 0)

    graphics.print('0', -4, self.h + 16)
    graphics.print('0', -26, self.h - 8)

    graphics.pop()
end


--#endregion base

--[[------------------------------------------
    parameters scroller
--]] ------------------------------------------

--#region parameters scroller

local Scroller = {
    baseColor = { 0.26, 0.26, 0.26, 1 },
    gaugeColor = { 0.4, 0.4, 0.78, 1 },
    pointerColor = { 0.89, 0.89, 0.89, 1 },
    height = 5,
    width = 260,
    radius = 5 * 1.2
}
function Scroller.new(init, max, min, x, y, label, intScale)
    assert(max > min)

    local self = {}

    self.value = init
    self.max   = max
    self.min   = min or 0

    self.x, self.y = x, y
    self.label = label or 'label'

    if intScale then
        self.value = math.floor(self.value + 0.5)
    end

    self.prevValue = self.value

    self.intScale = intScale or false
    self.percent = (init - min) / (max - min)
    self.grabbed = false

    return setmetatable(self, {
        __index = Scroller
    })
end


function Scroller:update()
    -- detect scrolling
    local mx, my = mouse.getPosition()
    local cx, cy = self.x + self.percent * self.width, self.y + self.height / 2

    if MM.frame == 1 then
        if (mx - cx) ^ 2 + (my - cy) ^ 2 <= self.radius ^ 2 then
            self.grabbed = true
        end
    elseif MM.frame == 0 then
        self.grabbed = false
    end

    if self.grabbed then
        -- self.x + self.percent * self.width = mx
        self.percent = (mx - self.x) / self.width
        self.percent = math.min(self.percent, 1)
        self.percent = math.max(self.percent, 0)

        -- self.percent = (self.value - self.min) / (self.max - self.min)
        self.value = self.percent * (self.max - self.min) + self.min
        if self.intScale then
            self.value = math.floor(self.value + 0.5)
        end
    end

    if self.prevValue ~= self.value then
        self.callback_on_change()
        self.prevValue = self.value
    end
end


function Scroller:draw()
    graphics.push()
    graphics.translate(self.x, self.y)

    graphics.setColor(self.baseColor)
    graphics.rectangle('fill', 0, 0, self.width, self.height, self.height / 4)

    graphics.setColor(self.gaugeColor)
    graphics.rectangle('fill', 0, 0, self.percent * self.width, self.height, self.height / 4)

    graphics.setColor(self.pointerColor)
    graphics.circle('fill', self.percent * self.width, self.height / 2, self.radius)
    graphics.circle('line', self.percent * self.width, self.height / 2, self.radius)

    if self.intScale then
        graphics.printf(('%d'):format(self.value), self.width + 10, -5, 100, 'left')
    else
        graphics.printf(('%.3f'):format(self.value), self.width + 10, -5, 100, 'left')
    end

    graphics.printf(self.label, -100, -5, 90, 'right')

    graphics.pop()
end


function Scroller:onChanged(func)
    self.callback_on_change = func
end


--#endregion parameters scroller

--[[------------------------------------------
    parameters scroller
--]] ------------------------------------------

--#region calc
local Calculator = {}

function Calculator.new(x, y, w, h, time_max, value_max, granularity)
    local self = {}

    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.time_max = time_max
    self.value_max = value_max
    self.granularity = granularity

    self.span_x = w * granularity / time_max
    self.scale_y = h / value_max

    self.input = {}
    self.output = {}

    return setmetatable(self, {
        __index = Calculator
    })
end


function Calculator:update(f, z, r, input_func)
    local current_time = 0.0

    self.input = {}
    self.output = {}

    self.input[#self.input + 1] = 0
    self.input[#self.input + 1] = input_func(current_time).x * self.scale_y

    self.output[#self.output + 1] = 0
    self.output[#self.output + 1] = self.input[#self.input]

    local sod = SecondOrderDynamics(f, z, r, input_func(current_time))

    while current_time <= self.time_max do
        current_time = current_time + self.granularity

        self.input[#self.input + 1] = self.input[#self.input - 1] + self.span_x
        self.input[#self.input + 1] = input_func(current_time).x * self.scale_y

        self.output[#self.output + 1] = self.input[#self.input - 1] + self.span_x
        self.output[#self.output + 1] = sod:update(0.05, input_func(current_time)).x * self.scale_y
    end
end


function Calculator:draw()
    graphics.push()

    graphics.translate(self.x, self.y + self.h)
    graphics.scale(1, -1)

    graphics.setColor(0.4, 1, 0.4, 1)
    graphics.line(self.input)

    graphics.setColor(0.4, 0.4, 1, 1)
    graphics.line(self.output)

    graphics.pop()
end


--#endregion calc

--[[------------------------------------------
  main
--]] ------------------------------------------

local win_w, win_h = love.window.getMode()

local base = Base.new(40, 100, win_w - 400, win_h - 200)

local scroller_f = Scroller.new(1, 5, -5, win_w - 340, 100, 'f')
local scroller_z = Scroller.new(0.5, 5, -5, win_w - 340, 140, 'z')
local scroller_r = Scroller.new(2, 5, -5, win_w - 340, 180, 'r')

local time_max = 5.0
local value_max = 10.0
local granularity = 1 / 60

local calc = Calculator.new(
    base.x, base.y, base.w, base.h,
    time_max, value_max, granularity)

---comment
---@param t number
---@return Vector
local function calc_position(t)
    if t > 2.5 then
        return Vector(7, 0)
    end
    return Vector(2, 0)
end


function SecondOrderDynamicsTestScene:enter(prev, ...)
    calc:update(scroller_f.value, scroller_z.value, scroller_r.value, calc_position)
end


function SecondOrderDynamicsTestScene:update(dt)
    MM:update()

    scroller_f:update()
    scroller_z:update()
    scroller_r:update()

    scroller_f:onChanged(function()
        calc:update(scroller_f.value, scroller_z.value, scroller_r.value, calc_position)
    end)
    scroller_z:onChanged(function()
        calc:update(scroller_f.value, scroller_z.value, scroller_r.value, calc_position)
    end)
    scroller_r:onChanged(function()
        calc:update(scroller_f.value, scroller_z.value, scroller_r.value, calc_position)
    end)
end


function SecondOrderDynamicsTestScene:draw()
    base:draw()

    calc:draw()

    scroller_f:draw()
    scroller_z:draw()
    scroller_r:draw()
end


function SecondOrderDynamicsTestScene:leave(next, ...)

end


return SecondOrderDynamicsTestScene
