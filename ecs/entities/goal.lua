local transform     = require('ecs.components.transform')
local color         = require('ecs.components.color')
local physics       = require('ecs.components.physics')
local circle        = require('ecs.components.circle')
local goal          = require('ecs.components.goal')
local debug_mode    = require('ecs.components.debug_mode')
local animation     = require('ecs.components.animation')
local light         = require('ecs.components.light')


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
