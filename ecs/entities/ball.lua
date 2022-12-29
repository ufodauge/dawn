local transform     = require('ecs.components.transform')
local color         = require('ecs.components.color')
local physics       = require('ecs.components.physics')
local circle        = require('ecs.components.circle')
local debug_mode    = require('ecs.components.debug_mode')
local shadow_circle = require('ecs.components.shadow_circle')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform     = transform(args.transform),
        color         = color(args.color),
        circle        = circle(args.circle),
        physics       = physics(args.physics),
        debug_mode    = debug_mode(args.debug_mode),
        shadow_circle = shadow_circle(args.shadow_circle),
    }
end
