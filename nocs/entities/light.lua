local transform = require('nocs.components.transform')
local color     = require('nocs.components.color')
local circle    = require('nocs.components.circle')
local animation = require('nocs.components.animation')
local light     = require('nocs.components.light')

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
