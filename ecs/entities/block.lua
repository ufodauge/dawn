local transform        = require('ecs.components.transform')
local color            = require('ecs.components.color')
local physics          = require('ecs.components.physics')
local rectangle        = require('ecs.components.rectangle')
local debug_mode       = require('ecs.components.debug_mode')
local shadow_rectangle = require('ecs.components.shadow_rectangle')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform        = transform(args.transform),
        color            = color(args.color),
        physics          = physics(args.physics),
        rectangle        = rectangle(args.rectangle),
        debug_mode       = debug_mode(args.debug_mode),
        shadow_rectangle = shadow_rectangle(args.shadow_rectangle),
    }
end
