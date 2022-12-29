local transform = require('ecs.components.transform')
local color     = require('ecs.components.color')
local circle    = require('ecs.components.circle')
local animation = require('ecs.components.animation')
local light     = require('ecs.components.light')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform = transform(args.transform),
        color     = color(args.color),
        circle    = circle(args.circle),
        light     = light(args.light),
        animation = animation(args.animation),
    }
end
