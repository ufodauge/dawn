---@class ECS.PlayerComponent
---@field pop_angle number
---@field pop_strength_rate number
---@field pop_strength number
---@field controllable boolean
---@field contact_frame integer

---@param args any
---@return ECS.PlayerComponent
return function(args)
    return {
        pop_angle         = 0,
        pop_strength_rate = 0,
        pop_strength      = (args and args.pop_strength)
            and args.pop_strength or 170,
        time              = 0,
        controllable      = true,
        contact_frame     = 0
    }
end
