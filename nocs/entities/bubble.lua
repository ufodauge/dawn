local animation = require('nocs.components.animation')
local transform = require('nocs.components.transform')
local bubble    = require('nocs.components.bubble')
local color     = require('nocs.components.color')
local circle    = require('nocs.components.circle')
local light     = require('nocs.components.light')


---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform = transform(args.transform),
        color     = color(args.color),
        animation = animation(args.animation),
        circle    = circle(args.circle),
        bubble    = bubble(args.bubble),
        light     = light(args.light),
    }
end
