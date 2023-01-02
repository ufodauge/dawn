---@class ECS.LightComponent

---@param args {r: number, a: number, mul: number}
---@return ECS.LightComponent
return function(args)
    return {
        r    = args and args.r or nil,
        a    = args and args.a or nil,
        mul  = args and args.mul or nil,
        body = nil
    }
end
