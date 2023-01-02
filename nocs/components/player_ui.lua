---@class ECS.PlayerUIComponent
---@field x number
---@field y number
---@field tracker SecondOrderDynamics

---@param args any
---@return ECS.PlayerUIComponent
return function(args)
    return {
        x = 0,
        y = 0,
        tracker = nil
    }
end
