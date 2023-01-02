local transform        = require('nocs.components.transform')
local color            = require('nocs.components.color')
local physics          = require('nocs.components.physics')
local rectangle        = require('nocs.components.rectangle')
local debug_mode       = require('nocs.components.debug_mode')
local shadow_rectangle = require('nocs.components.shadow_rectangle')
local movable          = require('nocs.components.movable')

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
        movable          = movable(args.movable),
    }
end
