local transform = require('ecs.components.transform')
local color     = require('ecs.components.color')
local rectangle = require('ecs.components.rectangle')
local background= require('ecs.components.background')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform = transform(args.transform),
        color     = color(args.color),
        rectangle = rectangle({
            w = args.rectangle and args.rectangle.w or 1280,
            h = args.rectangle and args.rectangle.h or 720
        }),
        background = background()
    }
end
