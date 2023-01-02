---@param args {w: number, h: number, rx: number, ry: number}
---@return ECS.Component
return function(args)
    return {
        w  = args.w  or 1,
        h  = args.h  or 1,
        rx = args.rx or 1,
        ry = args.ry or 1
    }
end
