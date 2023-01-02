local transform  = require('nocs.components.transform')
local color      = require('nocs.components.color')
local physics    = require('nocs.components.physics')
local circle     = require('nocs.components.circle')
local goal       = require('nocs.components.goal')
local debug_mode = require('nocs.components.debug_mode')
local animation  = require('nocs.components.animation')
local light      = require('nocs.components.light')


---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform  = transform(args.transform),
        color      = color(args.color),
        circle     = circle(args.circle),
        physics    = physics(args.physics),
        debug_mode = debug_mode(args.debug_mode),
        goal       = goal(),
        animation  = animation(args.animation),
        light      = light(args.light),
    }
end
