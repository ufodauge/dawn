---@class ECS.BubbleComponent
---@field direction "up"|"down"|"left"|"right"


---@param args table?
---@return ECS.BubbleComponent
return function(args)
    return {
        direction = (args and args.direction) and args.direction or 'up',
        amplitude = (args and args.amplitude) and args.amplitude or 10,
    }
end
