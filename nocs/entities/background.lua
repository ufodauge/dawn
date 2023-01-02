local transform  = require('nocs.components.transform')
local color      = require('nocs.components.color')
local rectangle  = require('nocs.components.rectangle')
local background = require('nocs.components.background')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform  = transform(args.transform),
        color      = color(args.color),
        rectangle  = rectangle({
            w = args.rectangle and args.rectangle.w or 1280,
            h = args.rectangle and args.rectangle.h or 720
        }),
        background = background()
    }
end
