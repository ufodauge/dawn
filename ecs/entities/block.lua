local transform  = require('ecs.components.transform')
local color      = require('ecs.components.color')
local physics    = require('ecs.components.physics')
local rectangle  = require('ecs.components.rectangle')
local debug_mode = require('ecs.components.debug_mode')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    local entity = {
        transform  = transform(args.transform),
        color      = color(args.color),
        physics    = physics(args.physics),
        rectangle  = rectangle(args.rectangle),
        debug_mode = debug_mode(args.debug_mode),
    }

    return entity
end
