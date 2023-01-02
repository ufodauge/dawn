local transform = require('nocs.components.transform')
local color     = require('nocs.components.color')
local text      = require('nocs.components.text')
local timer     = require('nocs.components.timer')


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
