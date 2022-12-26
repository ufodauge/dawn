---@class Vector
---@field x number
---@field y number
local Vector = {}

---constructor
---@param x number
---@param y number
---@return Vector
function Vector.new(x, y)
    ---@type Vector
    local obj = {}

    obj.x = x
    obj.y = y

    return setmetatable(obj, {
        __index = Vector,
        __type = "Vector"
    })
end

---return Vector's length
---@return number
function Vector:len()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

Vector = setmetatable(Vector, {
    __index = Vector,
    __call = function(_, x, y)
        return Vector.new(x, y)
    end
})

---@class SecondOrderDynamics
---@field xp Vector # previous input
---@field y Vector # state variables
---@field yd Vector
---@field k1 number # dynamics constants
---@field k2 number
---@field k3 number
local SecondOrderDynamics = {}

---constructor
---@param f number
---@param z number
---@param r number
---@param x0 Vector
function SecondOrderDynamics.new(f, z, r, x0)
    ---@type SecondOrderDynamics
    local obj = {}

    -- compute constants
    obj.k1 = z / (math.pi * f)
    obj.k2 = 1 / ((2 * math.pi * f) * (2 * math.pi * f))
    obj.k3 = r * z / (2 * math.pi * f)

    -- initialize variables
    obj.xp = x0
    obj.y  = x0
    obj.yd = Vector(0, 0)

    return setmetatable(obj, {
        __index = SecondOrderDynamics
    })
end

---update status
---@param dt number
---@param x Vector
---@param xd Vector
function SecondOrderDynamics:update(dt, x, xd)
    xd = xd or Vector(
        (x.x - self.xp.x) / dt,
        (x.y - self.xp.y) / dt)
    self.xp = x

    -- clamp k2 to guarantee stability without jitter
    local k2_stable = math.max(self.k2, dt * dt / 2 + dt * self.k1 / 2, dt * self.k1)
    self.y = Vector(
        self.y.x + self.yd.x * dt,
        self.y.y + self.yd.y * dt)
    self.yd = Vector(
        self.yd.x + dt * (x.x + self.k3 * xd.x - self.y.x - self.k1 * self.yd.x) / k2_stable,
        self.yd.y + dt * (x.y + self.k3 * xd.y - self.y.y - self.k1 * self.yd.y) / k2_stable)

    return self.y
end

SecondOrderDynamics = setmetatable(SecondOrderDynamics, {
    __call = function(t, f, z, r, x0)
        return SecondOrderDynamics.new(f, z, r, x0)
    end
})

return {
    SecondOrderDynamics = SecondOrderDynamics,
    Vector              = Vector
}
