---@class ECS.GoalComponent
---@field goaled boolean
---@field orbital_radius number
---@field satellite_radius number

---@return ECS.GoalComponent
return function()
    return {
        goaled           = false,
        orbital_radius   = 50,
        satellite_radius = 5,
    }
end
