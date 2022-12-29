local transform = require('ecs.components.transform')
local color     = require('ecs.components.color')
local text      = require('ecs.components.text')
local timer     = require('ecs.components.timer')


---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform = transform(args.transform),
        color     = color(args.color),
        text      = text(args.text),
        timer     = timer(args.timer)
    }
end
