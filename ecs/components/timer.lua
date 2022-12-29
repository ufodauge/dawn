---@class ECS.TimerComponent
---@field time number
---@field running boolean


---@param args {time: number?}
---@return ECS.TimerComponent
return function(args)
    return love.lume.merge({
        time = 0,
        running = true
    }, args or {})
end
