--
-- flux
--
-- Copyright (c) 2016 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local flux = { _version = '0.1.5' }
flux.__index = flux

flux.tweens = {}

---@enum EaseType
local EaseType = {
    linear       = 'linear',
    quadin       = 'quadin',
    quadout      = 'quadout',
    quadinout    = 'quadinout',
    cubicin      = 'cubicin',
    cubicout     = 'cubicout',
    cubicinout   = 'cubicinout',
    quartin      = 'quartin',
    quartout     = 'quartout',
    quartinout   = 'quartinout',
    quintin      = 'quintin',
    quintout     = 'quintout',
    quintinout   = 'quintinout',
    expoin       = 'expoin',
    expoout      = 'expoout',
    expoinout    = 'expoinout',
    sinein       = 'sinein',
    sineout      = 'sineout',
    sineinout    = 'sineinout',
    circin       = 'circin',
    circout      = 'circout',
    circinout    = 'circinout',
    backin       = 'backin',
    backout      = 'backout',
    backinout    = 'backinout',
    elasticin    = 'elasticin',
    elasticout   = 'elasticout',
    elasticinout = 'elasticinout',
}


--#region create easing functions
--------------------------------------------------------------
-- create easing functions
--------------------------------------------------------------
flux.easing = { linear = function(p) return p end }

local easing = {
    quad = 'p * p',
    cubic = 'p * p * p',
    quart = 'p * p * p * p',
    quint = 'p * p * p * p * p',
    expo = '2 ^ (10 * (p - 1))',
    sine = '-math.cos(p * (math.pi * .5)) + 1',
    circ = '-(math.sqrt(1 - (p * p)) - 1)',
    back = 'p * p * (2.7 * p - 1.7)',
    elastic = '-(2^(10 * (p - 1)) * math.sin((p - 1.075) * (math.pi * 2) / .3))'
}

local makefunc = function(str, expr)
    local load = loadstring or load
    return load('return function(p) ' .. str:gsub('%$e', expr) .. ' end')()
end

for k, v in pairs(easing) do
    flux.easing[k .. 'in'] = makefunc('return $e', v)
    flux.easing[k .. 'out'] = makefunc([[
    p = 1 - p
    return 1 - ($e)
  ]] , v)
    flux.easing[k .. 'inout'] = makefunc(
        [[
    p = p * 2
    if p < 1 then
      return .5 * ($e)
    else
      p = 2 - p
      return .5 * (1 - ($e)) + .5
    end
  ]]     , v)
end
--#endregion create easing functions


---@class Tween
---@field obj      table
---@field rate     number
---@field progress number
---@field parent   Tween
---@field inited   boolean
---@field _delay   number
---@field _ease    EaseType
---@field vars     table<string, number|table<string, number>>
---@field ease       fun(self: Tween, type: string):   Tween
---@field delay      fun(self: Tween, time: number):   Tween
---@field onstart    fun(self: Tween, fn:   function): Tween
---@field onupdate   fun(self: Tween, fn:   function): Tween
---@field oncomplete fun(self: Tween, fn:   function): Tween
local tween = {}
tween.__index = tween

local function makefsetter(field)
    return function(self, x)
        local mt = getmetatable(x)
        if type(x) ~= 'function' and not (mt and mt.__call) then
            error('expected function or callable', 2)
        end
        local old = self[field]
        self[field] = old and function()
            old()
            x()
        end or x
        return self
    end
end


local function makesetter(field, checkfn, errmsg)
    return function(self, x)
        if checkfn and not checkfn(x) then
            error(errmsg:gsub('%$x', tostring(x)), 2)
        end
        self[field] = x
        return self
    end
end


tween.ease = makesetter('_ease', function(x) return flux.easing[x] end,
    "bad easing type '$x'")
tween.delay = makesetter('_delay', function(x) return type(x) == 'number' end,
    'bad delay time; expected number')
tween.onstart = makefsetter('_onstart')
tween.onupdate = makefsetter('_onupdate')
tween.oncomplete = makefsetter('_oncomplete')

---@param obj any
---@param time number
---@param vars table<string, number>
---@return table
function tween.new(obj, time, vars)
    local self = setmetatable({}, tween)

    self.obj      = obj
    self.rate     = time > 0 and 1 / time or 0
    self.progress = time > 0 and 0 or 1
    self._delay   = 0
    self._ease    = 'quadout'

    self.vars = {}
    for k, v in pairs(vars) do
        assert(
            type(v) == 'number',
            "bad value for key '" .. k .. "'; expected number")
        self.vars[k] = v
    end
    return self
end


function tween:init()
    for k, v in pairs(self.vars) do
        local x = self.obj[k]
        assert(
            type(v) == 'number',
            "bad value for key '" .. k .. "'; expected number")
        self.vars[k] = {
            start = x,
            diff = v - x
        }
    end
    self.inited = true
end


---@param ... unknown same as flux:to.
---@return Tween
function tween:after(...)
    local t
    if select('#', ...) == 2 then
        t = tween.new(self.obj, ...)
    else
        t = tween.new(...)
    end
    t.parent = self.parent
    self:oncomplete(function()
        flux.add(self.parent, t)
    end)
    return t
end


function tween:stop() flux.remove(self.parent, self) end


---@return table
function flux.group() return setmetatable({}, flux) end


---@param obj any
---@param time number animation duration
---@param vars table<string, number>
---@return unknown
function flux:to(obj, time, vars)
    return flux.add(self, tween.new(obj, time, vars))
end


---@param deltatime number
function flux:update(deltatime)
    for i = #self, 1, -1 do
        local t = self[i]

        if t._delay > 0 then
            -- update delay time
            --------------------------------------------------------------
            t._delay = t._delay - deltatime
        else
            if not t.inited then
                flux.clear(self, t.obj, t.vars)
                t:init()
            end
            if t._onstart then
                t._onstart()
                t._onstart = nil
            end
            t.progress = t.progress + t.rate * deltatime
            local p = t.progress
            local x = p >= 1 and 1 or flux.easing[t._ease](p)
            for k, v in pairs(t.vars) do
                t.obj[k] = v.start + x * v.diff
            end
            if t._onupdate then t._onupdate() end
            if p >= 1 then
                flux.remove(self, i)
                if t._oncomplete then t._oncomplete() end
            end
        end
    end
end


---@param obj any
---@param vars any
function flux:clear(obj, vars)
    for t in pairs(self[obj]) do
        if t.inited then for k in pairs(vars) do t.vars[k] = nil end end
    end
end


---@param tween any
---@return any
function flux:add(tween)
    -- Add to object table, create table if it does not exist
    local obj = tween.obj
    self[obj] = self[obj] or {}
    self[obj][tween] = true
    -- Add to array
    table.insert(self, tween)
    tween.parent = self
    return tween
end


---@param x any
---@return any
function flux:remove(x)
    if type(x) == 'number' then
        -- Remove from object table, destroy table if it is empty
        local obj = self[x].obj
        self[obj][self[x]] = nil
        if not next(self[obj]) then self[obj] = nil end
        -- Remove from array
        self[x] = self[#self]
        return table.remove(self)
    end
    for i, v in ipairs(self) do
        if v == x then return flux.remove(self, i) end
    end
end


local bound = {
    ---@param obj any
    ---@param time number duration
    ---@param vars table<string, number>
    ---@return unknown
    to = function(obj, time, vars) return flux.to(flux.tweens, obj, time, vars) end,

    ---comment
    ---@param dt number
    ---@return nil
    update = function(dt) return flux.update(flux.tweens, dt) end,

    ---comment
    ---@param ... unknown
    ---@return unknown
    remove = function(...) return flux.remove(flux.tweens, ...) end
}
setmetatable(bound, flux)

return bound
