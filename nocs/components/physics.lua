---@class ECS.PhysicsComponent
---@field body    love.Body
---@field fixture love.Fixture


---@param args any
---@return ECS.PhysicsComponent
return function(args)
    return {
        body    = nil,
        fixture = nil
    }
end
