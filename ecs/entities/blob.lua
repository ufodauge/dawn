local transform  = require('ecs.components.transform')
local debug_mode = require('ecs.components.debug_mode')
local color      = require('ecs.components.color')
local circle     = require('ecs.components.circle')
local blob       = require('ecs.components.blob')
local player     = require('ecs.components.player')


---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform  = transform(args.transform),
        color      = color(args.color),
        circle     = circle(args.circle),
        blob       = blob(args.blob),
        debug_mode = debug_mode(args.debug_mode),
        player     = player(args.player),
        player_ui  = player(args.player_ui),
    }
end
