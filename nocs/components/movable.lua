---@param args {to_x: number, to_y: number, duration: number, easing: string}
---@return ECS.Component
return function(args)
    return {
        to_x     = (args and args.to_x) and args.to_x or 0,
        to_y     = (args and args.to_y) and args.to_y or 0,
        from_x   = 0,
        from_y   = 0,
        duration = (args and args.duration) and args.duration or 2,
        easing   = (args and args.easing) and args.easing or 'quadinout',
        timer    = 0,
        ongoing  = true,
        result   = 0
    }
end
