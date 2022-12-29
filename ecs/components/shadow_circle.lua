---@class ECS.ShadowBodyComponent

---@param args {r: number, a: number, mul: number}
---@return ECS.ShadowBodyComponent
return function(args)
    return {
        r    = args and args.r or nil,
        a    = args and args.a or nil,
        mul  = args and args.mul or nil,
        body = nil
    }
end
