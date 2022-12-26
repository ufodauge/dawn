---@class ECS.PlayerComponent
---@field pop_angle number
---@field pop_strength_rate number
---@field pop_strength number
---@field controllable boolean

---@param args any
---@return ECS.PlayerComponent
return function(args)
    return {
        pop_angle         = 0,
        pop_strength_rate = 0,
        pop_strength      = args.pop_strength or 170,
        time              = 0,
        controllable      = true
    }
end
