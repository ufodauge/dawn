local transform     = require('nocs.components.transform')
local debug_mode    = require('nocs.components.debug_mode')
local color         = require('nocs.components.color')
local circle        = require('nocs.components.circle')
local blob          = require('nocs.components.blob')
local player        = require('nocs.components.player')
local player_ui     = require('nocs.components.player_ui')
local shadow_circle = require('nocs.components.shadow_circle')


---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform     = transform(args.transform),
        color         = color(args.color),
        circle        = circle(args.circle),
        blob          = blob(args.blob),
        debug_mode    = debug_mode(args.debug_mode),
        shadow_circle = shadow_circle(args.shadow_circle),
        player        = player(args.player),
        player_ui     = player_ui(args.player_ui),
    }
end
